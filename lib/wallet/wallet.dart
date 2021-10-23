import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  var title;
  //const Wallet({Key key}) : super(key: key);
  Wallet(this.title);
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  var dio = Dio();
  var responseData;
  var cryptoData;
  bool _load = false;
  String userId;
  double totalAmount;
  TextEditingController _amountText, _bitCoinText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountText = new TextEditingController();
    _bitCoinText = new TextEditingController();
    totalAmount = 0.0;
    _getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      key: scaffFoldState,
      drawer: Navigation(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("asset/bg4.jpg"), fit: BoxFit.cover)),
          child: _load == false
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    ShapeComponent(context, Consts.shapeHeight),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.06,
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: IconButton(
                          onPressed: () =>
                              scaffFoldState.currentState.openDrawer(),
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
                    //           "Wallet",
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
                      top: MediaQuery.of(context).size.width * 0.55,
                      left: MediaQuery.of(context).size.width * 0.08,
                      right: MediaQuery.of(context).size.width * 0.08,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cryptocurrency",
                              style: TextStyle(color: AppColors.bgColor),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.02)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey, blurRadius: 9.0)
                                  ]),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.05,
                                        // bottom:
                                        //     MediaQuery.of(context).size.width * 0.05,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "bitcoin".toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.bgColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.045),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        Text(
                                          "Qty : ${cryptoData["total_qty"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.bgColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.037),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        Text(
                                          "Rate : ${cryptoData["total_amount"]} INR",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.bgColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.037),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4.8,
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              color: Colors.grey[100],
                                              child: TextFormField(
                                                controller: _bitCoinText,
                                                keyboardType:
                                                    TextInputType.number,
                                                //maxLength: 100,
                                                scrollPadding:
                                                    EdgeInsets.all(0),
                                                decoration: InputDecoration(
                                                  hintText: "Qty",
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (value) {
                                                  print("Val.." +
                                                      value.toString());
                                                  setState(() {
                                                    if (value.length == 0) {
                                                      totalAmount = 0.0;
                                                    } else {
                                                      totalAmount = double
                                                              .parse(value) *
                                                          double.parse(cryptoData[
                                                              "total_amount"]);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Amt. $totalAmount INR",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.037),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: MediaQuery.of(context).size.width *
                                        //       0.03,
                                        // ),
                                        // Text(
                                        //   "Amt. 5000 INR",
                                        //   style: TextStyle(
                                        //       fontSize:
                                        //           MediaQuery.of(context).size.width *
                                        //               0.037),
                                        // ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            color: AppColors.buttonColor,
                                            child: TextButton(
                                                onPressed: () {
                                                  if (_bitCoinText.text ==
                                                      "0") {
                                                    showCustomToast(
                                                        "give proper input");
                                                  } else {
                                                    _sellBitCoin();
                                                  }
                                                },
                                                child: Text(
                                                  "Sell Now",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                      ],
                                    ),
                                    // child: Row(
                                    //   children: [
                                    //     Container(
                                    //       width:
                                    //           MediaQuery.of(context).size.width / 4.8,
                                    //       child: Text(
                                    //         "Bit Coin",
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.bold,
                                    //             color: AppColors.bgColor,
                                    //             fontSize: MediaQuery.of(context)
                                    //                     .size
                                    //                     .width *
                                    //                 0.045),
                                    //       ),
                                    //     ),
                                    //     // SizedBox(
                                    //     //   width:
                                    //     //       MediaQuery.of(context).size.width * 0.04,
                                    //     // ),
                                    //     Container(
                                    //       height: MediaQuery.of(context).size.width *
                                    //           0.09,
                                    //       width:
                                    //           MediaQuery.of(context).size.width / 4.9,
                                    //       padding: EdgeInsets.only(
                                    //           top: MediaQuery.of(context).size.width *
                                    //               0.00,
                                    //           bottom:
                                    //               MediaQuery.of(context).size.width *
                                    //                   0.00,
                                    //           left:
                                    //               MediaQuery.of(context).size.width *
                                    //                   0.02,
                                    //           right:
                                    //               MediaQuery.of(context).size.width *
                                    //                   0.02),
                                    //       color: Colors.grey[100],
                                    //       child: TextFormField(
                                    //         keyboardType: TextInputType.number,
                                    //         decoration: InputDecoration(
                                    //             hintText: "Qty",
                                    //             border: InputBorder.none),
                                    //       ),
                                    //     ),
                                    //     Spacer(),
                                    //     Container(
                                    //       //color: Colors.amber,
                                    //       width:
                                    //           MediaQuery.of(context).size.width / 3.5,
                                    //       child: Text("Rate 123 INR",
                                    //           style: TextStyle(
                                    //             fontWeight: FontWeight.bold,
                                    //             color: AppColors.bgColor,
                                    //             fontSize: MediaQuery.of(context)
                                    //                     .size
                                    //                     .width *
                                    //                 0.045,
                                    //           )),
                                    //     )
                                    //   ],
                                    // ),
                                  ),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.width * 0.02,
                                  // ),
                                  // Container(
                                  //   padding: EdgeInsets.only(
                                  //       top: MediaQuery.of(context).size.width * 0.05,
                                  //       bottom:
                                  //           MediaQuery.of(context).size.width * 0.05,
                                  //       left:
                                  //           MediaQuery.of(context).size.width * 0.05,
                                  //       right:
                                  //           MediaQuery.of(context).size.width * 0.05),
                                  //   child: Row(
                                  //     children: [
                                  //       Container(
                                  //         height: MediaQuery.of(context).size.width *
                                  //             0.09,
                                  //         width:
                                  //             MediaQuery.of(context).size.width / 4.8,
                                  //         padding: EdgeInsets.only(
                                  //             top: MediaQuery.of(context).size.width *
                                  //                 0.00,
                                  //             bottom:
                                  //                 MediaQuery.of(context).size.width *
                                  //                     0.00,
                                  //             left:
                                  //                 MediaQuery.of(context).size.width *
                                  //                     0.02,
                                  //             right:
                                  //                 MediaQuery.of(context).size.width *
                                  //                     0.02),
                                  //         color: Colors.grey[100],
                                  //         child: TextFormField(
                                  //           keyboardType: TextInputType.number,
                                  //           decoration: InputDecoration(
                                  //               hintText: "Qty",
                                  //               border: InputBorder.none),
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         width: MediaQuery.of(context).size.width *
                                  //             0.02,
                                  //       ),
                                  //       Container(
                                  //         width:
                                  //             MediaQuery.of(context).size.width / 5.1,
                                  //         child: Text(
                                  //           "Amt. 5000 INR",
                                  //           style: TextStyle(
                                  //               fontSize: MediaQuery.of(context)
                                  //                       .size
                                  //                       .width *
                                  //                   0.03),
                                  //         ),
                                  //       ),
                                  //       Spacer(),
                                  //       Container(
                                  //         color: AppColors.buttonColor,
                                  //         alignment: Alignment.center,
                                  //         padding: EdgeInsets.only(
                                  //             top: MediaQuery.of(context).size.width *
                                  //                 0.03,
                                  //             bottom:
                                  //                 MediaQuery.of(context).size.width *
                                  //                     0.03),
                                  //         width:
                                  //             MediaQuery.of(context).size.width / 3.5,
                                  //         child: Text(
                                  //           "Sell Now",
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.width * 1.32,
                        left: MediaQuery.of(context).size.width * 0.08,
                        right: MediaQuery.of(context).size.width * 0.08,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "INR",
                                style: TextStyle(color: AppColors.bgColor),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              Container(
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.02)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 9.0)
                                    ]),
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            // bottom:
                                            //     MediaQuery.of(context).size.width *
                                            //         0.05,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          "Balance Amount: ${responseData["wallet_amount"]} INR",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.bgColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.05,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width /
                                            //     2.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            color: Colors.grey[100],
                                            child: TextFormField(
                                              controller: _amountText,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Enter Amount"),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                          //Spacer(),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  bool validation =
                                                      _fieldCheck();
                                                  print("validation..." +
                                                      validation.toString());
                                                  if (validation) {
                                                    _redeemRequest();
                                                  }
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    color:
                                                        AppColors.buttonColor,
                                                    child: Text(
                                                      "Redeem",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  bool validation =
                                                      _fieldCheck();
                                                  if (validation) {
                                                    _withdrawal();
                                                  }
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    color:
                                                        AppColors.buttonColor,
                                                    child: Text(
                                                      "Withdrawal",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
        ),
      ),
    );
  }

  _getWallet() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userId = pref.get("userId");
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": userId})
      });
      var formData1 = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": userId, "crypto_id": "bitcoin"})
      });
      var response = await Future.wait([
        dio.post(Consts.USER_LIST, data: formData),
        dio.post(Consts.CRYPTOCURRENCY_WALLET, data: formData1)
      ]);
      responseData = response[0].data["respData"];
      cryptoData = response[1].data["respData"];
      print("responseData..." + responseData.toString());
      print("responseData..." + cryptoData[0].toString());
      print("walletAmount..." + responseData["wallet_amount"].toString());
      setState(() {
        _load = true;
      });
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  _redeemRequest() async {
    print("amountText..." + userId);
    try {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode(
            {"user_id": userId, "amount": _amountText.text.trim().toString()})
      });
      var response = await dio.post(Consts.REDEEM_REQUEST, data: formData);
      print("Response Body..." + response.data.toString());
      if (response.data["success"] == 1) {
        showCustomToast(response.data["message"]);
        _amountText.text = "";
      } else {
        showCustomToast(response.data["message"]["valid_fields"]);
      }
      // }
    } on DioError catch (e) {
      print(e.toString());
      print("No Network");
    }
  }

  _sellBitCoin() async {
    try {
      print("UserId..." + userId.toString());
      //print("cryptoId..." + userId.toString());
      print("UserId..." + _bitCoinText.text.toString());
      print("UserId..." + totalAmount.toString());
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": userId,
          "crypto_id": "bitcoin",
          "quantity": _bitCoinText.text.trim().toString(),
          "amount": totalAmount.toString()
        })
      });
      var response = await dio.post(Consts.SELL_CRIPTOCURRENCY, data: formData);
      print("sell response...." + response.data.toString());
      if (response.data["success"] == 1) {
        showCustomToast(response.data["message"]);
      } else {
        var msg =
            response.data["message"]["valid_fields"].toString().split("or");
        showCustomToast(msg[0].toString());
      }
      _bitCoinText.text = "";
      setState(() {
        totalAmount = 0.0;
      });
    } on DioError catch (e) {
      print(e.toString());
      print("No Network");
    }
  }

  _fieldCheck() {
    if (_amountText.text.trim().length == 0) {
      showCustomToast("Field should not empty");
      return false;
    } else {
      return true;
    }
  }

  _withdrawal() async {
    try {
      var formdataWithdraw = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": userId,
          // "crypto_id": "bitcoin",
          // "quantity": _bitCoinText.text.trim().toString(),
          "amount": totalAmount.toString()
        })
      });
      var response = await dio.post(Consts.WITHDRAWAL, data: formdataWithdraw);
      print("withdraw...." + response.data.toString());
      showCustomToast(response.data["message"].toString());
      _amountText.text = "";
      // setState(() {
      // });
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
