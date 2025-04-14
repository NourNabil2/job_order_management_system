import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quality_management_system/Core/Widgets/Custom_Button_widget.dart';
import '../Utilts/Constants.dart';

typedef ButtonFunction = void Function(BuildContext context, String? data);

class AddedMessageScreen extends StatelessWidget {
  final String imageLight;
  final String title;
  final String body;
  final String title1;
  final String? title2;
  final ButtonFunction? function1;
  final ButtonFunction? function2;

  const AddedMessageScreen({
    Key? key,
    required this.imageLight,
    required this.title,
    this.function2,
    this.function1,
    this.body = "",
    required this.title1,
    this.title2,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Lottie.asset(imageLight,repeat: false,),
                ),
                const Spacer(flex: 2),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: defaultPadding / 2),
                Text(
                  body,
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                if (title2 != null)
                  CustomButon(
                    onTap: () {
                      if (function1 != null) {
                        function1!(context, "Parameter from button 1");
                      }
                    },
                    text: title2!,
                  ),
                const SizedBox(height: defaultPadding),
                GestureDetector(
                  onTap: () {
                    if (function2 != null) {
                      function2!(context, "Parameter from button 2");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: whileColor40, // Button background color
                      borderRadius: BorderRadius.circular(SizeApp.radius), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        title1,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),


                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

