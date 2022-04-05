import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Home.dart';
import 'package:kode_core/kyc/Kyc.dart';
import 'package:kode_core/signup/SignUpModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/login/UserPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  RespData regData;
  String pageName;
  Otp({this.regData, this.pageName, Key key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController otpText;
  bool _btnClick;
  var dio = Dio();
  var nextToDays, newDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextToDays = DateTime.now().add(Duration(days: 2));
    //newDate = DateFormat('d-MM-yyyy').format(nextToDays);
    otpText = new TextEditingController();
    _btnClick = true;
  }

  @override
  Widget build(BuildContext context) {
    print("reg Data..." + widget.regData.userId.toString());
    print("reg Data...pageNAme..." + widget.pageName.toString());

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
                height: MediaQuery.of(context).size.width * 0.12,
              ),
              Text(
                "Verification",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.08),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
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
              Text(
                  widget.pageName == "SignUp"
                      ? "on your email"
                      : "on your phone number",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
                      height: MediaQuery.of(context).size.width * 0.004)),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.11,
              ),
              TextFormField(
                controller: otpText,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter OTP",
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
                            widget.pageName == "SignUp"
                                ? otpSubmit()
                                : otpSubmitLogin();
                          });
                        },
                        child: Text(
                          "SUBMIT",
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
                      color: AppColors.buttonColor.withOpacity(0.4),
                      child: TextButton(
                        onPressed: () => null,
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: AppColors.bgColor.withOpacity(0.2),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  otpSubmit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      if (otpText.text.length == 0) {
        showCustomToast("Enter valid OTP");
        setState(() {
          _btnClick = true;
        });
        print("OnClick..." + _btnClick.toString());
      } else {
        var formData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "user_id": widget.regData.userId.toString(),
            "user_otp": otpText.text.trim().toString()
          })
        });
        var response = await dio.post(Consts.REGISTRATION_OTP_VERIFICATION,
            data: formData);
        showCustomToast(response.data["message"].toString());
        print("response...000..." + response.data.toString());
        setState(() {
          _btnClick = true;
        });
        if (response.data["success"] == 1) {
          setState(() {
            pref.setString(
                "otpStatus", response.data["respData"]["otp_status"]);
            pref.setString(
                "KycStatus", response.data["respData"]["kyc_status"]);
            pref.setString("ExpireDate", nextToDays.toString());
            otpText.text = "";
          });
          print("kyc...." + response.data["respData"]["kyc_status"].toString());
          if (response.data["respData"]["kyc_status"] == "1" ||
              response.data["respData"]["kyc_status"] == "2") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KYC(
                        userId: widget.regData.userId.toString(),
                        regData: widget.regData,
                        pageName: widget.pageName)));
          }
        }
      }
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }

  otpSubmitLogin() async {
    // print("otpSubmitLogin...");
    // print("otpSubmitLogin..." + widget.regData.userId.toString());
    // print("otpSubmitLogin..." + otpText.text.trim().toString());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var keyStatus = pref.getString("KycStatus");
    try {
      if (otpText.text.length == 0) {
        showCustomToast("Enter valid OTP");
        setState(() {
          _btnClick = true;
        });
        //print("OnClick..." + _btnClick.toString());
      } else {
        var formData1 = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "user_id": widget.regData.userId.toString(),
            "login_otp": otpText.text.trim().toString()
          })
        });
        var logInResponse =
            await dio.post(Consts.LOGIN_OTP_VERIFICATION, data: formData1);
        print("otpSubmitLogin..." + logInResponse.data.toString());

        showCustomToast(logInResponse.data["message"].toString());
        setState(() {
          _btnClick = true;
        });
        if (logInResponse.data["success"] == 1) {
          RespData respData1 = new RespData();
          respData1.userId = logInResponse.data["respData"]["user_id"];
          respData1.firstName = logInResponse.data["respData"]["first_name"];
          respData1.lastName = logInResponse.data["respData"]["last_name"];
          respData1.email = logInResponse.data["respData"]["email"];
          respData1.phone = logInResponse.data["respData"]["phone"];
          respData1.otpStatus =
              logInResponse.data["respData"]["login_otp_status"];
          respData1.kycStatus = logInResponse.data["respData"]["kyc_status"];
          saveUserPref(respData1);
          pref.setString("ExpireDate", nextToDays.toString());
          setState(() {
            otpText.text = "";
          });
          print("otpSubmitLogin..." +
              logInResponse.data["respData"]["kyc_status"].toString());

          if (logInResponse.data["respData"]["kyc_status"] == "1" ||
              logInResponse.data["respData"]["kyc_status"] == "2") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Home()),
                (route) => false);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KYC(
                        userId: widget.regData.userId.toString(),
                        regData: widget.regData,
                        pageName: widget.pageName)));
          }
        }
      }
    } on DioError catch (e) {
      print("Dio catch..." + e.response.toString());
      showCustomToast("No Network");
    }
  }
}
