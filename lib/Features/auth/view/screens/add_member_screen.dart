import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/CustomIcon.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
import 'package:quality_management_system/Core/components/snackbar.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';
import 'package:quality_management_system/Features/auth/view/cubits/add_member_cubit/add_member_cubit.dart';
import 'package:quality_management_system/Features/auth/view/widgets/drop_down_field.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';
import 'package:quality_management_system/dependency_injection.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final signupKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userRoleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    userRoleController.dispose();
    super.dispose();
  }

  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddMemberCubit>(),
      child: BlocConsumer<AddMemberCubit, AddMemberState>(
        listener: (context, state) {
          if (state is AddMemberFailure) {
            showCustomSnackBar(context, state.message);
          } else if (state is AddMemberSuccess) {
            showCustomSnackBar(context, "New Member Added Successfully");
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height - SizeApp.logoSize,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Center(
                    child: SizedBox(
                      width: 450,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeApp.defaultPadding * 3,
                            vertical: SizeApp.defaultPadding * 3),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeApp.borderRadius * 2),
                          color: ColorApp.blackColor40.withAlpha(200),
                        ),
                        child: Form(
                          key: signupKey,
                          child: SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomIcon(assetPath: AssetsManager.backtIcon,onTap: () => Navigator.pop(context),color: ColorApp.mainLight,),
                                    Text(
                                      "   Add a new member",
                                      style: appTextTheme.titleMedium!
                                          .copyWith(color: ColorApp.primaryColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // Name
                                CustomFormTextField(
                                  textEditingController: nameController,
                                  hintText: "Name",
                                  icon: Icons.person,
                                ),
                                const SizedBox(height: 10),
                                // Drop Down to Select Role
                                CustomDropdownFormField(
                                  items: [
                                    DropdownMenuItem(
                                        value: 'admin',
                                        child: Text(
                                          'Admin',
                                          style: appTextTheme.bodyMedium,
                                        )),
                                    DropdownMenuItem(
                                        value: 'workShop',
                                        child: Text(
                                          'Work Shop',
                                          style: appTextTheme.bodyMedium,
                                        )),
                                    DropdownMenuItem(
                                        value: 'collector',
                                        child: Text(
                                          'Collector',
                                          style: appTextTheme.bodyMedium,
                                        )),
                                    DropdownMenuItem(
                                        value: 'purchaseDepartment',
                                        child: Text(
                                          'Purchase Department',
                                          style: appTextTheme.bodyMedium,
                                        )),
                                  ],
                                  hint: "Select Role",
                                  icon: Icons.person,
                                  onChanged: (value) {
                                    setState(() => userRoleController.text =
                                        value.toString());
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select a role";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  textEditingController: emailController,
                                  hintText: "Email",
                                  icon: Icons.email_rounded,
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  obscureText: passwordVisible,
                                  iconObscureText: passwordVisible? Icons.visibility : Icons.visibility_off_outlined,
                                  textEditingController: passwordController,
                                  hintText: "Password",
                                  icon: Icons.password_rounded,
                                ),

                                const SizedBox(height: 20),
                                FormButton(
                                  loading: state is AddMemberLoading,
                                  text: "Add Member",
                                  onPressed: () {
                                    if (signupKey.currentState!.validate()) {
                                      BlocProvider.of<AddMemberCubit>(context)
                                          .addMember(
                                        nameController.text.trim(),
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        UserRoleExtension.fromString(
                                            userRoleController.text),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
