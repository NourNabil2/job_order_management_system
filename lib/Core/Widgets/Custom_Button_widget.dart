import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';


class CustomCancelButon extends StatelessWidget {
 const CustomCancelButon({super.key, this.onTap, required this.text});
 final VoidCallback? onTap;
final  String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        padding: EdgeInsets.all(SizeApp.s10),
        height: SizeApp.s50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).primaryColorLight, ),
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(SizeApp.radius),

        ),
        child: Text(
          text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorApp.errorColor)
        ),
      ),
    );
  }
}


//
class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double? height;
  final double? width;
  final Color? color;
  final bool isDisabled;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    this.height,
    this.width,
    this.color,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(SizeApp.s10),
        height: height ?? SizeApp.s40,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 1)
          ],
          color: isDisabled ? Colors.grey : color ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(SizeApp.radius),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white) // ⏳ Loading Indicator
            : Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color == null ? ColorApp.mainLight : ColorApp.blackColor60,
          ),
        ),
      ),
    );
  }
}

class CustomCancelButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double? height;
  final double? width;
  final bool isDisabled;
  final bool isLoading;

  const CustomCancelButton({
    super.key,
    this.onTap,
    required this.text,
    this.height,
    this.width,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(SizeApp.s10),
        height: height ?? SizeApp.s70,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey : ColorApp.errorColor,
          borderRadius: BorderRadius.circular(SizeApp.s8),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ColorApp.mainLight,
          ),
        ),
      ),
    );
  }
}
