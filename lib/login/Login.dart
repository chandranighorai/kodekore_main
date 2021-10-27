import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/login/Otp.dart';
import 'package:kode_core/signup/SignUp.dart';
import 'package:kode_core/signup/SignUpModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneNumberText;
  var dio = new Dio();
  bool _btnClick;
  var fcmToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumberText = new TextEditingController();
    _btnClick = true;
    FirebaseMessaging.instance.getToken().then((value) {
      fcmToken = value.toString();
      print("FCM...in kodrcore..." + value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //color: AppColors.bgColor,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("asset/bg3.jpg"), fit: BoxFit.fill)),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.08,
              bottom: MediaQuery.of(context).size.width * 0.02,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.red,
                    image:
                        DecorationImage(image: AssetImage("asset/logo.png"))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.10,
              ),
              Text(
                "Verification",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.08),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "We will send you a ",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04)),
                TextSpan(
                    text: "One Time Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04))
              ])),
              Text("on your phone number",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
                      height: MediaQuery.of(context).size.width * 0.004)),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              TextFormField(
                controller: _phoneNumberText,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.12,
              ),
              _btnClick == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.buttonColor,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _btnClick = false;
                            getOtp();
                          });
                        },
                        child: Text(
                          "GET OTP",
                          style: TextStyle(
                              color: AppColors.bgColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.buttonColor.withOpacity(0.2),
                      child: TextButton(
                        onPressed: () => null,
                        child: Text(
                          "GET OTP",
                          style: TextStyle(
                              color: AppColors.bgColor.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                      ),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getOtp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      if (_phoneNumberText.text.trim().length == 0 ||
          _phoneNumberText.text.trim().length != 10) {
        showCustomToast("Enter Valid Phone Number");
        setState(() {
          _btnClick = true;
        });
      } else {
        var logFormData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "phone": _phoneNumberText.text.trim().toString(),
            "fcm_token": fcmToken.toString()
          }),
        });
        var response = await dio.post(Consts.LOGIN, data: logFormData);
        print("loginData..." + response.data.toString());
        // print("loginData..." + response.data["success"].toString());
        if (response.data["success"] == 1) {
          RespData resp = new RespData();
          resp.userId = response.data["respData"]["user_id"];
          //resp.otpStatus = response.data["respData"]["otp_status"];
          resp.otpStatus = response.data["respData"]["login_otp_status"];
          print("respOTP..." + resp.otpStatus.toString());
          setState(() {
            pref.setString(
                "otpStatus", response.data["respData"]["login_otp_status"]);
            pref.setString("FCM", fcmToken.toString());
          });
          //if (response.data["respData"]["login_otp_status"] == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Otp(
                        regData: resp,
                        pageName: "logIn",
                      )));
          //}
          setState(() {
            _btnClick = true;
          });
        }
        showCustomToast(response.data["message"]);
        setState(() {
          _btnClick = true;
        });
      }
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}
