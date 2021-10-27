import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/Home/Home.dart';
import 'package:kode_core/login/Otp.dart';
import 'package:kode_core/login/UserPreference.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/signup/SignUpModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
//import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstNameText, lastNameText, mobNoText, emailText;
  var dio = Dio();
  bool _registerBtn;
  var fcmToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameText = new TextEditingController();
    lastNameText = new TextEditingController();
    mobNoText = new TextEditingController();
    emailText = new TextEditingController();
    _registerBtn = true;
    FirebaseMessaging.instance.getToken().then((value) {
      fcmToken = value.toString();
      print("FCM...in kodrcore..." + value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width * 0.08,
          //     right: MediaQuery.of(context).size.width * 0.08),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("asset/bg4.jpg"), fit: BoxFit.cover)),
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShapeComponent(context, Consts.shapeHeight),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.4,
                child: Container(
                    //color: Colors.amber,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.06,
                        right: MediaQuery.of(context).size.width * 0.02),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color: AppColors.bgColor,
                          fontSize: MediaQuery.of(context).size.width * 0.075,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.58,
                //bottom: MediaQuery.of(context).size.width * 0.18,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: firstNameText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "First Name"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: lastNameText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Last Name"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: mobNoText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Mobile No."),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: emailText,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.09,
                      ),
                    ],
                  ),
                ),
              ),
              _registerBtn == true
                  ? Positioned(
                      top: MediaQuery.of(context).size.width * 1.28,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.buttonColor,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _registerBtn = false;
                                  _register();
                                });
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.065,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.bgColor),
                              ))),
                    )
                  : Positioned(
                      top: MediaQuery.of(context).size.width * 1.28,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.buttonColor.withOpacity(0.2),
                          child: TextButton(
                              onPressed: () => null,
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.065,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.bgColor.withOpacity(0.2)),
                              ))),
                    )
              // Container(
              //   //height: MediaQuery.of(context).size.width * 0.3,
              //   width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.only(
              //       left: MediaQuery.of(context).size.width * 0.08,
              //       right: MediaQuery.of(context).size.width * 0.08),
              //   //color: Colors.amber,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       ShapeComponent(context, Consts.shapeHeight),
              //       Text(
              //         "Register",
              //         style: TextStyle(
              //             color: AppColors.bgColor,
              //             fontWeight: FontWeight.bold,
              //             fontSize: MediaQuery.of(context).size.width * 0.075),
              //       ),
              //       SizedBox(height: MediaQuery.of(context).size.width * 0.06),
              //       TextFormField(
              //         keyboardType: TextInputType.name,
              //         decoration: InputDecoration(hintText: "Name"),
              //       ),
              //       SizedBox(
              //         height: MediaQuery.of(context).size.width * 0.02,
              //       ),
              //       TextFormField(
              //         keyboardType: TextInputType.number,
              //         decoration: InputDecoration(hintText: "Mobile No."),
              //       ),
              //       SizedBox(
              //         height: MediaQuery.of(context).size.width * 0.02,
              //       ),
              //       TextFormField(
              //         keyboardType: TextInputType.emailAddress,
              //         decoration: InputDecoration(hintText: "Email"),
              //       ),
              //       SizedBox(
              //         height: MediaQuery.of(context).size.width * 0.09,
              //       ),
              //       Container(
              //         width: MediaQuery.of(context).size.width,
              //         color: AppColors.buttonColor,
              //         child: TextButton(
              //             onPressed: null,
              //             child: Text(
              //               "Register",
              //               style: TextStyle(
              //                   fontSize:
              //                       MediaQuery.of(context).size.width * 0.065,
              //                   fontWeight: FontWeight.bold,
              //                   color: AppColors.bgColor),
              //             )),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  _register() async {
    try {
      print("registerBtn...0.." + _registerBtn.runtimeType.toString());
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (firstNameText.text.length != 0 &&
          lastNameText.text.length != 0 &&
          mobNoText.text.length == 10 &&
          (regExp.hasMatch(emailText.text.trim().toString()))) {
        var formData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "fname": firstNameText.text.trim().toString(),
            "lname": lastNameText.text.trim().toString(),
            "email": emailText.text.trim().toString(),
            "phone": mobNoText.text.trim().toString(),
            "fcm_token": fcmToken.toString()
          })
        });
        var response = await dio.post(Consts.REGISTRATION, data: formData);
        print("Response..." + response.toString());
        setState(() {
          _registerBtn = true;
        });
        if (response.data["success"] == 1) {
          RespData resData = RespData();
          resData.userId = response.data["respData"]["user_id"];
          resData.firstName = response.data["respData"]["first_name"];
          resData.lastName = response.data["respData"]["last_name"];
          resData.email = response.data["respData"]["email"];
          resData.phone = response.data["respData"]["phone"];
          resData.otpStatus = response.data["respData"]["otp_status"];
          saveUserPref(resData);
          setState(() {
            firstNameText.text = "";
            lastNameText.text = "";
            emailText.text = "";
            mobNoText.text = "";
          });
          showCustomToast(response.data["message"].toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Otp(regData: resData, pageName: "SignUp")));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => Home(
          //             //regData: resData,
          //             )));
        } else {
          //print("message in sign up..." + response.data["message"].toString());
          showCustomToast(response.data["message"].toString());
        }
      } else {
        print("registerBtn..." + _registerBtn.toString());
        setState(() {
          _registerBtn = true;
        });
        print("registerBtn..." + _registerBtn.toString());
        if (firstNameText.text.trim().length == 0) {
          showCustomToast("Enter First Name");
        } else if (lastNameText.text.trim().length == 0) {
          showCustomToast("Enter Last Name");
        } else if (mobNoText.text.trim().length != 10) {
          showCustomToast("Enter 10 digit valid Phone Number");
        } else
        //(!regExp.hasMatch(emailText.text.trim().toString()))
        {
          showCustomToast("Enter valid email");
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
