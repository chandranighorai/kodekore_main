import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';

class CryptoCurrencySell extends StatefulWidget {
  var coinList1, userId, cryptoData;
  CryptoCurrencySell({this.coinList1, this.userId, this.cryptoData});

  @override
  _CryptoCurrencySellState createState() => _CryptoCurrencySellState();
}

class _CryptoCurrencySellState extends State<CryptoCurrencySell> {
  TextEditingController _bitCoinText;
  var dio = Dio();
  double totalAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0.0;
    _bitCoinText = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.02)),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 9.0)]),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.05,
                  // bottom:
                  //     MediaQuery.of(context).size.width * 0.05,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        // "bitcoin"
                        //     .toUpperCase()
                        "${widget.coinList1["coinId"]}".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.bgColor,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.045),
                      ),
                      Spacer(),
                      widget.coinList1["price_inr"].length == 0
                          ? SizedBox()
                          : Text(
                              //"${pp[0]["current_price_inr"]} INR",
                              "${widget.coinList1["price_inr"]} INR",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bgColor,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.045),
                            )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Text(
                    "Qty : ${widget.coinList1["totalQty"]}",
                    //"Qty : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgColor,
                        fontSize: MediaQuery.of(context).size.width * 0.037),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Text(
                    "Rate : ${widget.coinList1["totalAmount"]} INR",
                    //"Rate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgColor,
                        fontSize: MediaQuery.of(context).size.width * 0.037),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.12,
                        width: MediaQuery.of(context).size.width / 4.8,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.00,
                            bottom: MediaQuery.of(context).size.width * 0.00,
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02),
                        color: Colors.grey[100],
                        child: TextFormField(
                          controller: _bitCoinText,
                          keyboardType: TextInputType.number,
                          //maxLength: 100,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                            hintText: "Qty",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            print("Val.." + value.toString());
                            setState(() {
                              if (value.length == 0) {
                                totalAmount = 0.0;
                              } else {
                                // print("total..." +
                                //     index
                                //         .toString());

                                // totalAmount = double.parse(
                                //         value) *
                                //     double.parse(
                                //         //pp[0]["current_price_inr"].toString());
                                //         coinList[index]["price_inr"].toString());
                                _totalAmount(value,
                                    widget.coinList1["price_inr"].toString());

                                // totalAmount.add(
                                //     totalValue);
                                // print("totalAmount..." +
                                //     totalAmount
                                //         .toString());
                                // double.parse(cryptoData[
                                //     "total_amount"]);

                                // totalAmountCalculate(
                                //     value,
                                //     index);
                              }
                            });
                          },
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Amt. $totalAmount INR",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.037),
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
                    height: MediaQuery.of(context).size.width * 0.03,
                  ),
                  widget.coinList1["price_inr"].length == 0
                      ? Center(child: Text("Fetching Data..."))
                      : Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            color: AppColors.buttonColor,
                            child: TextButton(
                                onPressed: () {
                                  if (_bitCoinText.text == "0") {
                                    showCustomToast("give proper input");
                                  } else {
                                    _sellBitCoin();
                                  }
                                },
                                child: Text(
                                  "Sell Now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
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
      ),

      //}
    );
  }

  _sellBitCoin() async {
    try {
      // print("UserId..." + userId.toString());
      // //print("cryptoId..." + userId.toString());
      // print("UserId..." + _bitCoinText.text.toString());
      // print("UserId..." + widget.userId.toString());
      // print("UserId..." + widget.coinList1["coinId"].toString());
      // print("UserId..." + _bitCoinText.text.trim().toString());
      // print("UserId..." + totalAmount.toString());
      // print("UserId..." + totalAmount.toString());

      // double newGst = double.parse(totalAmount.toString()) * (gst / 100);
      // double newTds = double.parse(totalAmount.toString()) * (tds / 100);
      // double newTotal = newGst + newTds + double.parse(totalAmount.toString());

      // print("newGst..." + gst.toString());
      // print("newGst..." + tds.toString());
      // print("newGst..." + totalAmount.toString());
      // print("newGst..." + newGst.toString());
      // print("newGst..." + newTds.toString());
      // print("newGst..." + newTotal.toString());
      print("total qty..." + widget.coinList1["totalQty"].toString());
      if (widget.coinList1["totalQty"].toString() == "0") {
        showCustomToast("There is no Coin to Sell");
      } else {
        var formData = FormData.fromMap({
          "oAuth_json": json.encode({
            "sKey": "dfdbayYfd4566541cvxcT34#gt55",
            "aKey": "3EC5C12E6G34L34ED2E36A9"
          }),
          "jsonParam": json.encode({
            "user_id": widget.userId,
            "crypto_id": widget.coinList1["coinId"].toString(),
            "quantity": _bitCoinText.text.trim().toString(),
            "amount": totalAmount.toString(),
            // "gst_per": gst.toString(),
            // "gst_rate": newGst.toString(),
            // "tds_per": tds.toString(),
            // "tds_rate": newTds.toString(),
            "grand_total": totalAmount.toString()
            //"amount": totalAmount.toString()
          })
        });
        var response =
            await dio.post(Consts.SELL_CRIPTOCURRENCY, data: formData);
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
      }
    } on DioError catch (e) {
      print(e.toString());
      print("No Network");
    }
  }

  _totalAmount(String value, String priceInr) {
    setState(() {
      totalAmount = double.parse(value) * double.parse(
          //pp[0]["current_price_inr"].toString());
          priceInr);
    });
  }
}
