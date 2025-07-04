import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/Custom_Button_widget.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/file_upload_widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/InvoiceScreen.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/AttachmentListViewer.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/OrderSummary_Card.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/SectionHeaderSelected.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/Item_details/item_details_cubit.dart';
import 'widgets/OrderItem_Card.dart';
import 'widgets/ProgressChart_widget.dart';
import 'widgets/StatisticsRow_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class OrderItemsDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final String orderId;

  const OrderItemsDetailsScreen({
    Key? key,
    required this.order,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderItemsDetailsScreen> createState() => _OrderItemsDetailsScreenState();
}

class _OrderItemsDetailsScreenState extends State<OrderItemsDetailsScreen> {
  late Future<List<OrderItem>> _itemsFuture;
  List<OrderItem> _selectedItems = [];
  List<FileAttachment> _attachments = [];
  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItemsForOrder();
  }

  Future<List<OrderItem>> _fetchItemsForOrder() async {
    return context.read<ItemDetailsCubit>().getOrderItems(widget.orderId);
  }
  void _updateAttachments(List<FileAttachment> attachments) {
    setState(() {
      _attachments = attachments;
    });
  }

  Future<void> _updateItemStatus(OrderItem item, String newStatus, String itemName ) async {
    try {
      await context.read<ItemDetailsCubit>().updateItemStatus(
        widget.orderId,
        item.id,
        newStatus,
        itemName
      );
      setState(() {
        _itemsFuture = _fetchItemsForOrder();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: ${e.toString()}')),
      );
    }
  }


  Future<void> _updateOrderStatus(OrderModel item, String newStatus) async {
    try {
      await context.read<ItemDetailsCubit>().updateOrderStatus(
        widget.orderId,
        item.id,
        newStatus,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: ${e.toString()}')),
      );
    }
  }

  void _toggleItemSelection(OrderItem item, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedItems.add(item);
      } else {
        _selectedItems.remove(item);
      }
    });
  }

  void _createInvoiceForSelectedItems() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceScreen(
          order: widget.order,
          items: _selectedItems,
        ),
      ),
    );
  }

  Map<String, int> _calculateStatusCounts(List<OrderItem> items) {
    final Map<String, int> counts = {
      'Pending': 0,
      'In Progress': 0,
      'Completed': 0,
      'Total': items.length,
    };

    for (var item in items) {
      if (counts.containsKey(item.status)) {
        counts[item.status] = (counts[item.status] ?? 0) + 1;
      }
    }

    return counts;
  }

  double _calculateCompletionPercentage(Map<String, int> statusCounts) {
    if (statusCounts['Total'] == 0) return 0.0;
    return (statusCounts['Completed'] ?? 0) / statusCounts['Total']! * 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'تفاصيل أمر التوريد', icon: AssetsManager.backtIcon,onTap: () => Navigator.pop(context),),
      body: FutureBuilder<List<OrderItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          final statusCounts = _calculateStatusCounts(items);
          final completionPercentage = _calculateCompletionPercentage(statusCounts);

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _itemsFuture = _fetchItemsForOrder();
              });
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      OrderSummaryCard(order: widget.order, theme: theme, onStatusChanged: (value) => _updateOrderStatus(widget.order,value),statusOptions: CacheSaver.userRole == 'collector' ? const ['Completed','Collected'] : CacheSaver.userRole == 'workShop' ? const ['Pending','in_progress']  : const ['Pending', 'in_progress', 'Completed', 'Collected', 'rejected'],),
                      if (CacheSaver.userRole == 'admin' || CacheSaver.userRole == 'collector' ) Row(
                        children: [
                          FileUploadWidget(
                            attachments: _attachments,
                            onAttachmentsChanged: _updateAttachments,
                            title: 'مرفق التحصيل',
                          ),
                        ],
                      ),
                      if (_attachments.isNotEmpty) CustomButton(text: 'ارسال',onTap: () {
                        ItemDetailsCubit.get(context).sendAttachment(orderId: widget.orderId, attachments: _attachments);
                      }),
                      const SizedBox(height: 20),
                      if (CacheSaver.userRole == 'admin' || CacheSaver.userRole == 'collector' ) AttachmentGridViewer(attachmentLinks: widget.order.attachmentPO,title: 'مرفقات التحصيل',),
                        const SizedBox(height: 20),
                      StatisticsRow( statusCounts: statusCounts, completionPercentage: completionPercentage, theme: theme,),
                      const SizedBox(height: 20),
                      ProgressChart(statusCounts: statusCounts),
                      const SizedBox(height: 20),
                      AttachmentGridViewer(attachmentLinks: widget.order.attachmentLinks,title: 'مرفقات الورشه',),
                      const SizedBox(height: 20),
                      if (CacheSaver.userRole != 'workShop') AttachmentGridViewer(attachmentLinks: widget.order.attachmentOrderLinks, title: 'مرفقات أمر التوريد',),
                      const SizedBox(height: 20),
                      buildSectionHeader('Order Items', _selectedItems.length),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver:  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = items[index];
                        final isSelected = _selectedItems.contains(item);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: OrderItemCard(item: item, isSelected: isSelected, theme: theme,
                            onSelectionChanged: (value) => _toggleItemSelection(item,value),
                            onStatusChanged: (value) => _updateItemStatus(item,value,item.operationDescription),
                          ),
                        );
                      },
                      childCount: items.length,
                    ),
                  )
                     ,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80), // Space for bottom button
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () => _printInvoice(context),
        icon: const Icon(Icons.receipt_long),
        label: Text('Print (${_selectedItems.length})'),
        backgroundColor: theme.primaryColor,
      )
          : null,
    );
  }

  // Method to generate and print invoice PDF
  Future<void> _printInvoice(BuildContext context) async {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicBoldFont = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header with company name and logo
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'كوالتي للصناعات الهندسية',
                          style: pw.TextStyle(
                            font: arabicBoldFont,
                            fontSize: 18,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Text(
                          'تصنيع قطع غيار وأجزاء ميكانيكية',
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 14,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'QE',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Quality For Engineering Industries',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Machining & Manufacturing Spare Parts',
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),

                // Order info box
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'تاريخ التسليم:  ${widget.order.dateLine}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            'اذن تشغيل منتج رقم:    ${widget.order.orderNumber}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'المرفقات:  ${widget.order.attachmentType}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            'التاريخ:  ${DateFormatter.formatDate(DateTime.now())}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),

                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'أمر التوريد:  ${widget.order.supplyNumber}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            'إسم الشركة:  ${widget.order.companyName}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),

                // Items Table
                _buildItemsTablePDF(arabicFont, arabicBoldFont),

                pw.SizedBox(height: 40),

                // Signatures
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'مسؤول الورشة',
                          style: pw.TextStyle(font: arabicBoldFont),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Text(
                          'التوقيع / ____________',
                          style: pw.TextStyle(font: arabicFont),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ],
                    ),
                  ],
                ),

                pw.Spacer(),

                // Footer
                pw.Center(
                  child: pw.Text(
                    'الإدارة والمصانع: القاهرة - مدينة العبور - المنطقة الصناعية - الامتداد الغربي - قطعة رقم 6 بلوك 20036',
                    style: pw.TextStyle(font: arabicFont, fontSize: 9),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Text(
                    'تليفون: 44810477(202+)     فاكس: 44810478(202+)     موبايل: 01001538045',
                    style: pw.TextStyle(fontSize: 9, font: arabicFont),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'أمر_تشغيل_${widget.order.orderNumber}.pdf',
    );
  }


  // Helper method to build the items table for PDF
  pw.Widget _buildItemsTablePDF(pw.Font arabicFont, pw.Font arabicBoldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: const {
          0: pw.FlexColumnWidth(4),
          1: pw.FlexColumnWidth(1.5),
          2: pw.FlexColumnWidth(4),
          3: pw.FlexColumnWidth(4),
          4: pw.FlexColumnWidth(1),
        },
        children: [
          // Table Header
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey300),
            children: [

              _buildTableCellPDF('ملاحظات', arabicBoldFont, isHeader: true, textAlign: pw.TextAlign.center),
              _buildTableCellPDF('العدد', arabicBoldFont, isHeader: true, textAlign: pw.TextAlign.center),
              _buildTableCellPDF('نوع الخام', arabicBoldFont, isHeader: true, textAlign: pw.TextAlign.center),
              _buildTableCellPDF('بيان العملية', arabicBoldFont, isHeader: true, textAlign: pw.TextAlign.center),
              _buildTableCellPDF('بند', arabicBoldFont, isHeader: true, textAlign: pw.TextAlign.center),

            ],
          ),

          // Table Content - Each Item
          ...List.generate(_selectedItems.length, (index) {
            final item = _selectedItems[index];
            return pw.TableRow(
              children: [

                _buildTableCellPDF(item.notes, arabicFont, textAlign: pw.TextAlign.right, isNotes: true),
                _buildTableCellPDF('${item.quantity}', arabicFont, textAlign: pw.TextAlign.center),
                _buildTableCellPDF(item.materialType, arabicFont, textAlign: pw.TextAlign.center),
                _buildTableCellPDF(item.operationDescription, arabicFont),
                _buildTableCellPDF('${index + 1}', arabicFont, textAlign: pw.TextAlign.center),

              ],
            );
          }),
        ],
      ),
    );
  }

  // Helper method to build PDF table cells with consistent styling
  pw.Widget _buildTableCellPDF(String text, font, {bool isHeader = false, pw.TextAlign textAlign = pw.TextAlign.left, bool isNotes = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      // زيادة المساحة المتاحة للكتابة في خانة الملاحظات
      height: isNotes ? 40 : null,
      alignment: isNotes ? pw.Alignment.topRight : null,
      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(
          font: font,
          fontWeight: isHeader ? pw.FontWeight.bold : null,
        ),
        textAlign: textAlign,
      ),
    );
  }

}

