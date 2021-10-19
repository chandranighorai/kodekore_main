import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/Itproject/ItModel.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/itproject/BuyNowModel.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

import 'NewModel.dart';

class ViewDetails extends StatefulWidget {
  var itModelList, itModelTitle, itModelDescription, itModelAmount;
  ViewDetails(
      {this.itModelList,
      this.itModelTitle,
      this.itModelDescription,
      this.itModelAmount,
      Key key})
      : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  //GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  var userId;
  var dio = Dio();
  var responseData;
  var responseSuccess;
  var buyBtnShowSuccess;
  ItModel itmodel;
  bool pageLoad = false;
  bool buyBtnShow = true;
  @override
  void initState() {
    // TODO: implement initState
    _projectBrought();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("modelId..." + widget.itModelDescription.length.toString());
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.bgColor,
      //   elevation: 0,
      // ),
      // key: scaffFoldState,
      // drawer: Navigation(),
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
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
            pageLoad == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Positioned(
                    //top: MediaQuery.of(context).size.width * 0.3,
                    top: MediaQuery.of(context).size.width * 0.4,
                    //bottom: MediaQuery.of(context).size.width * 0.2,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.08,
                          bottom: MediaQuery.of(context).size.width * 0.08,
                          left: MediaQuery.of(context).size.width * 0.08,
                          right: MediaQuery.of(context).size.width * 0.08),
                      // height: 145,s
                      // width: 850,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.dashboardFontColor,
                                blurRadius: 6.0)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(
                              MediaQuery.of(context).size.width * 0.02))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            //"${responseData["title"]}",
                            "${widget.itModelTitle}",

                            style: TextStyle(
                                color: AppColors.bgColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.06,
                          ),
                          // Text(
                          //     //"4.2.1. Users can choose a suitable investment plan from the multiple plans given by the admin while creating a plan from admin."),
                          //     "${responseData["description"]}"),
                          widget.itModelDescription.length > 700
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(0),
                                    children: [
                                      Html(
                                        //data: responseData["description"],
                                        data: widget.itModelDescription,
                                        shrinkWrap: true,
                                        style: {
                                          "body": Style(
                                              margin: EdgeInsets.all(0),
                                              padding: EdgeInsets.all(0))
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : Html(
                                  //data: responseData["description"],
                                  data: widget.itModelDescription,
                                  shrinkWrap: true,
                                  style: {
                                    "body": Style(
                                        margin: EdgeInsets.all(0),
                                        padding: EdgeInsets.all(0))
                                  },
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          // Text(
                          //     "4.2.1. Users can choose a suitable investment plan from the multiple plans given by the admin while creating a plan from admin."),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.width * 0.04,
                          // ),
                          // Text(
                          //     "4.2.1. Users can choose a suitable investment plan from the multiple plans given by the admin while creating a plan from admin."),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.width * 0.06,
                          // ),
                          Text(
                            //"Project Price: ${responseData["amount"]} INR",
                            "Project Price: ${widget.itModelAmount} INR",

                            style: TextStyle(
                                color: AppColors.bgColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.08,
                          ),
                          buyBtnShow == false
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.12,
                                      right: MediaQuery.of(context).size.width *
                                          0.12),
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width / 2,
                                    color: AppColors.buttonColor,
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      child: Text(
                                        "Buy Now",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      onPressed: () => _buyItProject(),
                                      //"Buy Now",
                                      //textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ))
          ],
        ),
      ),
    );
  }

  // _getProjectDetails() async {
  //   try {
  //     var formData = FormData.fromMap({
  //       "oAuth_json": json.encode({
  //         "sKey": "dfdbayYfd4566541cvxcT34#gt55",
  //         "aKey": "3EC5C12E6G34L34ED2E36A9"
  //       }),
  //       "jsonParam": json.encode({"it_proj_id": widget.itModelList.toString()})
  //     });
  //     var response = await dio.post(Consts.IT_PROJECT_LIST, data: formData);
  //     print("response status..." + response.statusCode.toString());
  //     print("response status..." + response.data.toString());
  //     responseData = response.data["respData"];
  //     responseSuccess = response.data["success"];
  //     setState(() {
  //       pageLoad = true;
  //     });
  //   } on DioError catch (e) {
  //     print(e.toString());
  //     showCustomToast("No Network");
  //   }
  // }

  _projectBrought() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userId");
    try {
      var formData1 = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": userId.toString(),
          "it_proj_id": widget.itModelList.toString()
        })
      });
      // var formData = FormData.fromMap({
      //   "oAuth_json": json.encode({
      //     "sKey": "dfdbayYfd4566541cvxcT34#gt55",
      //     "aKey": "3EC5C12E6G34L34ED2E36A9"
      //   }),
      //   "jsonParam": json.encode({"it_proj_id": widget.itModelList.toString()})
      // });
      // var response1 =
      //     await dio.post(Consts.IT_PROJECT_BOUGHT_BY_USER, data: formData1);
      var response1 = await Future.wait([
        dio.post(Consts.IT_PROJECT_BOUGHT_BY_USER, data: formData1),
        // dio.post(Consts.IT_PROJECT_LIST, data: formData
        // )
      ]);
      print("response for baught user..." + response1.toString());
      // print("response for baught user..." +
      //     response1[0].data["message"].toString());

      buyBtnShowSuccess = response1[0].data["success"];
      //responseSuccess = response1[1].data["success"];
      //responseData = response1[1].data["respData"];
      print("responseSuccess..." + responseSuccess.toString());
      print("responseSuccess..." + buyBtnShowSuccess.toString());

      if (buyBtnShowSuccess == 1) {
        setState(() {
          buyBtnShow = false;
          pageLoad = true;
        });
      } else {
        setState(() {
          pageLoad = true;
        });
      }
      // _getProjectDetails();
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }

  _buyItProject() async {
    print("user_id..." + userId.toString());
    print("user_id..." + widget.itModelList.toString());
    print("user_id..." + widget.itModelAmount.toString());

    try {
      var boughtProject = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": userId.toString(),
          "it_proj_id": widget.itModelList.toString(),
          "amount": widget.itModelAmount.toString() 
        })
      });
      var buyResponse =
          await dio.post(Consts.USER_BUY_IT_PROJECT, data: boughtProject);
      if (buyResponse.data["success"] == 1) {
        var buyResponseData = buyResponse.data["respData"];
        BuyNowModel buyNowModel = BuyNowModel();
        buyNowModel.itprojtAddedId =
            buyResponseData["itproj_added_id"].toString();
        buyNowModel.userId = buyResponseData["user_id"];
        buyNowModel.itProjId = buyResponseData["it_proj_id"];
        buyNowModel.itProjId = buyResponseData["project_amount"];
        buyNowModel.itProjId = buyResponseData["received_amount"];
        buyNowModel.itProjId = buyResponseData["application_status"];
        buyNowModel.itProjId = buyResponseData["payment_status"];
        buyNowModel.itProjId = buyResponseData["payment_mode"];
        setState(() {
          pageLoad = false;
          _projectBrought();
        });
      }
      showCustomToast(buyResponse.data["message"]);
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}
