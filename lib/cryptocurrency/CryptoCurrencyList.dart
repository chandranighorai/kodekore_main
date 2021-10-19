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

import '../Consts/AppConsts.dart';
import '../util/Const.dart';

class CryptoCurrencyList extends StatefulWidget {
  RespData cryptoDataList;
  String userId;

  CryptoCurrencyList({this.cryptoDataList, this.userId, Key key})
      : super(key: key);

  @override
  _CryptoCurrencyListState createState() => _CryptoCurrencyListState();
}

class _CryptoCurrencyListState extends State<CryptoCurrencyList> {
  TextEditingController quantitytext;
  var dio = Dio();
  String amountText;
  bool buyEnable;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantitytext = new TextEditingController();
    amountText = "0";
    buyEnable = true;
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
                      print("amount..." + value.toString());
                      _totalAmount(
                          value, widget.cryptoDataList.currentPriceInr);
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
                          setState(() {
                            buyEnable = false;
                          });
                          _buyNow();
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
    // print("USERId..." + widget.userId);
    // print("USERId..." + widget.cryptoDataList.cryptoId);
    // print("USERId..." + quantitytext.text.trim().toString());
    // print("USERId..." + amountText);
    try {
      if (quantitytext.text.trim().length == 0) {
        showCustomToast("Enter Quantity");
        setState(() {
          buyEnable = true;
        });
      } else {
        var formData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "user_id": widget.userId.toString(),
            "crypto_id": widget.cryptoDataList.cryptoId,
            "quantity": quantitytext.text.trim().toString(),
            "amount": amountText.toString()
          })
        });
        var response =
            await dio.post(Consts.BUY_CRYPTOCURRENCY, data: formData);
        print("response data..." + response.data.toString());
        if (response.data["success"] == 1) {
          setState(() {
            buyEnable = true;
            quantitytext.text = "";
            amountText = "0";
          });
        }
        showCustomToast(response.data["message"].toString());
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
