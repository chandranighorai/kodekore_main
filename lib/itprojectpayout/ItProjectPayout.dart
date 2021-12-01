import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/itprojectpayout/ItPayoutList.dart';
import 'package:kode_core/itprojectpayout/ItPayoutModel.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItProjectPayout extends StatefulWidget {
  var title;
  ItProjectPayout(this.title);

  @override
  _ItProjectPayoutState createState() => _ItProjectPayoutState();
}

class _ItProjectPayoutState extends State<ItProjectPayout> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  Future<ItProjectPayoutModel> _getItPayout;
  var dio = Dio();
  var respData;
  var response;
  bool _load = false;

  @override
  void initState() {
    super.initState();
    _getItPayout = _allPayoutList();
  }

  @override
  Widget build(BuildContext context) {
    int _currentSortColumn = 0;
    bool _isAscending = true;
    return Scaffold(
      key: scaffFoldState,
      drawer: Navigation(),
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
                  onPressed: () => scaffFoldState.currentState.openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
            ),
            Wal(widget.title),
            _load == false
                ? Center(child: CircularProgressIndicator())
                : response.data["success"] == 0
                    ? Center(
                        child: Text(response.data["message"]),
                      )
                    : ItPayoutList(
                        contextData: context,
                        payoutList: respData,
                        currentSortColumn: _currentSortColumn,
                        isAscending: _isAscending)
          ],
        ),
      ),
    );
  }

  Future<ItProjectPayoutModel> _allPayoutList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userId = pref.getString("userId");
      var formData = FormData.fromMap({
        "oAuth_json": jsonEncode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": jsonEncode({"user_id": userId.toString()})
      });
      response = await dio.post(Consts.IT_PAYOUT, data: formData);
      //var resData = json.decode(response.data);
      print(
          "ResponseData..." + response.data["success"].runtimeType.toString());

      setState(() {
        _load = true;
      });
      if (response.data["success"] == 1) {
        respData = response.data["respData"];
        print("ResdData..." + respData.toString());
        print("ResponseData..." + response.data.toString());
        return ItProjectPayoutModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
