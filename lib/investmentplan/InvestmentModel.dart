class InvestmentModel {
  List<RespData> respData;
  int success;
  String message;

  InvestmentModel({this.respData, this.success, this.message});

  InvestmentModel.fromJson(Map<String, dynamic> json) {
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
  String invPlanId;
  String title;
  String description;
  String summary;
  String returnRate;
  String addedDtime;
  String status;

  RespData(
      {this.invPlanId,
      this.title,
      this.description,
      this.summary,
      this.returnRate,
      this.addedDtime,
      this.status});

  RespData.fromJson(Map<String, dynamic> json) {
    invPlanId = json['inv_plan_id'];
    title = json['title'];
    description = json['description'];
    summary = json['summary'];
    returnRate = json['return_rate'];
    addedDtime = json['added_dtime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_plan_id'] = this.invPlanId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['summary'] = this.summary;
    data['return_rate'] = this.returnRate;
    data['added_dtime'] = this.addedDtime;
    data['status'] = this.status;
    return data;
  }
}
