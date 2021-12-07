import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/cryptocurrencySell.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Wallet extends StatefulWidget {
  var title;
  //const Wallet({Key key}) : super(key: key);
  Wallet(this.title);
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  var dio = Dio();
  var responseData;
  var cryptoData;
  var bitCoinPrice;
  bool _load = false;
  String userId, userPhone, userEmail;
  double totalAmount;
  List pp;
  Timer _bitTimer;
  String paymentStatus, paymentId;
  double gst, tds, royalty;
  List coinList = [
    {"coinId": "kodecoin", "price_inr": "", "totalQty": "", "totalAmount": ""},
    {"coinId": "bitcoin", "price_inr": "", "totalQty": "", "totalAmount": ""},
    {"coinId": "ethereum", "price_inr": "", "totalQty": "", "totalAmount": ""}
  ];
  //var coins = [];
  //List<TextEditingController> _bitCoinText = new List();
  //List<double> totalAmount = [];
  TextEditingController _amountText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountText = new TextEditingController();
    totalAmount = 0.0;
    //_bitCoinText.text = "0.0";
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getWallet();
  }

  @override
  void dispose() {
    super.dispose();
    _bitTimer.cancel();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    _bitTimer = Timer(Duration(seconds: 5), () {
      _getWallet();
    });
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
                                height:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: coinList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // _bitCoinText
                                        //     .add(new TextEditingController());
                                        return CryptoCurrencySell(
                                          coinList1: coinList[index],
                                          userId:userId,
                                          cryptoData:cryptoData
                                        );
                                      }))
                            ]),

                        //)
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // InkWell(
                                              //   onTap: () {
                                              //     bool validation =
                                              //         _fieldCheck();
                                              //     print("validation..." +
                                              //         validation.toString());
                                              //     if (validation) {
                                              //       // _redeemRequest();
                                              //       _keyGenerate();
                                              //     }
                                              //   },
                                              //   child: Container(
                                              //       alignment: Alignment.center,
                                              //       width:
                                              //           MediaQuery.of(context)
                                              //                   .size
                                              //                   .width /
                                              //               3,
                                              //       padding: EdgeInsets.only(
                                              //         top:
                                              //             MediaQuery.of(context)
                                              //                     .size
                                              //                     .width *
                                              //                 0.03,
                                              //         bottom:
                                              //             MediaQuery.of(context)
                                              //                     .size
                                              //                     .width *
                                              //                 0.03,
                                              //         left:
                                              //             MediaQuery.of(context)
                                              //                     .size
                                              //                     .width *
                                              //                 0.03,
                                              //         right:
                                              //             MediaQuery.of(context)
                                              //                     .size
                                              //                     .width *
                                              //                 0.03,
                                              //       ),
                                              //       color:
                                              //           AppColors.buttonColor,
                                              //       child: Text(
                                              //         "Redeem",
                                              //         style: TextStyle(
                                              //             fontWeight:
                                              //                 FontWeight.bold),
                                              //       )),
                                              // ),
                                              //Spacer(),
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
                                                    // width:
                                                    //     MediaQuery.of(context)
                                                    //             .size
                                                    //             .width /
                                                    //         3,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
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
      userPhone = pref.get("phone");
      userEmail = pref.get("email");

      // var param1 = FormData.fromMap({
      //   "oAuth_json": json.encode({
      //     "sKey": "dfdbayYfd4566541cvxcT34#gt55",
      //     "aKey": "3EC5C12E6G34L34ED2E36A9"
      //   }),
      //   "jsonParam": json.encode({})
      // });
      // var response1 = await dio.post(Consts.CRYPTO_CURRENCY, data: param1);
      // responseData = response1.data["respData"];
      // print("all coins..." + responseData.toString());
      // for (int i = 0; i < responseData.length; i++) {
      //   if (!coins.contains(responseData[i]["crypto_id"]))
      //     coins.add(responseData[i]["crypto_id"]);
      // }
      //print("coins..." + coins.toString());
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
        //"jsonParam": json.encode({"user_id": userId, "crypto_id": "bitcoin"})
        "jsonParam": json.encode({"user_id": userId})
      });
      var formData2 = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var formData3 = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var response = await Future.wait([
        dio.post(Consts.USER_LIST, data: formData),
        dio.post(Consts.CRYPTOCURRENCY_WALLET, data: formData1),
        dio.post(Consts.CRYPTO_CURRENCY, data: formData2),
        dio.post(Consts.TERMS_CONDITIONS, data: formData3)
      ]);
      responseData = response[0].data["respData"];
      cryptoData = response[1].data["respData"];
      bitCoinPrice = response[2].data["respData"];
      gst = double.parse(response[3].data["respData"]["gst"]);
      tds = double.parse(response[3].data["respData"]["tds"]);
      royalty = double.parse(response[3].data["respData"]["royalty"]);
      print("CryptoData..." + cryptoData.toString());
      // print("CryptoData..0." + responseData.toString());
      print("CryptoData...bitcoinprice..." + bitCoinPrice.toString());

      bitCoinPrice.map((e) {
        print("eprint..." + e.toString());
        for (int i = 0; i < coinList.length; i++) {
          if (e["crypto_id"] == coinList[i]["coinId"]) {
            for (int j = 0; j < cryptoData.length; j++) {
              if (e["crypto_id"] == cryptoData[j]["crypto_id"]) {
                setState(() {
                  coinList[i]["price_inr"] = e["current_price_inr"];
                  coinList[i]["totalQty"] = cryptoData[j]["total_qty"];
                  coinList[i]["totalAmount"] = cryptoData[j]["total_amount"];
                });
              }
            }
          }
        }
      }).toList();
      print("coinList..." + coinList.toString());

      pp = response[2]
          .data["respData"]
          .where((e) => e["crypto_id"] == "bitcoin")
          .toList();

      print("pp length..." + pp.length.toString());
      print("pp length...coins..." + pp.toString());

      // print("responseData..user." + responseData.toString());
      // print("responseData..bitcoin." + bitCoinPrice.runtimeType.toString());
      // print("responseData..bitcoin." + pp.toString());
      // print("responseData..bitcoin." + pp[0]["current_price_inr"].toString());
      // print("responseData..." + cryptoData.toString());
      // print("responseData..." + cryptoData[0].toString());
      // print("walletAmount..." + responseData["wallet_amount"].toString());

      // print("walletAmount..." + gst.toString());
      // print("walletAmount..." + tds.toString());
      // print("walletAmount..." + royalty.toString());
      // print("walletAmount..." + pp[0]["current_price_inr"].toString());
      // if (pp.length != 0) {
      //   setState(() {
      //     totalAmount = double.parse(_bitCoinText.text.toString()) *
      //         double.parse(pp[0]["current_price_inr"]);
      //   });
      // }

      setState(() {
        _load = true;
      });
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  _redeemRequest() async {
    // print("amountText..." + userId);
    // print("amountText..." + _amountText.text.trim().toString());
    // print("amountText..." + paymentStatus.toString());
    // print("amountText..." + paymentId.toString());

    try {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": userId,
          "amount": _amountText.text.trim().toString(),
          "payment_status": paymentStatus,
          "payment_id": paymentId
        })
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
          "amount": _amountText.text.trim().toString(),
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

  _keyGenerate() async {
    try {
      var keyData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var responseData = await dio.post(Consts.PAYMENT_KEYS, data: keyData);
      if (responseData.data["success"] == 1) {
        openCheckOut(responseData.data["respData"]["Key_Id"].toString());
      }
      print("data,,," + responseData.toString());
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Success..." + response.paymentId.toString());
    paymentStatus = "1";
    paymentId = response.paymentId.toString();
    _redeemRequest();
    showCustomToast("Success: " + response.paymentId.toString());
  }

  _handlePaymentError(PaymentFailureResponse response) {
    print("Failure..." + response.message.toString());
    var msg = json.decode(response.message);
    print("Failure payment id..." + msg["error"]["reason"].toString());
    showCustomToast("Failure..." + msg["error"]["reason"].toString());
    //showCustomToast()
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    print("Externel payment id..." + response.walletName.toString());
    showCustomToast("Externel wallet..." + response.walletName.toString());
  }

  openCheckOut(String keyData) async {
    print("keyData,,," + keyData.toString());
    print("keyData,,," + _amountText.text.trim().toString());
    print("keyData,,," + userPhone.toString());
    print("keyData,,," + userEmail.toString());

    var options = {
      'key': keyData,
      'amount': int.parse(_amountText.text.trim().toString()) * 100,
      'name': "Redeem",
      'prefill': {'contact': userPhone, 'email': userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  totalAmountCalculate(String val, int index) {
    // var totalValue = double.parse(val) *
    //     double.parse(bitCoinPrice[index]["current_price_inr"].toString());
    // print("TotalValue..." + totalValue.toString());
    // totalAmount.add(totalValue);
    // print("TotalValue..." + totalAmount.toString());
  }

  
}
