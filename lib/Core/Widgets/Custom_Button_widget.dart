import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';


class CustomButon extends StatelessWidget {
  const CustomButon({super.key, this.onTap, required this.text});
  final VoidCallback? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeApp.s10),
        height: SizeApp.s50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black12 ,blurRadius: 50,spreadRadius: 1)
          ],
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(SizeApp.radius),

        ),
        child: Text(
          text,
    style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}


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
    style: TextStyle(color:Theme.of(context).primaryColorLight,fontSize: 24)
        ),
      ),
    );
  }
}