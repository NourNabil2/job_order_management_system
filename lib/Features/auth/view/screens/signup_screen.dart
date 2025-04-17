import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/auth/view/widgets/drop_down_field.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';
import 'package:quality_management_system/Features/auth/view/widgets/text_form_field.dart';

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
  final confirmPasswordController = TextEditingController();
  final userRoleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    userRoleController.dispose();
    super.dispose();
  }

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - SizeApp.logoSize,
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
                      vertical: SizeApp.defaultPadding * 6),
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
                          // Name
                          CustomFormTextField(
                            textEditingController: emailController,
                            hintText: "Name",
                            title: 'Name',
                            icon: Icons.email_rounded,
                          ),
                          const SizedBox(height: 10),
                          // Drop Down to Select Role
                          CustomDropdownFormField(
                            items: [
                              DropdownMenuItem(
                                  value: 'sales',
                                  child: Text(
                                    'Sales',
                                    style: appTextTheme.bodyMedium,
                                  )),
                              DropdownMenuItem(
                                  value: 'admin',
                                  child: Text(
                                    'admin',
                                    style: appTextTheme.bodyMedium,
                                  )),
                            ],
                            hint: "Select Role",
                            icon: Icons.person,
                            onChanged: (value) {
                              setState(() =>
                                  userRoleController.text = value.toString());
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

                            textEditingController: passwordController,
                            hintText: "Password",
                            icon: Icons.password_rounded,
                          ),
                          const SizedBox(height: 10),
                          CustomFormTextField(
                            obscureText: confirmPasswordVisible,
                            textEditingController: confirmPasswordController,
                            hintText: "Confirm Password",
                            iconObscureText: confirmPasswordVisible ? Icons.visibility_off_outlined :  Icons.visibility,
                            onPressedObscureText: () {
                              setState(() {
                                confirmPasswordVisible =
                                !confirmPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          FormButton(
                            loading: false,
                            text: "Sign Up",
                            onPressed: () {
                              if (signupKey.currentState!.validate()) {
                                // BlocProvider.of<SignUpCubit>(context).signUp(
                                //   email: emailController.text.trim(),
                                //   password: passwordController.text.trim(),
                                //   userName: nameController.text.trim(),
                                //   address: addressController.text.trim(),
                                //   phone: phoneController.text.trim(),
                                //   role: userRoleController.text.trim(),
                                // );
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
  }
}
