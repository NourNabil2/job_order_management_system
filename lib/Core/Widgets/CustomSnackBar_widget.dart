import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {

 static void showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,style: Theme.of(context).textTheme.bodyMedium,),
      backgroundColor: Theme.of(context).primaryColorDark,
      behavior: SnackBarBehavior.floating,));
 }


 }
