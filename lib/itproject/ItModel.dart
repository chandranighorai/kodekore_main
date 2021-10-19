// class ItModel {
//   String itProjectId;
//   String title;
//   String describtion;
//   String amount;
//   String duration;
//   String addedTime;
//   String status;
//   ItModel(
//       {this.itProjectId,
//       this.title,
//       this.describtion,
//       this.amount,
//       this.duration,
//       this.addedTime,
//       this.status});
//   ItModel.fromJson(Map<String, dynamic> json) {
//     itProjectId = json['it_proj_id'];
//     title = json['title'];
//     describtion = json['description'];
//     amount = json['amount'];
//     duration = json['duration'];
//     addedTime = json['added_dtime'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['it_proj_id'] = this.itProjectId;
//     data['title'] = this.title;
//     data['description'] = this.describtion;
//     data['amount'] = this.amount;
//     data['duration'] = this.duration;
//     data['added_dtime'] = this.addedTime;
//     data['status'] = this.status;
//     return data;
//   }
// }
