import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/components/snackbar.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';
import 'package:quality_management_system/Features/auth/view/cubits/add_member_cubit/add_member_cubit.dart';
import 'package:quality_management_system/Features/auth/view/widgets/drop_down_field.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';
import 'package:quality_management_system/Features/auth/view/widgets/text_form_field.dart';
import 'package:quality_management_system/dependency_injection.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                                Text(
                                  "Add a new member",
                                  style: appTextTheme.titleMedium!
                                      .copyWith(color: ColorApp.primaryColor),
                                ),
                                const SizedBox(height: 30),
                                // Name
                                CustomTextFormField(
                                  controller: nameController,
                                  hint: "Name",
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a name";
                                    }
                                    if (value.length < 2) {
                                      return "Name must be at least 2 characters long";
                                    }
                                    if (value.length > 50) {
                                      return "Name must be less than 50 characters long";
                                    }
                                    return null;
                                  },
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
                                CustomTextFormField(
                                  controller: emailController,
                                  hint: "Email",
                                  icon: Icons.email_rounded,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter an email";
                                    } else {
                                      if (!StringExtensions(value)
                                          .isValidEmail()) {
                                        return "Please enter a valid email";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  obsecure: passwordVisible,
                                  suffixIcon: passwordVisible
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                          icon: const Icon(Icons.visibility),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.visibility_off_outlined),
                                        ),
                                  controller: passwordController,
                                  hint: "Password",
                                  icon: Icons.password_rounded,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a password";
                                    }
                                    if (value.length < 8) {
                                      return "Password must be at least 8 characters long";
                                    }
                                    if (value.length > 25) {
                                      return "Password must be less than 25 characters long";
                                    }
                                    return null;
                                  },
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
