class ItModel {
  List<RespData> respData;
  int success;
  String message;

  ItModel({this.respData, this.success, this.message});

  ItModel.fromJson(Map<String, dynamic> json) {
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
  String itProjId;
  String title;
  String description;
  String amount;
  String duration;
  String addedDtime;
  String status;

  RespData(
      {this.itProjId,
      this.title,
      this.description,
      this.amount,
      this.duration,
      this.addedDtime,
      this.status});

  RespData.fromJson(Map<String, dynamic> json) {
    itProjId = json['it_proj_id'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
    duration = json['duration'];
    addedDtime = json['added_dtime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['it_proj_id'] = this.itProjId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['duration'] = this.duration;
    data['added_dtime'] = this.addedDtime;
    data['status'] = this.status;
    return data;
  }
}
