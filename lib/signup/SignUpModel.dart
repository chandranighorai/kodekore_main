// class SignUpModel {
//   RespData respData;
//   int success;
//   String message;
//   int otpStatus;
//   String otpMsg;

//   SignUpModel(
//       {this.respData, this.success, this.message, this.otpStatus, this.otpMsg});

//   SignUpModel.fromJson(Map<String, dynamic> json) {
//     respData = json['respData'] != null
//         ? new RespData.fromJson(json['respData'])
//         : null;
//     success = json['success'];
//     message = json['message'];
//     otpStatus = json['otp_status'];
//     otpMsg = json['otp_msg'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.respData != null) {
//       data['respData'] = this.respData.toJson();
//     }
//     data['success'] = this.success;
//     data['message'] = this.message;
//     data['otp_status'] = this.otpStatus;
//     data['otp_msg'] = this.otpMsg;
//     return data;
//   }
// }

class RespData {
  String userId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String otpStatus;

  RespData(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.otpStatus});

  // RespData.fromJson(Map<String, dynamic> json) {
  //   userId = json['user_id'];
  //   firstName = json['first_name'];
  //   lastName = json['last_name'];
  //   email = json['email'];
  //   phone = json['phone'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['user_id'] = this.userId;
  //   data['first_name'] = this.firstName;
  //   data['last_name'] = this.lastName;
  //   data['email'] = this.email;
  //   data['phone'] = this.phone;
  //   return data;
  // }
}
