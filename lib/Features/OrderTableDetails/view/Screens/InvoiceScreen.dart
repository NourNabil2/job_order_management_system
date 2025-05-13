import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';

class InvoiceScreen extends StatelessWidget {
  final OrderModel order;
  final List<OrderItem> items;

  const InvoiceScreen({
    Key? key,
    required this.order,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final formattedDate = DateFormatter.formatDate(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('أمر تشغيل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printInvoice(context),
            tooltip: 'طباعة أمر التشغيل',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'كوالتي للصناعات الهندسية',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            'تصنيع قطع غيار وأجزاء ميكانيكية',
                            style: TextStyle(fontSize: 14),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor.withOpacity(0.1),
                          border: Border.all(color: theme.primaryColor.withOpacity(0.5)),
                        ),
                        child: Center(
                          child: Text(
                            'QE',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Quality For Engineering Industries',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Machining & Manufacturing Spare Parts',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Info Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('التاريخ:    '),
                      Text('أمر تشغيل منتجات رقم:    ${order.orderNumber}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المرفقات:    ${order.attachmentType}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('تاريخ التسليم:    '),
                      Text('إسم الشركة:    ${order.companyName}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ميناء الوصول:    ---'),
                      Text('التسليم:    ${order.orderStatus}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items Table
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: const {
                  0: FlexColumnWidth(0.5),  // رقم
                  1: FlexColumnWidth(2),    // بيان العمليه
                  2: FlexColumnWidth(1),    // العدد
                  3: FlexColumnWidth(1.5),  // نوع الخام
                  4: FlexColumnWidth(2.5),  // ملاحظات - تم زيادة العرض هنا
                },
                children: [
                  // Table Header
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.grey),
                    children: [
                      _buildTableCell('م', isHeader: true, ),
                      _buildTableCell('بيان العمليه', isHeader: true,),
                      _buildTableCell('العدد', isHeader: true, ),
                      _buildTableCell('نوع الخام', isHeader: true, ),
                      _buildTableCell('ملاحظات', isHeader: true, ),
                    ],
                  ),

                  // Table Content - Each Item
                  ...List.generate(items.length, (index) {
                    final item = items[index];
                    return TableRow(
                      children: [
                        _buildTableCell('${index + 1}',),
                        _buildTableCell(item.materialType),
                        _buildTableCell('${item.quantity}'),
                        _buildTableCell(item.materialType),
                        _buildTableCell(item.notes),
                      ],
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Signatures
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'مسؤول المبيعات',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('التوقيع / ____________'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'مدير عام المصنع',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                    Text('التوقيع / ____________'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Footer
            const Center(
              child: Text(
                'الإدارة والمصانع: القاهرة - مدينة العبور - المنطقة الصناعية - الامتداد الغربي - قطعة رقم 6 بلوك 20036',
                style: TextStyle(fontSize: 10),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'تليفون: 44810477(202+)     فاكس: 44810478(202+)     موبايل: 01001538045',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build table cells with consistent styling
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Directionality(
        textDirection: TextDirection.rtl, // دعم اتجاه اللغة العربية
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        ),
      ),
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
                            'تاريخ التسليم:  ${order.dateLine}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            'اذن تشغيل منتج رقم:    ${order.orderNumber}',
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
                            'المرفقات:  ${order.attachmentType}',
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
                            'أمر التوريد:  ${order.supplyNumber}',
                            style: pw.TextStyle(font: arabicFont),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            'إسم الشركة:  ${order.companyName}',
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
      name: 'أمر_تشغيل_${order.orderNumber}.pdf',
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
          ...List.generate(items.length, (index) {
            final item = items[index];
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