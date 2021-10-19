class ItTransactionModel {
  List<ItTransaction> itTransaction;
  int success;
  String message;

  ItTransactionModel({this.itTransaction, this.success, this.message});

  ItTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['respData'] != null) {
      itTransaction = new List<ItTransaction>();
      json['respData'].forEach((v) {
        itTransaction.add(new ItTransaction.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itTransaction != null) {
      data['respData'] = this.itTransaction.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class ItTransaction {
  String userId;
  String itProjId;
  String projectTitle;
  String userName;
  String userEmail;
  String userPhone;
  String projectAmount;
  String receivedAmount;
  String applicationStatus;
  String paymentStatus;
  String dtime;
  String paymentMode;

  ItTransaction(
      {this.userId,
      this.itProjId,
      this.projectTitle,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.projectAmount,
      this.receivedAmount,
      this.applicationStatus,
      this.paymentStatus,
      this.dtime,
      this.paymentMode});

  ItTransaction.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    itProjId = json['it_proj_id'];
    projectTitle = json['project_title'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    projectAmount = json['project_amount'];
    receivedAmount = json['received_amount'];
    applicationStatus = json['application_status'];
    paymentStatus = json['payment_status'];
    dtime = json['dtime'];
    paymentMode = json['payment_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['it_proj_id'] = this.itProjId;
    data['project_title'] = this.projectTitle;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['project_amount'] = this.projectAmount;
    data['received_amount'] = this.receivedAmount;
    data['application_status'] = this.applicationStatus;
    data['payment_status'] = this.paymentStatus;
    data['dtime'] = this.dtime;
    data['payment_mode'] = this.paymentMode;
    return data;
  }
}
