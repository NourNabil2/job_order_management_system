class OrderModel {
  final String id;
  final String orderNumber;
  final String companyName;
  final String supplyNumber;
  final double itemCount;
  final DateTime date;
  final DateTime dateLine;
  final String orderStatus;

  OrderModel({
    required this.id,
    required this.companyName,
    required this.orderNumber,
    required this.supplyNumber,
    required this.itemCount,
    required this.date,
    required this.dateLine,
    required this.orderStatus,
  });
}

List<OrderModel> generateFakeOrders(int count) {
  return List.generate(count, (index) {
    return OrderModel(
     id: '2',
      orderNumber: '#${1000 + index}',
      companyName: 'Locala ${index == 3 ? 'a' : ''}',
      supplyNumber: 'Customer ${index + 1}',
      itemCount: 4,
      date: DateTime.now().subtract(Duration(days: index)),
      dateLine: DateTime.now().subtract(Duration(days: index)),
      orderStatus: index % 2 == 0 ? 'Delivered' : 'Processing',
    );
  });
}
