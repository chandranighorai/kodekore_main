import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentViewDetails extends StatefulWidget {
  String invPlanId,
      invPlanTitle,
      invPlanDesc,
      invPlanAmount,
      invDuration,
      invAmount,
      userId;
  double gst, tds, royalty;
  InvestmentViewDetails(
      {this.invPlanId,
      this.invPlanTitle,
      this.invPlanDesc,
      this.invPlanAmount,
      this.invDuration,
      this.invAmount,
      this.userId,
      this.gst,
      this.tds,
      this.royalty,
      Key key})
      : super(key: key);

  @override
  _InvestmentViewDetailsState createState() => _InvestmentViewDetailsState();
}

class _InvestmentViewDetailsState extends State<InvestmentViewDetails> {
  TextEditingController amount;
  bool pageLoad;
  var dio = Dio();
  var responseData;
  var userPhone;
  var userEmail;
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  String paymentStatus = "null";
  String paymentId = "null";
  double newGst, newTds, newTotal;
  int grandTotal;
  @override
  void initState() {
    // TODO: implement initState
    amount = new TextEditingController();
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: AppColors.bgColor,
      // ),
      //drawer: Navigation(),
      body: SingleChildScrollView(
        child: Container(
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
              Positioned(
                top: MediaQuery.of(context).size.width * 0.4,
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.08,
                      bottom: MediaQuery.of(context).size.width * 0.08,
                      left: MediaQuery.of(context).size.width * 0.08,
                      right: MediaQuery.of(context).size.width * 0.08),
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
                        "${widget.invPlanTitle}",
                        style: TextStyle(
                            color: AppColors.bgColor,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.06,
                      ),
                      widget.invPlanDesc.length > 700
                          ? Container(
                              height: MediaQuery.of(context).size.width * 0.55,
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                children: [
                                  Html(
                                    data: widget.invPlanDesc,
                                    style: {
                                      "body": Style(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(0),
                                          textAlign: TextAlign.justify)
                                    },
                                  )
                                ],
                              ),
                            )
                          : Html(
                              data: widget.invPlanDesc,
                              style: {
                                "body": Style(
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.all(0),
                                    textAlign: TextAlign.justify)
                              },
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        "Return Rate: ${widget.invPlanAmount} %",
                        style: TextStyle(
                            color: AppColors.bgColor,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        "Duration: ${widget.invDuration} months",
                        style: TextStyle(
                            color: AppColors.bgColor,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Row(
                        children: [
                          Text(
                            "Investment Amount:",
                            style: TextStyle(
                                color: AppColors.bgColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            "${widget.invAmount}",
                            style: TextStyle(
                                color: AppColors.bgColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold),
                          )
                          // Container(
                          //   height: MediaQuery.of(context).size.width * 0.09,
                          //   width: MediaQuery.of(context).size.width / 2.8,
                          //   padding: EdgeInsets.only(
                          //       top: MediaQuery.of(context).size.width * 0.00,
                          //       bottom:
                          //           MediaQuery.of(context).size.width * 0.00,
                          //       left: MediaQuery.of(context).size.width * 0.01,
                          //       right:
                          //           MediaQuery.of(context).size.width * 0.01),
                          //   color: Colors.grey[300],
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.number,
                          //     controller: amount,
                          //     decoration: InputDecoration(
                          //         hintText: "Enter Amount",
                          //         border: InputBorder.none),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.22,
                            right: MediaQuery.of(context).size.width * 0.22),
                        child: Container(
                            color: AppColors.buttonColor,
                            alignment: Alignment.center,
                            child: TextButton(
                                child: Text(
                                  "Invest Now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () =>
                                    //{
                                    //setState(() {
                                    //_investNow();
                                    _keyGenerate()
                                //}),
                                //},
                                )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // _investBrought() async {
  //   try {
  //     var formData = FormData.fromMap({
  //       "oAuth_json": json.encode({
  //         "sKey": "dfdbayYfd4566541cvxcT34#gt55",
  //         "aKey": "3EC5C12E6G34L34ED2E36A9"
  //       }),
  //       "jsonParam": json
  //           .encode({"user_id": widget.userId, "inv_plan_id": widget.invPlanId})
  //     });
  //     var response = await dio.post(Consts.INVESTMENT_PLANS_BOUGHT_BY_USER,
  //         data: formData);
  //     var responseSuccess = response.data["success"];
  //     if (responseSuccess == 1) {
  //       setState(() {
  //         investBtn = true;
  //       });
  //     } else {
  //       setState(() {
  //         investBtn = false;
  //       });
  //     }
  //     _instmentPlan();
  //     print("response data..." + response.data.toString());
  //   } on DioError catch (e) {
  //     print(e.toString());
  //     showCustomToast("No Network");
  //   }
  // }

  // _instmentPlan() async {
  //   try {
  //     var formData1 = FormData.fromMap({
  //       "oAuth_json": json.encode({
  //         "sKey": "dfdbayYfd4566541cvxcT34#gt55",
  //         "aKey": "3EC5C12E6G34L34ED2E36A9"
  //       }),
  //       "jsonParam": json.encode({"inv_plan_id": widget.invPlanId})
  //     });
  //     var response = await dio.post(Consts.INVESTMENT_BY_USER, data: formData1);
  //     responseData = response.data["respData"];
  //     setState(() {
  //       pageLoad = true;
  //     });
  //   } on DioError catch (e) {
  //     print(e.toString());
  //     showCustomToast("No Network");
  //   }
  // }

  _investNow() async {
    // print("It Price...0.." + widget.userId.toString());
    // print("It Price...0.." + widget.invPlanId.toString());
    // print("It Price...0.." + amount.text.toString());
    // print("It Price...0.." + paymentStatus.toString());
    // print("It Price...0.." + paymentId.toString());
    // print("It Price...0.." + widget.gst.toString());
    // print("It Price...0.." + newGst.toString());
    // print("It Price...0.." + widget.tds.toString());
    // print("It Price...0.." + newTds.toString());
    // print("It Price...0.." + (grandTotal / 100).toString());
    try {
      // if (amount.text.length == 0) {
      //   showCustomToast("Enter amount");
      // } else {
      var amountData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": widget.userId,
          "inv_plan_id": widget.invPlanId,
          //"inv_amount": amount.text.toString(),
          "inv_amount": widget.invAmount.toString(),
          "payment_status": paymentStatus,
          "payment_id": paymentId,
          "gst_per": widget.gst.toString(),
          "gst_rate": newGst.toString(),
          "tds_per": widget.tds.toString(),
          "tds_rate": newTds.toString(),
          "grand_total": (grandTotal / 100).toString()
        })
      });
      var invest = await dio.post(Consts.BUY_INVESTMENT_PLAN, data: amountData);
      showCustomToast(invest.data["message"]);
      // setState(() {
      //   amount.text = "";
      // });
      //}
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Success..." + response.paymentId.toString());
    setState(() {
      paymentId = response.paymentId;
      paymentStatus = "1";
      _investNow();
    });
    showCustomToast("Success: " + response.paymentId.toString());
  }

  _handlePaymentError(PaymentFailureResponse response) {
    print("Failure..." + response.code.toString());
    print("Failure..." + response.message.toString());
    var message = json.decode(response.message);
    showCustomToast("Failure: " + message["error"]["reason"].toString());
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    print("Wallet..." + response.walletName.toString());
    showCustomToast("Wallet: " + response.walletName.toString());
  }

  _keyGenerate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhone = prefs.getString("phone");
    userEmail = prefs.getString("email");

    try {
      // if (amount.text.length == 0) {
      //   showCustomToast("Enter amount");
      // } else {
      var keydata = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var keyResponse = await dio.post(Consts.PAYMENT_KEYS, data: keydata);
      print("Keydata..." + keyResponse.data.toString());
      if (keyResponse.data["success"] == 1) {
        openCheckOut(keyResponse.data["respData"]["Key_Id"].toString());
      }
      // }
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  openCheckOut(String keyString) async {
    // print("KeyString..." + keyString.toString());
    // print("KeyString..." + widget.tds.toString());
    //newGst = double.parse(widget.invAmount.toString()) * (widget.gst / 100);
    //newTds = double.parse(widget.invAmount.toString()) * (widget.tds / 100);
    //newTotal = newGst + newTds + double.parse(widget.invAmount.toString());
    newTotal = double.parse(widget.invAmount.toString());
    var price = newTotal.toStringAsFixed(2).split(".");
    // print("It Price..." + widget.gst.toString());
    // print("It Price..." + widget.tds.toString());
    // print("It Price..." + newGst.toString());
    // print("It Price..." + newTds.toString());
    // print("It Price..." + newTotal.toString());
    // print("It Price..." +
    //     ((int.parse(price[0]) * 100) + int.parse(price[1])).toString());
    grandTotal = ((int.parse(price[0]) * 100) + int.parse(price[1]));
    print("grandtotal..." + grandTotal.toString());
    var options = {
      'key': keyString,
      //'amount': (double.parse(amount.text.toString()) * 100).toString(),
      'amount': grandTotal.toString(),
      'name': widget.invPlanTitle.toString(),
      'prefill': {
        'contact': userPhone.toString(),
        'email': userEmail.toString()
      },
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
}
