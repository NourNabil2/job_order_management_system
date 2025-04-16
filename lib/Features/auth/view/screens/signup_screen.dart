import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
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
                          CustomTextFormField(
                            controller: emailController,
                            hint: "Email",
                            icon: Icons.email_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter an email";
                              } else {
                                if (StringExtensions(value).isValidEmail()) {
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
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
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
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            obsecure: confirmPasswordVisible,
                            suffixIcon: confirmPasswordVisible
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        confirmPasswordVisible =
                                            !confirmPasswordVisible;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        confirmPasswordVisible =
                                            !confirmPasswordVisible;
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.visibility_off_outlined),
                                  ),
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            icon: Icons.password_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != passwordController.text) {
                                return "Passwords are not matching";
                              }
                              return null;
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
