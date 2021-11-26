class ItProjectPayoutModel {
  List<ItPayoutData> payoutData;
  int success;
  String message;

  ItProjectPayoutModel({this.payoutData, this.success, this.message});

  ItProjectPayoutModel.fromJson(Map<String, dynamic> json) {
    if (json['respData'] != null) {
      payoutData = new List<ItPayoutData>();
      json['respData'].forEach((v) {
        payoutData.add(new ItPayoutData.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payoutData != null) {
      data['respData'] = this.payoutData.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class ItPayoutData {
  String dtime;
  String payoutid;
  String customerId;
  String userFullname;
  String remarks;
  String amount;
  String userEmail;
  String userPhone;
  String projTitle;
  String filepath;

  ItPayoutData(
      {this.dtime,
      this.payoutid,
      this.customerId,
      this.userFullname,
      this.remarks,
      this.amount,
      this.userEmail,
      this.userPhone,
      this.projTitle,
      this.filepath});

  ItPayoutData.fromJson(Map<String, dynamic> json) {
    dtime = json['dtime'];
    payoutid = json['payoutid'];
    customerId = json['customer_id'];
    userFullname = json['user_fullname'];
    remarks = json['remarks'];
    amount = json['amount'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    projTitle = json['proj_title'];
    filepath = json['filepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtime'] = this.dtime;
    data['payoutid'] = this.payoutid;
    data['customer_id'] = this.customerId;
    data['user_fullname'] = this.userFullname;
    data['remarks'] = this.remarks;
    data['amount'] = this.amount;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['proj_title'] = this.projTitle;
    data['filepath'] = this.filepath;
    return data;
  }
}
