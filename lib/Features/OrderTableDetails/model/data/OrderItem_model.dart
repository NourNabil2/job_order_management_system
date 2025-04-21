
class OrderItem {
  final String id;
  final String operationDescription;
  final int quantity;
  final String materialType;
  late final String status;
  final String notes;
  final List<String> attachments;

  OrderItem({
    required this.id,
    required this.operationDescription,
    required this.quantity,
    required this.materialType,
    required this.status,
    required this.notes,
    this.attachments = const [],
  });



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operationDescription': operationDescription,
      'quantity': quantity,
      'materialType': materialType,
      'status': status,
      'notes': notes,
      'attachments': attachments,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      operationDescription: map['operationDescription'],
      quantity: map['quantity'],
      materialType: map['materialType'],
      status: map['status'],
      notes: map['notes'],
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }
}