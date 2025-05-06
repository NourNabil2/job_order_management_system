import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class ReviewStep extends StatefulWidget {
 // final String orderNumber;
  final String companyName;
  final String? attachmentType;
  final String supplyNumber;
  final String? status;
  final List<OrderItem> orderItems;
  final List<FileAttachment> attachments;
  final Function(List<FileAttachment>) onAttachmentsChanged;

  const ReviewStep({
    Key? key,
  //  required this.orderNumber,
    required this.companyName,
    required this.attachmentType,
    required this.supplyNumber,
    required this.status,
    required this.orderItems,
    this.attachments = const [],
    required this.onAttachmentsChanged,
  }) : super(key: key);

  @override
  _ReviewStepState createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Order Information'),
          _buildInfoCard([
          //  _buildInfoRow('Order Number', widget.orderNumber),
            _buildInfoRow('Company Name', widget.companyName),
            _buildInfoRow('Supply Number', widget.supplyNumber),
            _buildInfoRow('Status', widget.status ?? ''),
            _buildInfoRow('Attachment Type', widget.attachmentType ?? ''),
          ]),
           SizedBox(height: SizeApp.s16),

          _buildSectionTitle('Order Items'),
          _buildItemsTable(),
           SizedBox(height: SizeApp.s16),

          _buildSectionTitle('Order Summary'),
          _buildOrderSummary(),
           SizedBox(height: SizeApp.s16),

          // File upload widget
          FileUploadWidget(
            attachments: widget.attachments,
            onAttachmentsChanged: widget.onAttachmentsChanged,
          ),
           SizedBox(height: SizeApp.s16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: SizeApp.s8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding:  EdgeInsets.all(SizeApp.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: SizeApp.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding:  EdgeInsets.all(SizeApp.defaultPadding),
        child: widget.orderItems.isEmpty
            ? const Center(child: Text('No items added'))
            : Column(
          children: [
            _buildTableHeader(),
            const Divider(),
            ...widget.orderItems.map((item) => _buildItemRow(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            'Item',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Quantity',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Unit Price',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Total',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow(OrderItem item) {
    final total = item.quantity * item.unitPrice;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeApp.s4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(item.operationDescription),
          ),
          Expanded(
            flex: 2,
            child: Text(item.quantity.toString()),
          ),
          Expanded(
            flex: 2,
            child: Text('${item.unitPrice.toStringAsFixed(2)}'),
          ),
          Expanded(
            flex: 2,
            child: Text('${total.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    double subTotal = 0;
    for (var item in widget.orderItems) {
      subTotal += item.quantity * item.unitPrice;
    }

    final tax = subTotal * 0.14; // Assuming 14% tax
    final total = subTotal + tax;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(SizeApp.defaultPadding),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', '${subTotal.toStringAsFixed(2)}'),
            _buildSummaryRow('Tax (14%)', '${tax.toStringAsFixed(2)}'),
            const Divider(),
            _buildSummaryRow('Total', '${total.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeApp.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}