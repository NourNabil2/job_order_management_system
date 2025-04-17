import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
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
                          CustomFormTextField(
                            textEditingController: emailController,
                            hintText: "Email",
                            title: 'Email',
                            icon: Icons.email_rounded,
                          ),
                          const SizedBox(height: 10),
                          CustomFormTextField(
                            obscureText: passwordVisible,
                            textEditingController: passwordController,
                            hintText: "Password",
                            icon: Icons.password_rounded,
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
