import 'dart:async';
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
// import 'package:flutter/services.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'NewModel.dart';
import 'package:payumoney_pro_unofficial/payumoney_pro_unofficial.dart';

class ViewDetails extends StatefulWidget {
  var itModelList,
      itModelTitle,
      itModelDescription,
      itModelAmount,
      itModelDuration,
      itModelPaymentBreakup,
      itModelFirstInstallment,
      itModelSecondInstallment,
      itModelFirstInstallmentAmount,
      itModelSecondInstallmentAmount;
  //RespData itModelDetails;
  double gst, tds, royalty;
  ViewDetails(
      {this.itModelList,
      this.itModelTitle,
      this.itModelDescription,
      this.itModelAmount,
      this.itModelDuration,
      this.itModelPaymentBreakup,
      this.itModelFirstInstallment,
      this.itModelSecondInstallment,
      this.itModelFirstInstallmentAmount,
      this.itModelSecondInstallmentAmount,
      //this.itModelDetails,
      this.gst,
      this.tds,
      this.royalty,
      Key key})
      : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  //GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  double newTotal, newGst, newTds, newRoyalty;
  int grandTotal;
  var userId, userEmail, userphone;
  var dio = Dio();
  var responseData;
  var responseSuccess;
  var buyBtnShowSuccess;
  var buyResponse;
  ItModel itmodel;
  bool pageLoad = false;
  bool buyBtnShow = true;
  String paymentStatus = "null";
  String paymentId = "null";
  String installmentSerial;
  // static const platform = const MethodChannel("razorpay_flutter");
  // Razorpay _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    _projectBrought();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternelWallet);
  }

  @override
  void dispose() {
    super.dispose();
    //_razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    print("modelId..." + widget.itModelDescription.length.toString());
    //print("modelId...0.." + widget.itModelDetails.toString());

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
                    bottom: MediaQuery.of(context).size.width * 0.02,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.04,
                          //bottom: MediaQuery.of(context).size.width * 0.08,
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
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          // Text(
                          //     //"4.2.1. Users can choose a suitable investment plan from the multiple plans given by the admin while creating a plan from admin."),
                          //     "${responseData["description"]}"),
                          widget.itModelDescription.length > 400
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.45,
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
                                              padding: EdgeInsets.all(0),
                                              textAlign: TextAlign.justify)
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
                                        padding: EdgeInsets.all(0),
                                        textAlign: TextAlign.justify)
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
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02,
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
                            "Duration: ${widget.itModelDuration} Month",
                            style: TextStyle(
                              color: AppColors.bgColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          widget.itModelPaymentBreakup != "2"
                              ? SizedBox()
                              : Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Price Break up",
                                          style: TextStyle(
                                              color: AppColors.bgColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                'LOI(${widget.itModelFirstInstallment} %): ',
                                            style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: installmentSerial ==
                                                            "1" ||
                                                        installmentSerial == "2"
                                                    ? Colors.grey
                                                    : Colors.black)),
                                        TextSpan(
                                            text:
                                                '${widget.itModelFirstInstallmentAmount} INR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: installmentSerial ==
                                                            "1" ||
                                                        installmentSerial == "2"
                                                    ? Colors.grey
                                                    : AppColors
                                                        .transactionDarkGreen))
                                      ])),
                                      // Text(
                                      //     "First Installment(${widget.itModelFirstInstallment} %): ${widget.itModelFirstInstallmentAmount} INR"),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                'Rest(${widget.itModelSecondInstallment} %): ',
                                            style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: installmentSerial == "1"
                                                    ? AppColors
                                                        .transactionDarkGreen
                                                    : Colors.grey)),
                                        TextSpan(
                                            text:
                                                '${widget.itModelSecondInstallmentAmount} INR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: installmentSerial == "1"
                                                    ? AppColors
                                                        .transactionDarkGreen
                                                    : Colors.grey))
                                      ])),
                                      // Text(
                                      //     "Last Installment(${widget.itModelSecondInstallment} %): ${widget.itModelSecondInstallmentAmount} INR")
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.06,
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
                                        widget.itModelPaymentBreakup != "2"
                                            ? "Buy Now"
                                            : installmentSerial == "1"
                                                ? "Pay Rest Amount"
                                                : "Pay LOI Amount",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      onPressed: () => openCheckout(),
                                      //onPressed: () => _buyItProject(),
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
    userEmail = pref.getString("email");
    userphone = pref.getString("phone");
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
        //dio.post(Consts.USER_BUY_IT_PROJECT, data: boughtProject),
        // dio.post(Consts.IT_PROJECT_LIST, data: formData
        // )
      ]);
      print("response for baught user..." + response1.toString());
      // print("response for baught user..." +
      //     response1[0].data["message"].toString());

      buyBtnShowSuccess = response1[0].data["success"];

      //responseSuccess = response1[1].data["success"];
      //responseData = response1[1].data["respData"];
      //print("responseSuccess..." + responseSuccess.toString());
      print("responseSuccess..." + buyBtnShowSuccess.toString());
      if (buyBtnShowSuccess == 1) {
        installmentSerial = response1[0].data["respData"]["installment_serial"];
        print("Installment..." + installmentSerial.toString());
        if (installmentSerial == "2" || installmentSerial == "0") {
          setState(() {
            buyBtnShow = false;
          });
        }
        setState(() {
          pageLoad = true;
        });

        //showCustomToast(response1[1].data["respData"]["message"].toString());
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
    // print("user_id..." + userId.toString());
    // print("user_id..." + widget.itModelList.toString());
    // print("user_id..." + widget.itModelAmount.toString());

    try {
      // var boughtProject = FormData.fromMap({
      //   "oAuth_json": json.encode({
      //     "sKey": "dfdbayYfd4566541cvxcT34#gt55",
      //     "aKey": "3EC5C12E6G34L34ED2E36A9"
      //   }),
      //   "jsonParam": json.encode({
      //     "user_id": userId.toString(),
      //     "it_proj_id": widget.itModelList.toString(),
      //     "amount": widget.itModelAmount.toString()
      //   })
      // });
      var generateKey = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      buyResponse = await Future.wait([
        //dio.post(Consts.USER_BUY_IT_PROJECT, data: boughtProject),
        dio.post(Consts.PAYMENT_KEYS, data: generateKey)
      ]);
      if (buyResponse[0].data["success"] == 1) {
        //openCheckout(buyResponse[0].data["respData"]["Key_Id"].toString());
      }
      print("keyDetails..." + buyResponse.toString());
      // if (buyResponse[0].data["success"] == 1) {
      //   var buyResponseData = buyResponse[0].data["respData"];
      //   BuyNowModel buyNowModel = BuyNowModel();
      //   buyNowModel.itprojtAddedId =
      //       buyResponseData["itproj_added_id"].toString();
      //   buyNowModel.userId = buyResponseData["user_id"];
      //   buyNowModel.itProjId = buyResponseData["it_proj_id"];
      //   buyNowModel.itProjId = buyResponseData["project_amount"];
      //   buyNowModel.itProjId = buyResponseData["received_amount"];
      //   buyNowModel.itProjId = buyResponseData["application_status"];
      //   buyNowModel.itProjId = buyResponseData["payment_status"];
      //   buyNowModel.itProjId = buyResponseData["payment_mode"];
      //   // setState(() {
      //   //   pageLoad = false;
      //   //   _projectBrought();
      //   // });
      // }
      showCustomToast(buyResponse[0].data["message"]);
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }

  void openCheckout() async {
    print("modelPaymentBreakUp..." + widget.itModelPaymentBreakup.toString());
    print("modelPaymentBreakUp..." + widget.itModelAmount.toString());
    print("modelPaymentBreakUp..." + installmentSerial.toString());
    // print("modelPaymentBreakUp..." +
    //     widget.itModelFirstInstallmentAmount.toString());
    print("modelPaymentBreakUp..." +
        widget.itModelSecondInstallmentAmount.toString());
    //print("modelPaymentBreakUp..." + (widget.gst / 100).toString());
    print("modelPaymentBreakUp...gst..." + (widget.gst / 100).toString());

    newGst = double.parse(widget.itModelPaymentBreakup != "2"
            ? widget.itModelAmount.toString()
            : installmentSerial == "1"
                ? widget.itModelSecondInstallmentAmount.toString()
                : widget.itModelFirstInstallmentAmount.toString()) *
        (widget.gst / 100);
    print("modelPaymentBreakUp...newgst..." + newGst.toString());
    print("modelPaymentBreakUp...tds..." + (widget.tds / 100).toString());
    newTds = double.parse(widget.itModelPaymentBreakup != "2"
            ? widget.itModelAmount.toString()
            : installmentSerial == "1"
                ? widget.itModelSecondInstallmentAmount.toString()
                : widget.itModelFirstInstallmentAmount.toString()) *
        (widget.tds / 100);
    print("modelPaymentBreakUp...newTds..." + newTds.toString());
    print("modelPaymentBreakUp...royalty.." + widget.royalty.toString());
    newRoyalty = double.parse(widget.itModelPaymentBreakup != "2"
            ? widget.itModelAmount.toString()
            : installmentSerial == "1"
                ? widget.itModelSecondInstallmentAmount.toString()
                : widget.itModelFirstInstallmentAmount.toString()) *
        (widget.royalty / 100);
    print("modelPaymentBreakUp...new royalty..." + newRoyalty.toString());
    // newTotal = (newGst +
    //         newTds +
    //         double.parse(widget.itModelPaymentBreakup != "2"
    //             ? widget.itModelAmount.toString()
    //             : installmentSerial == "1"
    //                 ? widget.itModelSecondInstallmentAmount.toString()
    //                 : widget.itModelFirstInstallmentAmount.toString())) -
    //     newRoyalty;
    newTotal = (newGst +
        double.parse(widget.itModelPaymentBreakup != "2"
            ? widget.itModelAmount.toString()
            : installmentSerial == "1"
                ? widget.itModelSecondInstallmentAmount.toString()
                : widget.itModelFirstInstallmentAmount.toString()));
    // var price = newTotal.toStringAsFixed(2).split(".");
    // print("It Price...gst..." + widget.gst.toString());
    // // print("It Price...tds..." + widget.tds.toString());
    // print("It Price...gst..." + newGst.toString());
    // // print("It Price...newTds..." + newTds.toString());
    // // print("It Price...newRoyalty..." + newRoyalty.toString());
    // print("It Price...newTotal..." + newTotal.toString());
    // print("It Price...price..." + price.toString());
    // print("It Price..." +
    //     ((int.parse(price[0]) * 100) + int.parse(price[1])).toString());
    // grandTotal = ((int.parse(price[0]) * 100) + int.parse(price[1]));
    // print("It Price...grandTotal..." + grandTotal.toString());
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    print("OrderId..." + orderId.toString());
    //print("OrderId..." + key.toString());
    //final String amount = grandTotal.toString();
    String amount = newTotal.toString();
    var response = await PayumoneyProUnofficial.payUParams(
        amount: amount,
        isProduction: true,
        productInfo: widget.itModelTitle.toString(),
        //merchantKey: 'oZ7oo9',
        merchantKey: 'UZhUeS',
        userPhoneNumber: userphone.toString(),
        transactionId: orderId,
        firstName: widget.itModelTitle.toString(),
        merchantName: 'Kode Core',
        //merchantSalt: 'UkojH5TS',
        merchantSalt: '6COcY3BwdolyV43pW6BgPC4LE4kMW4Ek',
        email: userEmail.toString(),
        hashUrl: '',
        showLogs: true,
        showExitConfirmation: true,
        userCredentials: 'merchantKey:kodecore.payment@gmail.com');
    // print("merchantKey...UZhUeS");
    // print("merchantSaltKey...6COcY3BwdolyV43pW6BgPC4LE4kMW4Ek");
    print("response..." + response.toString());
    print("response..." + response['status'].toString());
    var keyId = json.decode(response['payuResponse']);
    if (response['status'] == PayUParams.success)
      handlepaymentSuccess(keyId['id'].toString(), amount);
    if (response['status'] == PayUParams.failed)
      handlePaymentFailure(amount, response['message']);
    // var options = {
    //   'key': key.toString(),
    //   'amount': grandTotal.toString(),
    //   //(double.parse(widget.itModelAmount.toString()) * 100).toString(),
    //   'name': widget.itModelTitle.toString(),
    //   //'description': widget.itModelDescription.toString(),
    //   'prefill': {
    //     'contact': userphone.toString(),
    //     'email': userEmail.toString()
    //   },
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };
    // try {
    //   print("options..." + options.toString());
    //   _razorpay.open(options);
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  void handlepaymentSuccess(String paymentIdResponse, String amount) {
    //print("Success payment id..." + paymentId.toString());
    setState(() {
      pageLoad = false;
      paymentStatus = "1";
      paymentId = paymentIdResponse.toString();
      _confirmBuy();
      //_projectBrought();
    });
    showCustomToast("Success..." + paymentId.toString());
  }

  handlePaymentFailure(String amount, String error) {
    print("Amount..." + amount.toString());
    print("Failed");
    print(error);
    showCustomToast(error);
  }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   print("Failure payment id..." + response.code.toString());
  //   var message = json.decode(response.message);
  //   print("Failure payment id..." + message["error"]["reason"].toString());
  //   showCustomToast("Failure..." + message["error"]["reason"].toString());
  // }

  // _handleExternelWallet(ExternalWalletResponse response) {
  //   print("Externel payment id..." + response.walletName.toString());
  //   showCustomToast("Externel wallet..." + response.walletName.toString());
  // }

  _confirmBuy() async {
    // print("It Price...0.." + userId.toString());
    // print("It Price...0.." + widget.itModelList.toString());
    print("It Price...0.." +
        double.parse(widget.itModelPaymentBreakup != "2"
                ? widget.itModelAmount.toString()
                : installmentSerial == "1"
                    ? widget.itModelSecondInstallmentAmount.toString()
                    : widget.itModelFirstInstallmentAmount.toString())
            .toString());
    print("It Price...0.." + paymentStatus.toString());
    print("It Price...0.." + paymentId.toString());
    print("It Price...0.." + widget.gst.toString());
    print("It Price...0.." + newGst.toString());
    print("It Price...0.." + widget.tds.toString());
    print("It Price...0.." + newTds.toString());
    print("It Price...0.." + widget.royalty.toString());
    print("It Price...0.." + newRoyalty.toString());
    print("It Price...0.." + newTotal.toString());
    print("It Price...0.." + userId.toString());
    print("It Price...0.." + widget.itModelList.toString());

    //print("It Price...0.." + (grandTotal / 100).toString());
    try {
      var boughtProject = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": userId.toString(),
          "it_proj_id": widget.itModelList.toString(),
          "amount": double.parse(widget.itModelPaymentBreakup != "2"
              ? widget.itModelAmount.toString()
              : installmentSerial == "1"
                  ? widget.itModelSecondInstallmentAmount.toString()
                  : widget.itModelFirstInstallmentAmount.toString()),
          "payment_status": paymentStatus,
          "payment_id": paymentId,
          "payment_breakup": widget.itModelPaymentBreakup.toString(),
          "gst_per": widget.gst.toString(),
          "gst_rate": newGst.toString(),
          "tds_per": widget.tds.toString(),
          "tds_rate": newTds.toString(),
          "royalty_per": widget.royalty,
          "royalty_rate": newRoyalty.toString(),
          //"grand_total": (grandTotal / 100).toString(),
          "grand_total": newTotal.toString(),
          "installment_serial": buyBtnShowSuccess == 0
              ? "1"
              : installmentSerial == "1"
                  ? "2"
                  : "0",
          "first_installment_per": widget.itModelFirstInstallment,
          "last_installment_per": widget.itModelSecondInstallment,
          "first_installment_amt": widget.itModelFirstInstallmentAmount,
          "last_installment_amt": widget.itModelSecondInstallmentAmount
        })
      });
      // print(json.encode({
      //   "user_id": userId.toString(),
      //   "it_proj_id": widget.itModelList.toString(),
      //   "amount": widget.itModelAmount.toString(),
      //   "payment_status": paymentStatus,
      //   "payment_id": paymentId,
      //   "payment_breakup": widget.itModelPaymentBreakup.toString(),
      //   "gst_per": widget.gst.toString(),
      //   "gst_rate": newGst.toString(),
      //   "tds_per": widget.tds.toString(),
      //   "tds_rate": newTds.toString(),
      //   "grand_total": (grandTotal / 100).toString(),
      //   "installment_serial": buyBtnShowSuccess == 0
      //       ? "1"
      //       : installmentSerial == "1"
      //           ? "2"
      //           : "0",
      //   "first_installment_per": widget.itModelFirstInstallment,
      //   "last_installment_per": widget.itModelSecondInstallment,
      //   "first_installment_amt": widget.itModelFirstInstallmentAmount,
      //   "last_installment_amt": widget.itModelSecondInstallmentAmount
      // }));
      var _confirm =
          await dio.post(Consts.USER_BUY_IT_PROJECT, data: boughtProject);
      print("Confirm It..." + boughtProject.toString());
      print("Confirm It..." + _confirm.data.toString());
      if (_confirm.data["success"] == 1) {
        var buyResponseData = _confirm.data["respData"];
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
        showCustomToast(_confirm.data["message"].toString());
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
