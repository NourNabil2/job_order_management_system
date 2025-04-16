import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';
import 'package:quality_management_system/Features/auth/view/widgets/text_form_field.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenScreenState();
}

class _SigninScreenScreenState extends State<SigninScreen> {
  final signinKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                    key: signinKey,
                    child: SizedBox(
                      child: Column(
                        children: [
                          // Email
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

                          const SizedBox(height: 20),
                          FormButton(
                            loading: false,
                            text: "Sign Up",
                            onPressed: () {
                              if (signinKey.currentState!.validate()) {}
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
