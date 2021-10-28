// import 'dart:convert';

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/cryptocurrency/CryptoCurrencyList.dart';
import 'package:kode_core/cryptocurrency/CryptoCurrencyModel.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptoCurrency extends StatefulWidget {
  var title;
  //const CryptoCurrency({Key key}) : super(key: key);
  CryptoCurrency(this.title);
  @override
  _CryptoCurrencyState createState() => _CryptoCurrencyState();
}

class _CryptoCurrencyState extends State<CryptoCurrency> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  Future<CryptoCurrencyModel> _cryptoList;
  var dio = Dio();
  var userId;
  Timer _timer;
  double gst, tds, royalty;
  @override
  void initState() {
    super.initState();
    _cryptoList = _getAllCryptoList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _cryptoList = _getAllCryptoList();
      });
    });
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: AppColors.bgColor,
      // ),
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
            // Positioned(
            //   top: MediaQuery.of(context).size.width * 0.39,
            //   left: MediaQuery.of(context).size.width * 0.02,
            //   right: MediaQuery.of(context).size.width * 0.02,
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         left: MediaQuery.of(context).size.width * 0.06,
            //         right: MediaQuery.of(context).size.width * 0.06),
            //     child: Row(
            //       children: [
            //         Text(
            //           "Cryptocurrency",
            //           style: TextStyle(
            //               color: AppColors.bgColor,
            //               fontSize: MediaQuery.of(context).size.width * 0.05,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Spacer(),
            //         Wal()
            //         // InkWell(
            //         //   onTap: () => Navigator.push(context,
            //         //       MaterialPageRoute(builder: (context) => Wallet())),
            //         //   child: Container(
            //         //     height: MediaQuery.of(context).size.width * 0.10,
            //         //     width: MediaQuery.of(context).size.width * 0.10,
            //         //     decoration: BoxDecoration(
            //         //         //color: Colors.red,
            //         //         image: DecorationImage(
            //         //             image: AssetImage("asset/wallet.png"),
            //         //             fit: BoxFit.contain)),
            //         //   ),
            //         // )
            //       ],
            //     ),
            //   ),
            // ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.54,
              bottom: MediaQuery.of(context).size.width * 0.02,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                //color: Colors.amber,
                child: FutureBuilder(
                  initialData: null,
                  future: _cryptoList,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var cryptoCurrency = snapshot.data.respData;
                      return cryptoCurrency.length == 0
                          ? Center(child: Text("No Data"))
                          : ListView.builder(
                              itemCount: cryptoCurrency.length,
                              itemBuilder: (context, int index) {
                                RespData cryptoData = cryptoCurrency[index];
                                return CryptoCurrencyList(
                                    cryptoDataList: cryptoData, userId: userId,gst:gst,tds:tds,royalty:royalty);
                              });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<CryptoCurrencyModel> _getAllCryptoList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userId");
    try {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({}),
      });
      var formData1 = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var response = await Future.wait([
        dio.post(Consts.CRYPTO_CURRENCY, data: formData),
        dio.post(Consts.TERMS_CONDITIONS, data: formData1)
      ]);
      print("response data..." + response[0].data.toString());
      gst = double.parse(response[1].data["respData"]["gst"]);
      tds = double.parse(response[1].data["respData"]["tds"]);
      royalty = double.parse(response[1].data["respData"]["royalty"]);
      return CryptoCurrencyModel.fromJson(response[0].data);
    } on DioError catch (e) {
      print(e.toString());
      //showCustomToast("response data..." + "No Network");
    }
  }
}
