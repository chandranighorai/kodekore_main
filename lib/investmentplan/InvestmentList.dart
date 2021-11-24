import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/investmentplan/InvestmentModel.dart';
import 'package:kode_core/investmentplan/InvestmentPlanlList.dart';
import 'package:kode_core/investmentplan/InvestmentViewDetails.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentList extends StatefulWidget {
  var title;
  //const InvestmentList({Key key}) : super(key: key);
  InvestmentList(this.title);
  @override
  _InvestmentListState createState() => _InvestmentListState();
}

class _InvestmentListState extends State<InvestmentList> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  var dio = Dio();
  var investmentDataList;
  int investmentSuccess;
  bool _pageLoad;
  String userId;
  Future<InvestmentModel> _investPlan;
  double gst, tds, royalty;
  @override
  void initState() {
    super.initState();
    _investPlan = _investmentPlanList();
    _pageLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: AppColors.bgColor,
      // ),
      key: scaffFoldState,
      drawer: Navigation(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                  onPressed: () => scaffFoldState.currentState.openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
            ),
            Wal(widget.title),
            // _pageLoad == false
            //     ? Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     :
            Positioned(
              top: MediaQuery.of(context).size.width * 0.54,
              bottom: MediaQuery.of(context).size.width * 0.02,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:
                      // investmentSuccess == 1
                      //     ?
                      FutureBuilder(
                    initialData: null,
                    future: _investPlan,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var investmentDataList = snapshot.data.respData;
                        print(
                            "responseData..." + investmentDataList.toString());
                        return investmentDataList.length == 0
                            ? Center(
                                child: Container(child: Text("No Plans yet")))
                            : ListView.builder(
                                itemCount: investmentDataList.length,
                                itemBuilder: (context, int index) {
                                  RespData investmentModel =
                                      investmentDataList[index];
                                  return InvestmentPlanList(
                                      invesmentList: investmentModel,
                                      userId: userId,
                                      gst: gst,
                                      tds: tds,
                                      royalty: royalty);
                                });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                  // : Center(
                  //     child: Text("No data"),
                  //   )
                  ),
            )
          ],
        ),
      ),
    );
  }

  Future<InvestmentModel> _investmentPlanList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userId = pref.getString("userId");
      var investmentData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var investmentData1 = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var response = await Future.wait([
        dio.post(Consts.INVESTMENT_BY_USER, data: investmentData),
        dio.post(Consts.TERMS_CONDITIONS, data: investmentData1)
      ]);
      print("investment recoed..." + response[1].data["respData"].toString());
      gst = double.parse(response[1].data["respData"]["gst"]);
      tds = double.parse(response[1].data["respData"]["tds"]);
      royalty = double.parse(response[1].data["respData"]["royalty"]);
      return InvestmentModel.fromJson(response[0].data);
      // investmentDataList = response.data["respData"];
      // investmentSuccess = response.data["success"];
      // setState(() {
      //   _pageLoad = true;
      // });
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}
