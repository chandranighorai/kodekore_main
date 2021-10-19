class InvestmentTransactionModel {
  List<InvestmentTranModel> investmentTransaction;
  int success;
  String message;

  InvestmentTransactionModel(
      {this.investmentTransaction, this.success, this.message});

  InvestmentTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['respData'] != null) {
      investmentTransaction = new List<InvestmentTranModel>();
      json['respData'].forEach((v) {
        print("v..." + v.toString());
        investmentTransaction.add(new InvestmentTranModel.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.investmentTransaction != null) {
      data['respData'] =
          this.investmentTransaction.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class InvestmentTranModel {
  String invRowId;
  String userId;
  String invPlanId;
  String planTitle;
  String userName;
  String userEmail;
  String userPhone;
  String invAmount;
  String applicationStatus;
  String paymentStatus;
  String dtime;
  String paymentMode;

  InvestmentTranModel(
      {this.invRowId,
      this.userId,
      this.invPlanId,
      this.planTitle,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.invAmount,
      this.applicationStatus,
      this.paymentStatus,
      this.dtime,
      this.paymentMode});

  InvestmentTranModel.fromJson(Map<String, dynamic> json) {
    invRowId = json['inv_row_id'];
    userId = json['user_id'];
    invPlanId = json['inv_plan_id'];
    planTitle = json['plan_title'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    invAmount = json['inv_amount'];
    applicationStatus = json['application_status'];
    paymentStatus = json['payment_status'];
    dtime = json['dtime'];
    paymentMode = json['payment_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_row_id'] = this.invRowId;
    data['user_id'] = this.userId;
    data['inv_plan_id'] = this.invPlanId;
    data['plan_title'] = this.planTitle;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['inv_amount'] = this.invAmount;
    data['application_status'] = this.applicationStatus;
    data['payment_status'] = this.paymentStatus;
    data['dtime'] = this.dtime;
    data['payment_mode'] = this.paymentMode;
    //print("Data..." + data.toString());
    return data;
  }
}
