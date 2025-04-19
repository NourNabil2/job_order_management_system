import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/components/snackbar.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signin_cubit/signin_cubit.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signup_cubit/signup_cubit.dart';
import 'package:quality_management_system/Features/auth/view/screens/reset_password_screen.dart';
import 'package:quality_management_system/Features/auth/view/widgets/form_button.dart';
import 'package:quality_management_system/Features/auth/view/widgets/text_form_field.dart';
import 'package:quality_management_system/dependency_injection.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SigninCubit>(),
      child: BlocConsumer<SigninCubit, SigninState>(
        listener: (context, state) {
          if (state is SigninResetPassword) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider(
                create: (context) => sl<SignupCubit>(),
                child: ResetPasswordScreen(email: emailController.text,),
              );
            }));
          } else if (state is SigninFailure) {
            showCustomSnackBar(context, state.message);
          } else if (state is SigninSuccess) {
            showCustomSnackBar(context, "Login Successful");
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
                          key: signinKey,
                          child: SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  "Sign in",
                                  style: appTextTheme.titleMedium!
                                      .copyWith(color: ColorApp.primaryColor),
                                ),
                                const SizedBox(height: 30),
                                // Email
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
                                  loading: state is SigninLoading,
                                  text: "Sign in",
                                  onPressed: () {
                                    if (signinKey.currentState!.validate()) {
                                      context.read<SigninCubit>().signin(
                                          emailController.text,
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
          );
        },
      ),
    );
  }
}
