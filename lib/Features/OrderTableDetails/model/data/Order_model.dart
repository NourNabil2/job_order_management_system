import 'package:quality_management_system/Core/Utilts/Format_Time.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final String companyName;
  final String supplyNumber;
  final String attachmentType;
  final double itemCount;
  final String date;
  final String dateLine;
  final String orderStatus;

  OrderModel({
    required this.id,
    required this.companyName,
    required this.orderNumber,
    required this.supplyNumber,
    required this.itemCount,
    required this.attachmentType,
    required this.date,
    required this.dateLine,
    required this.orderStatus,
  });
}


