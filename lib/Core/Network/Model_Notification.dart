
class Notification_Model {
  Notification_Model({
    required this.pushToken,
  });

  late String pushToken;

  Notification_Model.fromJson(Map<String, dynamic> json) {
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['push_token'] = pushToken;
    return data;
  }
}