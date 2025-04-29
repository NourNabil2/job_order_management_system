import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
import 'package:quality_management_system/Core/components/snackbar.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signup_cubit/signup_cubit.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final resetPasswordKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  bool passwordsMatching = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          showCustomSnackBar(context, state.message);
        } else if (state is SignupSuccess) {
          showCustomSnackBar(context, "Password Reset Successfuly");
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
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
                          key: resetPasswordKey,
                          child: SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  "Choose a new password",
                                  style: appTextTheme.titleMedium!
                                      .copyWith(color: ColorApp.primaryColor),
                                ),
                                const SizedBox(height: 30),
                                CustomFormTextField(
                                  obscureText: passwordVisible,
                                  iconObscureText: passwordVisible? Icons.visibility : Icons.visibility_off_outlined,
                                  onPressedObscureText: () {
                                    setState(() {
                                      passwordVisible =
                                      !passwordVisible;
                                    });
                                  },
                                  textEditingController: passwordController,
                                  hintText: "Password",
                                  icon: Icons.password_rounded,
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  obscureText: confirmPasswordVisible,
                                  iconObscureText: confirmPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                                  textEditingController: confirmPasswordController,
                                  onPressedObscureText: () {
                                    setState(() {
                                      confirmPasswordVisible =
                                      !confirmPasswordVisible;
                                    });
                                  },
                                  hintText: "Confirm Password",
                                  icon: Icons.password_rounded,
                                ),
                                const SizedBox(height: 20),
                                FormButton(
                                  loading: state is SignupLoading,
                                  text: "Sign in",
                                  onPressed: () {
                                    if (resetPasswordKey.currentState!
                                        .validate()) {
                                      context.read<SignupCubit>().signup(
                                          widget.email!,
                                          passwordController.text);
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
          ),
        );
      },
    );
  }
}
