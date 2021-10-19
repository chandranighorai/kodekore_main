import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Home.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/login/UserPreference.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/signup/SignUpModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';

class EditProfile extends StatefulWidget {
  String firstName, lastName, email, phone, userId;
  EditProfile(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.userId,
      Key key})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameEditText, lastNameEditText;
  var dio = Dio();
  @override
  void initState() {
    firstNameEditText = new TextEditingController();
    lastNameEditText = new TextEditingController();
    //numberEditText = new TextEditingController();
    firstNameEditText.text = widget.firstName;
    lastNameEditText.text = widget.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("FirstName..." + widget.firstName.toString());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/bg4.jpg"), fit: BoxFit.cover)),
        child: Stack(
          children: [
            ShapeComponent(context, Consts.shapeHeight),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.06,
              left: MediaQuery.of(context).size.width * 0.03,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop({
                        "firstName": firstNameEditText.text.trim().length == 0
                            ? widget.firstName
                            : firstNameEditText.text.trim().toString(),
                        "lastName": lastNameEditText.text.trim().length == 0
                            ? widget.lastName
                            : lastNameEditText.text.trim().toString()
                      }),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
            Wal("Edit Profile"),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.55,
              left: MediaQuery.of(context).size.width * 0.08,
              right: MediaQuery.of(context).size.width * 0.08,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 9.0)],
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: firstNameEditText,
                      decoration: InputDecoration(hintText: "Enter First name"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.03,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: lastNameEditText,
                      decoration: InputDecoration(hintText: "Enter Last name"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.width * 0.03),
                      child: Text("${widget.email}"),
                    ),
                    // Divider(
                    //   color: Colors.grey,
                    //   thickness: 1,
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.width * 0.03),
                      child: Text("${widget.phone}"),
                    ),
                    // Divider(
                    //   color: Colors.grey,
                    //   thickness: 1,
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),
                    InkWell(
                      onTap: () {
                        _update();
                      },
                      child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.03,
                              bottom: MediaQuery.of(context).size.width * 0.03,
                              left: MediaQuery.of(context).size.width * 0.12,
                              right: MediaQuery.of(context).size.width * 0.12),
                          color: AppColors.buttonColor,
                          child: Text(
                            "update".toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _update() async {
    try {
      if ((firstNameEditText.text.trim().length == 0) ||
          (lastNameEditText.text.trim().length == 0)) {
        showCustomToast("Field should not blank");
      } else {
        var formData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "user_id": widget.userId.toString(),
            "fname": firstNameEditText.text.trim().toString(),
            "lname": lastNameEditText.text.trim().toString()
          })
        });
        var response = await dio.post(Consts.UPDATE_PROFILE, data: formData);
        var responseSuccess = response.data["success"];
        var responseData = response.data["respData"];
        // print("respose data...." + responseData["first_name"].toString());
        if (responseSuccess.toString() == "1") {
          RespData resData = RespData();
          resData.userId = responseData["user_id"];
          resData.firstName = responseData["first_name"];
          resData.lastName = responseData["last_name"];
          resData.email = responseData["email"];
          resData.phone = responseData["phone"];
          resData.otpStatus = responseData["otp_status"];
          saveUserPref(resData);
        }
        showCustomToast(response.data["message"]);
      }
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}
