import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
import 'package:quality_management_system/Core/Widgets/Custom_Button_widget.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/screen/addOrderItems.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/file_upload_widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view_model/add_order_cubit.dart';

class EditOrderScreen extends StatefulWidget {
  final OrderModel order;
  final List<OrderItem> orderItems;

  const EditOrderScreen({super.key, required this.order, required this.orderItems});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late TextEditingController _companyNameController;
  late TextEditingController _supplyNumberController;
  late TextEditingController _attachmentTypeController;
  List<OrderItem> _editedOrderItems = [];
  List<OrderItem> _originalOrderItems = [];
  late String _orderStatus;

  List<FileAttachment> _attachments = [];
  List<FileAttachment> _attachmentsOrder = [];
  List<String> attachmentTypeOptions = ['رسم', 'عينه'];

  final Map<String, bool> _modifiedFields = {};

  List<FileAttachment> mapUrlsToAttachments(List<String> urls) {
    return urls.map((url) {
      final uri = Uri.parse(url);
      final fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'unknown';
      return FileAttachment(
        fileName: fileName,
        filePath: url,
        fileSize: 0,
        fileData: null,
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _companyNameController = TextEditingController(text: widget.order.companyName);
    _supplyNumberController = TextEditingController(text: widget.order.supplyNumber);
    _attachmentTypeController = TextEditingController(text: widget.order.attachmentType);

    // Initialize order items - create a deep copy to avoid reference issues
    _editedOrderItems = widget.orderItems.map((item) => OrderItem(
      id: item.id,
      operationDescription: item.operationDescription,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      status: item.status,
      notes: item.notes,
      materialType: item.materialType,
    )).toList();

    // Store original items for comparison
    _originalOrderItems = widget.orderItems.map((item) => OrderItem(
      id: item.id,
      operationDescription: item.operationDescription,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      status: item.status,
      notes: item.notes,
      materialType: item.materialType,
    )).toList();

    // Set initial status
    _orderStatus = widget.order.orderStatus;

    // Initialize attachments
    _attachments = mapUrlsToAttachments(widget.order.attachmentLinks ?? []);
    _attachmentsOrder = mapUrlsToAttachments(widget.order.attachmentOrderLinks ?? []);

    // Add listeners for text controllers
    _companyNameController.addListener(() {
      if (_companyNameController.text != widget.order.companyName) {
        setState(() {
          _modifiedFields['companyName'] = true;
        });
      }
    });

    _supplyNumberController.addListener(() {
      if (_supplyNumberController.text != widget.order.supplyNumber) {
        setState(() {
          _modifiedFields['supplyNumber'] = true;
        });
      }
    });

    _attachmentTypeController.addListener(() {
      if (_attachmentTypeController.text != widget.order.attachmentType) {
        setState(() {
          _modifiedFields['attachmentType'] = true;
        });
      }
    });

    // If items are empty, mark as modified to ensure proper handling
    if (_editedOrderItems.isEmpty) {
      _modifiedFields['items'] = true;
    }
  }

  // Enhanced method to check if items have been modified
  bool _hasItemsChanged() {
    if (_originalOrderItems.length != _editedOrderItems.length) {
      return true;
    }

    for (int i = 0; i < _originalOrderItems.length; i++) {
      if (_originalOrderItems[i].id != _editedOrderItems[i].id ||
          _originalOrderItems[i].operationDescription != _editedOrderItems[i].operationDescription ||
          _originalOrderItems[i].quantity != _editedOrderItems[i].quantity ||
          _originalOrderItems[i].unitPrice != _editedOrderItems[i].unitPrice ||
          _originalOrderItems[i].status != _editedOrderItems[i].status ||
          _originalOrderItems[i].notes != _editedOrderItems[i].notes) {
        return true;
      }
    }

    return false;
  }

  // Alternative: Load items from Firestore if needed
  Future<void> _loadOrderItems() async {
    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc(widget.order.id);
      final itemsSnapshot = await orderRef.collection('items').get();

      final List<OrderItem> loadedItems = itemsSnapshot.docs.map((doc) {
        return OrderItem.fromMap(doc.data());
      }).toList();

      setState(() {
        _editedOrderItems = loadedItems;
        _originalOrderItems = List<OrderItem>.from(loadedItems);
      });
    } catch (e) {
      print('Error loading order items: $e');
      // Handle error appropriately
    }
  }

  // Enhanced save method with proper items tracking
  Future<void> _saveChanges() async {
    final cubit = context.read<AddNewOrderCubit>();
    final Map<String, dynamic> updatedFields = {};

    updatedFields['orderId'] = widget.order.id;
    updatedFields['orderNumber'] = widget.order.orderNumber;

    if (_modifiedFields['companyName'] == true) {
      updatedFields['companyName'] = _companyNameController.text;
    }

    if (_modifiedFields['supplyNumber'] == true) {
      updatedFields['supplyNumber'] = _supplyNumberController.text;
    }

    if (_modifiedFields['attachmentType'] == true) {
      updatedFields['attachmentType'] = _attachmentTypeController.text;
    }

    if (_modifiedFields['orderStatus'] == true) {
      updatedFields['orderStatus'] = _orderStatus;
    }

    if (_modifiedFields['attachments'] == true) {
      updatedFields['newAttachments'] = _attachments;
    }

    if (_modifiedFields['attachmentsOrder'] == true) {
      updatedFields['newAttachmentsOrder'] = _attachmentsOrder;
    }

    // Enhanced items checking
    if (_modifiedFields['items'] == true || _hasItemsChanged()) {
      updatedFields['items'] = _editedOrderItems;
    }

    // Always preserve existing ones
    updatedFields['existingAttachmentLinks'] = widget.order.attachmentLinks ?? [];
    updatedFields['existingAttachmentOrderLinks'] = widget.order.attachmentOrderLinks ?? [];

    await cubit.updateOrder(updatedFields);

    if (cubit.state is AddOrderSuccess) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _supplyNumberController.dispose();
    _attachmentTypeController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف "${_editedOrderItems[index].operationDescription}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _editedOrderItems.removeAt(index);
                _modifiedFields['items'] = true;
              });
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الطلب ${widget.order.orderNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Name Field
            CustomFormTextField(
              textEditingController: _companyNameController,
              hintText: 'أسم الشركه',
              title: 'أسم الشركه',
            ),
            const SizedBox(height: 16),

            // Supply Number Field
            CustomFormTextField(
              textEditingController: _supplyNumberController,
              hintText: 'رقم أمر التوريد',
              title: 'رقم أمر التوريد',
            ),
            const SizedBox(height: 16),

            // Attachment Type Radio Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('نوع المرفقات', style: Theme.of(context).textTheme.bodyMedium),
                Row(
                  children: attachmentTypeOptions.map((value) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(value),
                        value: value,
                        groupValue: _attachmentTypeController.text,
                        onChanged: (value) {
                          setState(() {
                            _attachmentTypeController.text = value!;
                            _modifiedFields['attachmentType'] = true;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // File Upload Widgets - Fixed version using LayoutBuilder
            LayoutBuilder(
              builder: (context, constraints) {
                double containerWidth = (constraints.maxWidth - 16) / 2; // 16 is the spacing

                return Row(
                  children: [
                    SizedBox(
                      width: containerWidth,
                      child: FileUploadWidget(
                        title: 'اضافه مرفقات الورشه',
                        attachments: _attachments,
                        onAttachmentsChanged: (files) {
                          setState(() {
                            _attachments = files;
                            _modifiedFields['attachments'] = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: containerWidth,
                      child: FileUploadWidget(
                        title: 'اضافه مرفقات تحصيل',
                        attachments: _attachmentsOrder,
                        onAttachmentsChanged: (files) {
                          setState(() {
                            _attachmentsOrder = files;
                            _modifiedFields['attachmentsOrder'] = true;
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Items Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'بنود الطلب',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push<List<OrderItem>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddOrderItemsScreen(
                                  initialItems: _editedOrderItems,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _editedOrderItems = result;
                                _modifiedFields['items'] = true;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('تعديل البنود'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_editedOrderItems.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'لا توجد بنود في هذا الطلب',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Items Summary
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              'إجمالي البنود: ${_editedOrderItems.length}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Items List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _editedOrderItems.length,
                        itemBuilder: (context, index) {
                          final item = _editedOrderItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                item.operationDescription,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الكمية: ${item.quantity}${item.unitPrice != null ? ' - ${item.unitPrice}' : ''}'),
                                  Text('الحالة: ${item.status}'),
                                  if (item.notes != null && item.notes!.isNotEmpty)
                                    Text('ملاحظات: ${item.notes}'),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteConfirmation(index);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('حذف'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            BlocBuilder<AddNewOrderCubit, AddNewOrderState>(
              builder: (context, state) {
                return CustomButton(
                  onTap: _saveChanges,
                  text: 'حفظ التغيرات',
                  isLoading: AddNewOrderCubit.get(context).isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}