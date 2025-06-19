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
        fileSize: 0, // Unknown size — you can update later if needed
        fileData: null, // You can load actual data later if needed
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.order.companyName);
    _supplyNumberController = TextEditingController(text: widget.order.supplyNumber);
    _attachmentTypeController = TextEditingController(text: widget.order.attachmentType);
    _editedOrderItems = List<OrderItem>.from(widget.orderItems); // local editable copy
    //_selectedDate = widget.order.dateLine;
    _orderStatus = widget.order.orderStatus;

    _attachments = mapUrlsToAttachments(widget.order.attachmentLinks ?? []);
    _attachmentsOrder = mapUrlsToAttachments(widget.order.attachmentOrderLinks ?? []);

    _companyNameController.addListener(() {
      if (_companyNameController.text != widget.order.companyName) {
        _modifiedFields['companyName'] = true;
      }
    });

    _supplyNumberController.addListener(() {
      if (_supplyNumberController.text != widget.order.supplyNumber) {
        _modifiedFields['supplyNumber'] = true;
      }
    });

    _attachmentTypeController.addListener(() {
      if (_attachmentTypeController.text != widget.order.attachmentType) {
        _modifiedFields['attachmentType'] = true;
      }
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _supplyNumberController.dispose();
    _attachmentTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order ${widget.order.orderNumber}'),
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
            CustomFormTextField(
              textEditingController: _companyNameController,
              hintText: 'أسم الشركه',
              title: 'أسم الشركه',
            ),
            const SizedBox(height: 16),
            CustomFormTextField(
              textEditingController: _supplyNumberController,
              hintText: 'رقم أمر التوريد',
              title: 'رقم أمر التوريد',
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('نوع المرفقات', style: Theme.of(context).textTheme.bodyMedium),
                Row(
                  children: attachmentTypeOptions.map(
                        (value) {
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
                    },
                  ).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
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
                Expanded(
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
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push<List<OrderItem>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddOrderItemsScreen(initialItems: _editedOrderItems),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _editedOrderItems = result;
                        _modifiedFields['items'] = true;
                      });
                    }
                  },
                  child: const Text('Add/Edit Items'),
                ),
                const SizedBox(height: 16),
                if (_editedOrderItems.isNotEmpty) ...[
                  const Text('Added Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._editedOrderItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return ListTile(
                      title: Text(item.operationDescription),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _editedOrderItems.removeAt(index);
                            _modifiedFields['items'] = true;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ],
            ),
          const SizedBox(height: 32),
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


    if (_modifiedFields['items'] == true) {
      updatedFields['items'] = _editedOrderItems;
    }

    // Always preserve existing ones
    updatedFields['existingAttachmentLinks'] = widget.order.attachmentLinks;
    updatedFields['existingAttachmentOrderLinks'] = widget.order.attachmentOrderLinks;

    await cubit.updateOrder(updatedFields);

    if (cubit.state is AddOrderSuccess) {
      Navigator.of(context).pop(true);
    }
  }
}
