import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Serviecs/Firebase_Notification.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/CustomIcon.dart';
import 'package:quality_management_system/Core/Widgets/Custom_Button_widget.dart';
import 'package:quality_management_system/Core/components/DialogAlertMessage.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/AddItemsStep.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/ReviewStep.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/basic_info_step.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view_model/add_order_cubit.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/screen/addOrderItems.dart';


class AddOrderScreen extends StatefulWidget {
  final Function(OrderModel) onOrderAdded;

  const AddOrderScreen({Key? key, required this.onOrderAdded}) : super(key: key);

  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  //final _orderNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _supplyNumberController = TextEditingController();
  final _itemCountController = TextEditingController();

  DateTime? _selectedDeadline;
  String? _selectedStatus;
  String? _selectedAttachmentType;
  List<OrderItem> _orderItems = [];
  List<FileAttachment> _attachments = [];
  int _currentStep = 0;


  final List<String> stepIcons = [
    AssetsManager.orderIcon,
    AssetsManager.addItemsIcon,
    AssetsManager.reviewIcon,
  ];

  final List<String> _statusOptions = [
    'Pending',
    'in_progress',
    'delivered',
    'rejected',
    'completed',
  ];

  final List<String> _attachmentTypeOptions = ['رسم', 'عينه'];

  @override
  void dispose() {
   // _orderNumberController.dispose();
    _companyNameController.dispose();
    _supplyNumberController.dispose();
    _itemCountController.dispose();
    super.dispose();
  }

  void _openDatePicker() async {
    final picked = await DateFormatter.selectDeadlineDate(context: context);
    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select delivery deadline')),
      );
      return;
    }
    if (_selectedAttachmentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select attachment type')),
      );
      return;
    }
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Status')),
      );
      return;
    }

    context.read<AddNewOrderCubit>().addOrder(
    //  orderNumber: _orderNumberController.text,
      companyName: _companyNameController.text,
      attachmentType: _selectedAttachmentType!,
      supplyNumber: _supplyNumberController.text,
      dateLine: _selectedDeadline!,
      orderStatus: _selectedStatus!,
      items: _orderItems,
      attachments: _attachments,
    );
  }

  void _updateAttachments(List<FileAttachment> attachments) {
    setState(() {
      _attachments = attachments;
    });
  }

  List<Step> _buildSteps() {
    return [
      // Step 1: Basic Information
      Step(
        title: Text('Order Information',style: Theme.of(context).textTheme.titleLarge,),
        content: BasicInfoStep(
         // orderNumberController: _orderNumberController,
          companyNameController: _companyNameController,
          supplyNumberController: _supplyNumberController,
          selectedAttachmentType: _selectedAttachmentType,
          selectedStatus: _selectedStatus,
          selectedDeadline: _selectedDeadline,
          attachmentTypeOptions: _attachmentTypeOptions,
          statusOptions: _statusOptions,
          onPickDate: _openDatePicker,
          onAttachmentTypeChanged: (val) => setState(() => _selectedAttachmentType = val),
          onStatusChanged: (val) => setState(() => _selectedStatus = val),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),

      // Step 2: Add Items
      Step(
        title: Text('Add Items' , style: Theme.of(context).textTheme.titleLarge,),
        content: AddItemsStep(
          orderItems: _orderItems,
          onAddEditPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOrderItemsScreen(initialItems: _orderItems),
              ),
            );
            if (result != null && result is List<OrderItem>) {
              setState(() => _orderItems = result);
            }
          },
          onRemoveItem: (item) => setState(() => _orderItems.remove(item)),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),

      // Step 3: Review & Submit
      Step(
        title: Text('Review',style: Theme.of(context).textTheme.titleLarge,),
        content: ReviewStep(
          //orderNumber: _orderNumberController.text,
          companyName: _companyNameController.text,
          attachmentType: _selectedAttachmentType,
          supplyNumber: _supplyNumberController.text,
          status: _selectedStatus,
          orderItems: _orderItems,
          attachments: _attachments,
          onAttachmentsChanged: _updateAttachments,
        ),
        isActive: _currentStep >= 2,
        state: StepState.indexed,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewOrderCubit, AddNewOrderState>(
        listener: (context, state) {
          if (state is AddOrderSuccess)
          {
            NotificationHelper.sendNotificationToAllUsers(title: 'أمر توريد جديد', body: 'هناك أمر توريد جديد', topic: 'all_users');
            Navigator.pop(context,);
            showCustomAlert(isSuccess: true, onConfirm: () {

            }, context: context,);
          } else if (state is AddOrderError)
          {
            showCustomAlert(isSuccess: false, onConfirm: () {

            }, context: context,);
          }
        },
        builder: (context, state) {
          return  Scaffold(
            appBar: const CustomAppBar(title: 'اضافه أمر توريد', icon: AssetsManager.invoiceIcon,),
            body: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                steps: _buildSteps(),
                stepIconBuilder: (stepIndex, stepState) {
                  String iconPath = stepIcons[stepIndex];
                  return CustomIcon(
                    assetPath: iconPath,
                    size: SizeApp.iconSizeLarge,
                    color: ColorApp.mainLight,
                  );
                },
                stepIconWidth: SizeApp.iconSizeLarge * 2 ,
                stepIconHeight: SizeApp.iconSizeLarge * 2,
                onStepContinue: () {
                  if (_currentStep == 0) {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  } else if (_currentStep == 1) {
                    if (_orderItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please add at least one item')),
                      );
                    } else {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  } else if (_currentStep == 2) {
                    _submitForm();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },

                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Padding(
                    padding: EdgeInsets.all(SizeApp.defaultPadding),
                    child: Row(
                      children: <Widget>[
                        CustomButton(text: _currentStep == 2 ? 'Submit' : 'Next',onTap: details.onStepContinue,width: SizeApp.s70,isLoading: AddNewOrderCubit.get(context).isLoading,),
                        SizedBox(width: SizeApp.s8),
                        if (_currentStep != 0)
                          CustomCancelButton(text: 'Back',onTap: details.onStepCancel,width: SizeApp.s70)

                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
    );
  }
}