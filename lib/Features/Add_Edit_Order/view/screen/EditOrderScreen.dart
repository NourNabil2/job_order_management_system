import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/file_upload_widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view_model/add_order_cubit.dart';

class EditOrderScreen extends StatefulWidget {
  final OrderModel order;

  const EditOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late TextEditingController _companyNameController;
  late TextEditingController _supplyNumberController;
  late TextEditingController _attachmentTypeController;
  late String _selectedDate;
  late String _orderStatus;
  List<FileAttachment> _attachments = [];
  List<FileAttachment> _attachmentsOrder = [];

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.order.companyName);
    _supplyNumberController = TextEditingController(text: widget.order.supplyNumber);
    _attachmentTypeController = TextEditingController(text: widget.order.attachmentType);
    _selectedDate = widget.order.dateLine;
    _orderStatus = widget.order.orderStatus;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _supplyNumberController.dispose();
    _attachmentTypeController.dispose();
    super.dispose();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  //   }
  // }

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
            TextFormField(
              controller: _companyNameController,
              decoration: const InputDecoration(labelText: 'Company Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _supplyNumberController,
              decoration: const InputDecoration(labelText: 'Supply Number'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _attachmentTypeController,
              decoration: const InputDecoration(labelText: 'Attachment Type'),
            ),
            // ListTile(
            //   title: Text('Delivery Date: ${_selectedDate.toLocal()}'),
            //   trailing: const Icon(Icons.calendar_today),
            //   onTap: () => _selectDate(context),
            // ),
            const SizedBox(height: 24),
         Row(
           children: [
             FileUploadWidget(
               title: 'Workshop Attachments',
               attachments: _attachments,
               onAttachmentsChanged: (files) {
                 setState(() {
                   _attachments = files;
                 });
               },
             ),
             const SizedBox(width: 16),
             FileUploadWidget(
               title: 'Order Documents',
               attachments: _attachmentsOrder,
               onAttachmentsChanged: (files) {
                 setState(() {
                   _attachmentsOrder = files;
                 });
               },
             ),
           ],
         ),
            const SizedBox(height: 32),
            BlocBuilder<AddNewOrderCubit, AddNewOrderState>(
              builder: (context, state) {
                if (state is AddOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {

// In your edit order screen:
    final cubit = context.read<AddNewOrderCubit>();
    await cubit.updateOrder(
      orderId: widget.order.id,
      orderNumber: widget.order.orderNumber,
      companyName: _companyNameController.text,
      supplyNumber: _supplyNumberController.text,
      attachmentType: _attachmentTypeController.text,
      orderStatus: _orderStatus,
      newAttachments: _attachments,
      newAttachmentsOrder: _attachmentsOrder,
      existingAttachmentLinks: widget.order.attachmentLinks,
      existingAttachmentOrderLinks: widget.order.attachmentOrderLinks,
    );

    if (cubit.state is AddOrderSuccess) {
      Navigator.of(context).pop(true); // Return true to indicate success
    }
  }
}