class NotificationModel {
  List<NotificationList> respData;
  int success;
  String message;

  NotificationModel({this.respData, this.success, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['respData'] != null) {
      respData = new List<NotificationList>();
      json['respData'].forEach((v) {
        respData.add(new NotificationList.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.respData != null) {
      data['respData'] = this.respData.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class NotificationList {
  String notificationId;
  String userId;
  String notificationEvent;
  String notificationTitle;
  String notificationBody;
  String dtime;

  NotificationList(
      {this.notificationId,
      this.userId,
      this.notificationEvent,
      this.notificationTitle,
      this.notificationBody,
      this.dtime});

  NotificationList.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    userId = json['user_id'];
    notificationEvent = json['notification_event'];
    notificationTitle = json['notification_title'];
    notificationBody = json['notification_body'];
    dtime = json['dtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['user_id'] = this.userId;
    data['notification_event'] = this.notificationEvent;
    data['notification_title'] = this.notificationTitle;
    data['notification_body'] = this.notificationBody;
    data['dtime'] = this.dtime;
    return data;
  }
}
