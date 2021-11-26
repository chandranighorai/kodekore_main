import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/Util/AppColors.dart';
import 'package:kode_core/cryptocurrency/CryptoCurrency.dart';
import 'package:kode_core/investmentplan/InvestmentList.dart';
import 'package:kode_core/itproject/ItProjectList.dart';
import 'package:kode_core/itprojectpayout/ItProjectPayout.dart';
import 'package:kode_core/login/Login.dart';
import 'package:kode_core/profile/EditProfile.dart';
import 'package:kode_core/terms&conditions/Terms.dart';
import 'package:kode_core/transaction/Transaction.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wallet.dart';
import 'package:kode_core/notification/Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/Const.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var userName, userEmail, userPhoneNumber, firstName, lastName, userId, name;
  var dio = Dio();
  var terms, privacy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userDetails();
    _termsConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.bgColor,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.45,
              color: AppColors.buttonColor,
              child: Row(
                children: [
                  Container(
                    //height: MediaQuery.of(context).size.height / 2,
                    alignment: Alignment.center,
                    //width: MediaQuery.of(context).size.width / 3.8,
                    width: MediaQuery.of(context).size.width / 4.8,

                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.02,
                        left: MediaQuery.of(context).size.width * 0.01,
                        bottom: MediaQuery.of(context).size.width * 0.02,
                        right: MediaQuery.of(context).size.width * 0.01),
                    //padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                        )
                        // borderRadius: BorderRadius.all(Radius.circular(
                        //     MediaQuery.of(context).size.width * 100))
                        ),
                    // child: Icon(
                    //   Icons.person,
                    //   color: Colors.white,
                    //   size: MediaQuery.of(context).size.width * 0.14,
                    // ),
                    child: Text(
                      name.toUpperCase(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.09,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width / 3,
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            //color: Colors.green,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "$userName",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text("$userEmail",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04))),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              children: [
                                Text(
                                  "$userPhoneNumber",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                              firstName: firstName,
                                              lastName: lastName,
                                              email: userEmail,
                                              phone: userPhoneNumber,
                                              userId: userId))).then((value) {
                                    print("Value..." + value.toString());
                                    setState(() {
                                      firstName = value["firstName"].toString();
                                      lastName = value["lastName"].toString();
                                      userName = firstName + " " + lastName;
                                      name = firstName
                                              .toString()
                                              .substring(0, 1) +
                                          lastName.toString().substring(0, 1);
                                    });
                                  }),
                                  child: Icon(
                                    Icons.edit,
                                    size: MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                    //width: MediaQuery.of(context).size.width / 3,
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.width * 0.05,
            // ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.07,
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.03),
                children: [
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "IT Projects",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItProjects("IT Projects"))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Investment Plan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InvestmentList("Investment Plan"))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Crypto Currency",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CryptoCurrency("Crypto Currency"))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Transections",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Transaction("Transections"))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "IT Projects Payout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ItProjectPayout("IT Project Payout")));
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Wallet",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Wallet("Wallet"))),
                  ),
                  Divider(color: Colors.grey),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Notifications",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Notification1("Notifications", userId))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Terms("Terms & Conditions", terms))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    dense: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Terms("Privacy Policy", privacy))),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () => _logOut(),
                    dense: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _userDetails() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      firstName = pref.getString("firstName");
      lastName = pref.getString("lastName");
      userId = pref.getString("userId");
      // var frst = firstName.toString().substring(0, 1);
      // var last = lastName.toString().substring(0, 1);
      name = firstName.toString().substring(0, 1) +
          lastName.toString().substring(0, 1);
      print("frst.." + name.toString());
      setState(() {
        userName = firstName + " " + lastName;
        userEmail = pref.getString("email");
        userPhoneNumber = pref.getString("phone");
        print("userNAme..." + userName.toString());
        print("userNAme..." + userEmail.toString());
        print("userNAme..." + userPhoneNumber.toString());
        print("userNAme..." + userId.toString());
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  _logOut() async {
    print("logout Called....");
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      //var userId = pref.getString("userId");
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Do you really want to exit?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("No")),
                  TextButton(
                      onPressed: () async {
                        var formData = FormData.fromMap({
                          "oAuth_json": json.encode({
                            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
                            "aKey": "3EC5C12E6G34L34ED2E36A9"
                          }),
                          "jsonParam":
                              json.encode({"user_id": userId.toString()})
                        });
                        var response =
                            await dio.post(Consts.LOGOUT, data: formData);
                        print("logout...otpStatus..." +
                            pref.getString("otpStatus").toString());
                        print(
                            "logout...otpStatus..." + response.data.toString());
                        pref.clear();
                        print("logout...otpStatus..." +
                            pref.getString("otpStatus").toString());
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Login()),
                            (route) => false);
                      },
                      child: Text("Yes"))
                ],
              ));
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }

  _termsConditions() async {
    try {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var response = await dio.post(Consts.TERMS_CONDITIONS, data: formData);
      print("terms..." + response.data.toString());
      terms = response.data["respData"]["terms"];
      privacy = response.data["respData"]["privacy"];

      print("terms...0..." + terms.toString());
      print("terms...0..." + privacy.toString());
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
