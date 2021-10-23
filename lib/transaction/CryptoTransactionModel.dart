class CryptoTransactionModel {
  List<RespData> respData;
  int success;
  String message;

  CryptoTransactionModel({this.respData, this.success, this.message});

  CryptoTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['respData'] != null) {
      respData = new List<RespData>();
      json['respData'].forEach((v) {
        respData.add(new RespData.fromJson(v));
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

class RespData {
  String cryptoBuyid;
  String userId;
  String cryptoId;
  String receivedAmount;
  String quantity;
  String applicationStatus;
  String paymentStatus;
  String paymentMode;
  String dtime;
  String transType;
  String filepath;

  RespData(
      {this.cryptoBuyid,
      this.userId,
      this.cryptoId,
      this.receivedAmount,
      this.quantity,
      this.applicationStatus,
      this.paymentStatus,
      this.paymentMode,
      this.dtime,
      this.transType,
      this.filepath});

  RespData.fromJson(Map<String, dynamic> json) {
    cryptoBuyid = json['crypto_buyid'];
    userId = json['user_id'];
    cryptoId = json['crypto_id'];
    receivedAmount = json['received_amount'];
    quantity = json['quantity'];
    applicationStatus = json['application_status'].toString();
    paymentStatus = json['payment_status'].toString();
    paymentMode = json['payment_mode'];
    dtime = json['dtime'];
    transType = json['trans_type'];
    filepath = json['filepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crypto_buyid'] = this.cryptoBuyid;
    data['user_id'] = this.userId;
    data['crypto_id'] = this.cryptoId;
    data['received_amount'] = this.receivedAmount;
    data['quantity'] = this.quantity;
    data['application_status'] = this.applicationStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_mode'] = this.paymentMode;
    data['dtime'] = this.dtime;
    data['trans_type'] = this.transType;
    data['filepath'] = this.filepath;
    return data;
  }
}
