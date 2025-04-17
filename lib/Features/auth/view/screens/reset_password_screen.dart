import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/components/snackbar.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signin_cubit/signin_cubit.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signup_cubit/signup_cubit.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';
import 'package:quality_management_system/Features/auth/view/widgets/text_form_field.dart';
import 'package:quality_management_system/dependency_injection.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

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
                                      return "Please confirm password";
                                    }
                                    if (value != passwordController.text) {
                                      return "Passwords must be matching";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                FormButton(
                                  loading: state is SignupLoading,
                                  text: "Sign in",
                                  onPressed: () {
                                    if (resetPasswordKey.currentState!
                                        .validate()) {
                                      context.read<SignupCubit>().signup(
                                          "ahmed@quality.com",
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
