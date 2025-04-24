// basic_info_step.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/DeadLinePicker_Widget.dart';
import 'package:quality_management_system/Features/auth/view/widgets/text_form_field.dart';

class BasicInfoStep extends StatelessWidget {
  final TextEditingController orderNumberController;
  final TextEditingController companyNameController;
  final TextEditingController supplyNumberController;
  final String? selectedAttachmentType;
  String? selectedStatus;
  final DateTime? selectedDeadline;
  final List<String> attachmentTypeOptions;
  final List<String> statusOptions;
  final VoidCallback onPickDate;
  final ValueChanged<String?> onAttachmentTypeChanged;
  final ValueChanged<String?> onStatusChanged;

  final FocusNode companyName = FocusNode();
  final FocusNode orderNumber = FocusNode();
  final FocusNode supplyNumber = FocusNode();


  BasicInfoStep({
    super.key,
    required this.orderNumberController,
    required this.companyNameController,
    required this.supplyNumberController,
    required this.selectedAttachmentType,
    required this.selectedDeadline,
    required this.selectedStatus,
    required this.attachmentTypeOptions,
    required this.statusOptions,
    required this.onPickDate,
    required this.onAttachmentTypeChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    String? selectedStatus1;
    return ResponsiveBuilder(
      mobileBuilder: (p0) => Padding(
        padding: EdgeInsets.all(SizeApp.defaultPadding),
        child: Column(
          children: [
            CustomFormTextField(
              textEditingController: orderNumberController,
              title: 'رقم إذن تشغيل المنتج',
              hintText: 'رقم إذن تشغيل المنتج',
            ),
            const SizedBox(height: 16),
            CustomFormTextField(
              textEditingController: companyNameController,
              title: 'أسم الشركه',
              hintText: 'أسم الشركه',
            ),
            const SizedBox(height: 16),
            CustomFormTextField(
              textEditingController: supplyNumberController,
              title: 'رقم أمر التوريد',
              hintText: 'رقم أمر التوريد',
            ),
            DropdownButtonFormField<String>(
              value: selectedAttachmentType,
              decoration: const InputDecoration(labelText: 'Attachment Type'),
              items: attachmentTypeOptions
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: onAttachmentTypeChanged,
            ),
            const SizedBox(height: 16),
            CustomFormTextField(
              textEditingController: supplyNumberController,
              title: 'رقم أمر التوريد',
              hintText: 'رقم أمر التوريد',
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(selectedDeadline == null
                  ? 'Select Delivery Deadline'
                  : 'Deadline: ${DateFormat('yyyy-MM-dd').format(selectedDeadline!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: onPickDate,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(labelText: 'Order Status'),
              items: statusOptions
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: onStatusChanged,
            ),
          ],
        ),
      ),
      desktopBuilder: (p0) => Padding(
        padding: EdgeInsets.all(SizeApp.defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    textEditingController: supplyNumberController,
                    title: 'رقم أمر التوريد',
                    hintText: 'رقم أمر التوريد',
                    focusNode: supplyNumber,
                    nextFocusNode: companyName,
                  ),
                ),
                SizedBox(width: SizeApp.s16),
                Expanded(
                  child: CustomFormTextField(
                    textEditingController: orderNumberController,
                    title: 'رقم إذن تشغيل المنتج',
                    hintText: 'رقم إذن تشغيل المنتج',
                    focusNode: orderNumber,
                    nextFocusNode: supplyNumber,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomFormTextField(
                    textEditingController: companyNameController,
                    title: 'أسم الشركه',
                    hintText: 'أسم الشركه',
                    focusNode: companyName,

                  ),
                ),
                SizedBox(width: SizeApp.s16),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('نوع المرفقات',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Row(
                        children: [
                          ...attachmentTypeOptions.map(
                            (value) => Expanded(
                              child: RadioListTile<String>(
                                title: Text(value),
                                value: value,
                                groupValue: selectedAttachmentType,
                                onChanged: onAttachmentTypeChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (selectedAttachmentType == null)
                        const Text('Required',
                            style: TextStyle(color: Colors.red)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: SizeApp.s16),
            Row(
              children: [
                Expanded(
                  child: DeadlinePickerTile(
                    selectedDeadline: selectedDeadline,
                    onPickDate: onPickDate,
                  ),
                ),
                SizedBox(width: SizeApp.s16),
                Expanded(
                  child: CustomDropMenu(
                      label: 'حاله التسليم',
                      value: selectedStatus,
                      options: statusOptions,
                      onChanged: (val) => selectedStatus = val),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
