// import 'package:flutter/material.dart';
// import 'package:kode_core/cryptocurrency/CryptoCurrencyModel.dart';
// import 'package:kode_core/util/AppColors.dart';

// class CryptoCurrencyList extends StatefulWidget {
//   RespData cryptoDataList;
//   CryptoCurrencyList({this.cryptoDataList, Key key}) : super(key: key);

//   @override
//   _CryptoCurrencyListState createState() => _CryptoCurrencyListState();
// }

// class _CryptoCurrencyListState extends State<CryptoCurrencyList> {
//   TextEditingController quantitytext;
//   String amountText;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     quantitytext = new TextEditingController();
//     amountText = "0";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: MediaQuery.of(context).size.width * 0.06,
//           right: MediaQuery.of(context).size.width * 0.06,
//           top: MediaQuery.of(context).size.width * 0.03,
//           bottom: MediaQuery.of(context).size.width * 0.03),
//       child: Container(
//         padding: EdgeInsets.only(
//             top: MediaQuery.of(context).size.width * 0.04,
//             bottom: MediaQuery.of(context).size.width * 0.04,
//             left: MediaQuery.of(context).size.width * 0.04,
//             right: MediaQuery.of(context).size.width * 0.04),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//                 Radius.circular(MediaQuery.of(context).size.width * 0.03)),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(color: AppColors.dashboardFontColor, blurRadius: 9.0)
//             ]),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   "${widget.cryptoDataList.cryptoName}",
//                   style: TextStyle(
//                       color: AppColors.bgColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width * 0.043),
//                 ),
//                 Spacer(),
//                 Text(
//                   "Price ${widget.cryptoDataList.currentPriceInr} INR",
//                   style: TextStyle(
//                       color: AppColors.bgColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width * 0.043),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.width * 0.04,
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.width * 0.08,
//                   width: MediaQuery.of(context).size.width / 3.5,
//                   color: Colors.grey[200],
//                   padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).size.width * 0.00,
//                       bottom: MediaQuery.of(context).size.width * 0.00,
//                       left: MediaQuery.of(context).size.width * 0.02,
//                       right: MediaQuery.of(context).size.width * 0.02),
//                   child: TextFormField(
//                     controller: quantitytext,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                         hintText: "Qty",
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(
//                             fontSize:
//                                 MediaQuery.of(context).size.width * 0.038)),
//                     onChanged: (value) {
//                       print("amount..." + value.toString());
//                       _totalAmount(
//                           value, widget.cryptoDataList.currentPriceInr);
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.02,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 3.5,
//                   child: Text("Amt: $amountText INR"),
//                 ),
//                 Spacer(),
//                 Container(
//                     padding: EdgeInsets.all(
//                         MediaQuery.of(context).size.width * 0.02),
//                     color: AppColors.buttonColor,
//                     child: Text(
//                       "Buy Now",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   _totalAmount(String value, String inrValue) {
//     double val = double.parse(value);
//     double inrVal = double.parse(inrValue);
//     print("Val..." + val.toString());
//     print("InrVal..." + inrVal.toString());
//     setState(() {
//       amountText = (val * inrVal).toString();
//     });
//   }
// }
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/cryptocurrency/CryptoCurrencyModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:flutter/services.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Consts/AppConsts.dart'; 
import '../util/Const.dart';
import 'package:payumoney_pro_unofficial/payumoney_pro_unofficial.dart';

class CryptoCurrencyList extends StatefulWidget {
  RespData cryptoDataList;
  String userId;
  double gst;
  double tds;
  double royalty;

  CryptoCurrencyList(
      {this.cryptoDataList,
      this.userId,
      this.gst,
      this.tds,
      this.royalty,
      Key key})
      : super(key: key);

  @override
  _CryptoCurrencyListState createState() => _CryptoCurrencyListState();
}

class _CryptoCurrencyListState extends State<CryptoCurrencyList> {
  TextEditingController quantitytext;
  var dio = Dio();
  String amountText;
  bool buyEnable;
  // static const platform = const MethodChannel("razorpay_flutter");
  // Razorpay _razorpay;
  var userPhone, userEmail;
  String paymentId = "null";
  String paymentStatus = "null";
  double newTotal, newGst, newTds;
  int grandTotal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantitytext = new TextEditingController();
    amountText = "0";
    buyEnable = true;
    // _razorpay = new Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlepaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlepaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
          top: MediaQuery.of(context).size.width * 0.03,
          bottom: MediaQuery.of(context).size.width * 0.03),
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.03)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: AppColors.dashboardFontColor, blurRadius: 9.0)
            ]),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${widget.cryptoDataList.cryptoName}",
                  style: TextStyle(
                      color: AppColors.bgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.043),
                ),
                Spacer(),
                Text(
                  "Price ${widget.cryptoDataList.currentPriceInr} INR",
                  style: TextStyle(
                      color: AppColors.bgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.043),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.04,
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.08,
                  width: MediaQuery.of(context).size.width / 3.5,
                  color: Colors.grey[200],
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.00,
                      bottom: MediaQuery.of(context).size.width * 0.00,
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: TextFormField(
                    controller: quantitytext,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Qty",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038)),
                    onChanged: (value) {
                      print("amount..." + value.length.toString());
                      if (value.length == 0) {
                        amountText = "0.0";
                      } else {
                        _totalAmount(
                            value, widget.cryptoDataList.currentPriceInr);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Text("Amt: $amountText INR"),
                ),
                Spacer(),
                buyEnable == true
                    ? InkWell(
                        onTap: () {
                          // setState(() {
                          //   buyEnable = false;
                          // });
                          //_keyGenerate();
                          openCheckOut();
                          //_buyNow();
                        },
                        child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            color: AppColors.buttonColor,
                            child: Text(
                              "Buy Now",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      )
                    : Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        color: AppColors.buttonColor.withOpacity(0.5),
                        child: Text(
                          "Buy Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ))
              ],
            )
          ],
        ),
      ),
    );
  }

  _totalAmount(String value, String inrValue) {
    double val = double.parse(value);
    double inrVal = double.parse(inrValue);
    print("Val..." + val.toString());
    print("InrVal..." + inrVal.toString());
    setState(() {
      amountText = (val * inrVal).toString();
    });
  }

  _buyNow() async {
    print("USERId..." + widget.userId.toString());
    print("newTotal..." + newTotal.toString());
    // print("USERId..." + widget.cryptoDataList.cryptoId);
    // print("USERId..." + quantitytext.text.trim().toString());
    // print("USERId..." + amountText);
    try {
      // if (quantitytext.text.trim().length == 0) {
      //   showCustomToast("Enter Quantity");
      //   // setState(() {
      //   //   buyEnable = true;
      //   // });
      // } else {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": widget.userId.toString(),
          "crypto_id": widget.cryptoDataList.cryptoId,
          "quantity": quantitytext.text.trim().toString(),
          "amount": amountText.toString(),
          "payment_status": paymentStatus,
          "payment_id": paymentId,
          "gst_per": widget.gst.toString(),
          "gst_rate": newGst.toString(),
          "tds_per": widget.tds.toString(),
          "tds_rate": newTds.toString(),
          "grand_total": newTotal.toString()
          //"grand_total": (grandTotal / 100).toString()
        })
      });
      var response = await dio.post(Consts.BUY_CRYPTOCURRENCY, data: formData);
      print("response data..." + response.data.toString());
      if (response.data["success"] == 1) {
        setState(() {
          buyEnable = true;
          quantitytext.text = "";
          amountText = "0";
        });
      }
      showCustomToast(response.data["message"].toString());
      //}
      setState(() {
        buyEnable = true;
      });
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  // _handlepaymentSuccess(PaymentSuccessResponse response) {
  //   print("Success..." + response.paymentId.toString());
  //   setState(() {
  //     paymentId = response.paymentId.toString();
  //     paymentStatus = "1";
  //     _buyNow();
  //   });
  //   showCustomToast("Success: " + response.paymentId.toString());
  // }

  // _handlepaymentError(PaymentFailureResponse response) {
  //   print("Failure..." + response.code.toString());
  //   print("Failure..." + response.message.toString());
  //   var message = json.decode(response.message);
  //   setState(() {
  //     buyEnable = true;
  //   });
  //   showCustomToast("Failure: " + message["error"]["reason"].toString());
  // }

  // _handleExternalWallet(ExternalWalletResponse response) {
  //   print("Wallet..." + response.walletName.toString());
  //   showCustomToast("Wallet: " + response.walletName.toString());
  // }

  _keyGenerate() async {
    //print("Razorpay..." + _razorpay.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhone = prefs.getString("phone");
    userEmail = prefs.getString("email");
    try {
      if (quantitytext.text.trim().length == 0) {
        showCustomToast("Enter Quantity");
        // setState(() {
        //   buyEnable = true;
        // });
      } else {
        setState(() {
          buyEnable = false;
        });
        var keyData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({})
        });
        var responseData = await dio.post(Consts.PAYMENT_KEYS, data: keyData);
        print("responseData in crypto..." + responseData.data.toString());
        if (responseData.data["success"] == 1) {
          //openCheckOut(responseData.data["respData"]["Key_Id"].toString());
        }
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  openCheckOut() async {
    print("crpytoName..." + amountText.toString());
    print("jkjk..." + widget.cryptoDataList.cryptoName.toString());
    print("gst..." + (widget.gst / 100).toString());
    print("tds..." + (widget.tds / 100).toString());
    //var price = amountText.split(".");
    // print("crpytoName..." + price.toString());
    // print("crpytoName..." +
    //     (((int.parse(price[0]) * 100) + (int.parse(price[1])))).toString());

    newGst = double.parse(amountText.toString()) * (widget.gst / 100);
    newTds = double.parse(amountText.toString()) * (widget.tds / 100);
    //newTotal = newGst + newTds + double.parse(amountText.toString());
    newTotal = double.parse(amountText.toString());
    print("crpytoName..." + newTotal.toString());

    // print("newGst..." + newGst.toString());
    // print("newTds..." + newTds.toString());
    // print("newTotal..." + newTotal.toString());

    //var price = newTotal.toStringAsFixed(2).split(".");

    // var price =
    //     double.parse(amountText.toString()).toStringAsFixed(2).split(".");
    // print("newTotal..." + price.toString());

    // grandTotal = ((int.parse(price[0]) * 100) + (int.parse(price[1])));
    // print("newTotal..." + grandTotal.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhone = prefs.getString("phone");
    userEmail = prefs.getString("email");
    //String amount = amountText.toString();
    String amount = newTotal.toString();
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    print("amount..." + amount.toString());
    print("amount..." + orderId.toString());
    var response = await PayumoneyProUnofficial.payUParams(
        amount: amount,
        isProduction: true,
        productInfo: widget.cryptoDataList.cryptoName.toString(),
        //merchantKey: 'oZ7oo9',
        merchantKey: 'UZhUeS',
        userPhoneNumber: userPhone.toString(),
        transactionId: orderId,
        firstName: widget.cryptoDataList.cryptoName.toString(),
        merchantName: 'Kode Core',
        //merchantSalt: 'UkojH5TS',
        merchantSalt: '6COcY3BwdolyV43pW6BgPC4LE4kMW4Ek',
        email: userEmail.toString(),
        hashUrl: '',
        showLogs: true,
        showExitConfirmation: true,
        userCredentials: 'merchantKey:kodecore.payment@gmail.com');
    print("response..." + response.toString());
    print("response..." + response['status'].toString());
    var keyId = json.decode(response['payuResponse']);
    if (response['status'] == PayUParams.success)
      handlepaymentSuccess(keyId['id'].toString(), amount);
    if (response['status'] == PayUParams.failed)
      handlePaymentFailure(amount, response['message']);

    // var options = {
    //   'key': keyString,
    //   //'amount': (double.parse(amountText.toString()) * 100).toString(),
    //   // 'amount':
    //   //     (((int.parse(price[0]) * 100) + (int.parse(price[1])))).toString(),
    //   'amount': grandTotal.toString(),
    //   'name': widget.cryptoDataList.cryptoName.toString(),
    //   'prefill': {
    //     'contact': userPhone.toString(),
    //     'email': userEmail.toString()
    //   },
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };
    // print("crpytoName..." + options.toString());
    // try {
    //   _razorpay.open(options);
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  handlepaymentSuccess(String paymentIdResponse, String amount) {
    print("Success..." + paymentIdResponse.toString());
    setState(() {
      paymentId = paymentIdResponse.toString();
      paymentStatus = "1";
      _buyNow();
    });
    showCustomToast("Success: " + paymentIdResponse.toString());
  }

  handlePaymentFailure(String paymentIdResponse, String message) {
    print("paymentResponseId..." + paymentIdResponse.toString());
    showCustomToast(message);
  }
}
