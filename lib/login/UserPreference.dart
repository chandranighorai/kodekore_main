import 'package:flutter/material.dart';
import 'package:kode_core/signup/SignUpModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveUserPref(RespData responseData) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print("otpstatus...shared..." + responseData.lastName.toString());
  sharedPreferences.setString("userId", responseData.userId.toString());
  sharedPreferences.setString("firstName", responseData.firstName.toString());
  sharedPreferences.setString("lastName", responseData.lastName.toString());
  sharedPreferences.setString("email", responseData.email.toString());
  sharedPreferences.setString("phone", responseData.phone.toString());
  sharedPreferences.setString("otpStatus", responseData.otpStatus.toString());
  sharedPreferences.setString("FCM", responseData.fcmToken.toString());
  sharedPreferences.setString("KycStatus", responseData.kycStatus.toString());
}
