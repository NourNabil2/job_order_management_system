enum OrderStatus {
  pending,
  inProgress,
  delivered,
  cancelled,
}

enum AttachmentType {
  drawing, // رسم
  sample,  // عينه
}
extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

extension AttachmentTypeExtension on AttachmentType {
  String get displayName {
    switch (this) {
      case AttachmentType.drawing:
        return 'رسم';
      case AttachmentType.sample:
        return 'عينه';
    }
  }
}