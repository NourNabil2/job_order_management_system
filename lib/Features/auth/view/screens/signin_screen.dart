import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/Widgets/CustomTextField_widget.dart';
import 'package:quality_management_system/Core/Widgets/Custom_Button_widget.dart';
import 'package:quality_management_system/Core/components/DialogAlertMessage.dart';
import 'package:quality_management_system/Core/components/snackbar.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/OrdersDetails.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signin_cubit/signin_cubit.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signup_cubit/signup_cubit.dart';
import 'package:quality_management_system/Features/auth/view/screens/reset_password_screen.dart';
import 'package:quality_management_system/Features/auth/view/widgets/rememberMe_widget.dart';
import 'package:quality_management_system/dependency_injection.dart';
import 'package:quality_management_system/navBar.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  static String id = 'SigninScreen';

  @override
  State<SigninScreen> createState() => _SigninScreenScreenState();
}

class _SigninScreenScreenState extends State<SigninScreen> {
  final signinKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool isRememberMe = false;

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
          listener: (context, state) async {
            if (state is SigninResetPassword) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => sl<SignupCubit>(),
                    child: ResetPasswordScreen(email: emailController.text),
                  ),
                ),
              );
            }

            else if (state is SigninFailure) {
              showCustomAlert(
                context: context,
                isSuccess: false,
                onConfirm: () {},
              );
              showCustomSnackBar(context, state.message);
            }

            else if (state is SigninSuccess) {

              // حفظ حالة تذكّر الدخول
              if (isRememberMe) {
                await CashSaver.saveData(key: 'isRememberMe', value: true);

              }
              // حفظ role في SharedPreferences
              await CashSaver.saveData(key: 'userRole', value: state.userData.role);
              log(' state.userData.role ${ state.userData.role}');
              // الانتقال إلى الصفحة الرئيسية
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Navbar(role: state.userData.role,)),
                    (route) => false,
              );

              showCustomAlert(
                context: context,
                isSuccess: true,
                onConfirm: () {},
              );
              showCustomSnackBar(context, "Login Successful");
            }
          },
        builder: (context, state) {
          return ResponsiveBuilder(
            mobileBuilder: (p0) => Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(SizeApp.defaultPadding * 2),
                  child: SizedBox(
                    width: 450,
                    child: Padding(
                      padding: EdgeInsets.all(SizeApp.defaultPadding * 3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo Section
                          const Icon(Icons.lock_person_rounded,
                            size: 60,
                            color: ColorApp.primaryColor,
                          ),
                          SizedBox(height: SizeApp.defaultPadding),
                          Text(
                            "Welcome Back",
                            style: appTextTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sign in to continue",
                            style: appTextTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: SizeApp.defaultPadding * 2),

                          // Form Section
                          Form(
                            key: signinKey,
                            child: Column(
                              children: [
                                // Email Field
                                CustomFormTextField(
                                  focusNode: emailFocusNode,
                                  nextFocusNode: passwordFocusNode,
                                  textEditingController: emailController,
                                  hintText: "Email",
                                  icon: Icons.email_rounded,
                                ),
                                SizedBox(height: SizeApp.defaultPadding),
                                // Password Field
                                CustomFormTextField(
                                  focusNode: passwordFocusNode,
                                  textEditingController: passwordController,
                                  obscureText: passwordVisible,
                                  onPressedObscureText: () {
                                    setState(() {
                                      passwordVisible =
                                      !passwordVisible;
                                    });
                                  },
                                  iconObscureText: passwordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility,
                                  hintText: "Password",
                                  icon: Icons.password_rounded,
                                ),

                                SizedBox(height: SizeApp.defaultPadding),
                                RememberMeRow(isRememberMe: true, onChanged: (value) {

                                },),
                                SizedBox(height: SizeApp.defaultPadding),
                                // Sign In Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: CustomButton(
                                    onTap: () {
                                      if (signinKey.currentState!.validate()) {
                                        context.read<SigninCubit>().signin(
                                          emailController.text,
                                          passwordController.text,
                                        );
                                      }
                                    },
                                    text: "SIGN IN",
                                    isLoading:  state is SigninLoading,
                                  ),)
                              ],
                            ),
                          ),

                          SizedBox(height: SizeApp.defaultPadding),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
            desktopBuilder: (p0) => Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      AssetsManager.backgroundImage, // your image path
                      fit: BoxFit.cover, // cover the whole screen
                    ),
                  ),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(SizeApp.defaultPadding * 2),
                        child: SizedBox(
                          width: 450,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(SizeApp.borderRadius * 3),
                            ),
                            color: ColorApp.mainLight.withOpacity(0.5),
                            child: Padding(
                              padding: EdgeInsets.all(SizeApp.defaultPadding * 3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Logo Section
                                  const Icon(Icons.lock_person_rounded,
                                    size: 60,
                                    color: ColorApp.primaryColor,
                                  ),
                                  SizedBox(height: SizeApp.defaultPadding),
                                  Text(
                                    "Welcome Back",
                                    style: appTextTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Sign in to continue",
                                    style: appTextTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: SizeApp.defaultPadding * 2),

                                  // Form Section
                                  Form(
                                    key: signinKey,
                                    child: Column(
                                      children: [
                                        // Email Field
                                        CustomFormTextField(
                                          focusNode: emailFocusNode,
                                          nextFocusNode: passwordFocusNode,
                                          textEditingController: emailController,
                                          hintText: "Email",
                                          icon: Icons.email_rounded,
                                        ),
                                        SizedBox(height: SizeApp.defaultPadding),
                                        // Password Field
                                        CustomFormTextField(
                                          focusNode: passwordFocusNode,
                                          textEditingController: passwordController,
                                          obscureText: passwordVisible,
                                          onPressedObscureText: () {
                                            setState(() {
                                              passwordVisible =
                                              !passwordVisible;
                                            });
                                          },
                                          iconObscureText: passwordVisible
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility,
                                          hintText: "Password",
                                          icon: Icons.password_rounded,
                                        ),


                                        RememberMeRow(isRememberMe: isRememberMe,   onChanged: (value) {
                                          setState(() {
                                            isRememberMe = !isRememberMe;
                                          });
                                        },),
                                        SizedBox(height: SizeApp.defaultPadding),
                                        // Sign In Button
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: CustomButton(
                                            onTap: () {
                                              if (signinKey.currentState!.validate()) {
                                                context.read<SigninCubit>().signin(
                                                  emailController.text,
                                                  passwordController.text,
                                                );
                                              }
                                            },
                                            text: "SIGN IN",
                                            isLoading:  state is SigninLoading,
                                          ),)
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: SizeApp.defaultPadding),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]


              ),
            ),
          ),);
        },
      ),
    );
  }
}
