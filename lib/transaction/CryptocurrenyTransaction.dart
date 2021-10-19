import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/transaction/CryptoTransactionModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';
import 'package:kode_core/transaction/CryptoTable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptocurrencyTransaction extends StatefulWidget {
  var title;
  //const CryptocurrencyTransaction({Key key}) : super(key: key);
  CryptocurrencyTransaction(this.title);
  @override
  _CryptocurrencyTransactionState createState() =>
      _CryptocurrencyTransactionState();
}

class _CryptocurrencyTransactionState extends State<CryptocurrencyTransaction> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  // List cryptoCurrencylist = [
  //   {"date": "12/05/2021", "qty": "Bitcoin1 0.25", "type": "Buy", "amt": 5000},
  //   {"date": "02/05/2021", "qty": "Bitcoin1 0.22", "type": "Sell", "amt": 3000},
  //   {"date": "20/05/2021", "qty": "Bitcoin2 0.25", "type": "Buy", "amt": 1000},
  //   {"date": "8/05/2021", "qty": "Bitcoin2 0.22", "type": "Sell", "amt": 500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 3500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 4500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 5500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 6500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 4500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 5500},
  //   // {"date": "8/05/2021", "qty": "Bitcoin2 0.22","type":"Buy", "amt": 6500}
  // ];
  Future<CryptoTransactionModel> _cryptoCurrencyList;
  var dio = Dio();
  String userId;
  var respData;
  bool _load = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cryptoCurrencyList = _allCryptoCurrencyList();
  }

  @override
  Widget build(BuildContext context) {
    int _currentSortColumn = 0;
    bool _isAscending = true;
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
            //           "Transaction Cryptocurrency",
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
            // SizedBox(
            //   height: MediaQuery.of(context).size.width * 0.03,
            // ),
            //cryptoCurrencyTransactionList(context, cryptoCurrencylist),
            _load == false
                ? Center(child: CircularProgressIndicator())
                : CryptoTable(
                    contextData: context,
                    modelList: respData,
                    currentSortColumn: _currentSortColumn,
                    isAscending: _isAscending),
          ],
        ),
      ),
    );
  }

  Future<CryptoTransactionModel> _allCryptoCurrencyList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userId = pref.getString("userId");
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": userId, "crypto_id": "bitcoin"})
      });
      var response =
          await dio.post(Consts.CRYPTOCURRENCY_TRANSACTION, data: formData);
      print("response body..." + response.data.toString());
      respData = response.data["respData"];
      setState(() {
        _load = true;
      });
      return CryptoTransactionModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}

// Widget cryptoCurrencyTransactionList(
//     BuildContext context, Future<CryptoTransactionModel> cryptoCurrencylist) {
//   // BuildContext context,
//   // List cryptoCurrencylist) {
//   return Positioned(
//     top: MediaQuery.of(context).size.width * 0.52,
//     bottom: MediaQuery.of(context).size.width * 0.02,
//     child: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child:
//             //ListView(
//             //   padding:
//             //       EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
//             //   children: [
//             //     FittedBox(
//             //       child: DataTable(
//             //           headingRowColor: MaterialStateColor.resolveWith(
//             //               (states) => AppColors.buttonColor),
//             //           columns: <DataColumn>[
//             //             DataColumn(
//             //                 label: Text(
//             //               "Date",
//             //               style: TextStyle(
//             //                   fontWeight: FontWeight.bold,
//             //                   fontSize: MediaQuery.of(context).size.width * 0.04),
//             //             )),
//             //             DataColumn(
//             //                 label: Text(
//             //               "Qty",
//             //               style: TextStyle(
//             //                   fontWeight: FontWeight.bold,
//             //                   fontSize: MediaQuery.of(context).size.width * 0.04),
//             //             )),
//             //             DataColumn(
//             //                 label: Text(
//             //               "Type",
//             //               style: TextStyle(
//             //                   fontWeight: FontWeight.bold,
//             //                   fontSize: MediaQuery.of(context).size.width * 0.04),
//             //             )),
//             //             DataColumn(
//             //                 label: Text(
//             //               "Amt(INR)",
//             //               style: TextStyle(
//             //                   fontWeight: FontWeight.bold,
//             //                   fontSize: MediaQuery.of(context).size.width * 0.04),
//             //             ))
//             //           ],
//             //           rows:
//             //               //List<DataRow>.generate(cryptoCurrencylist.length, (index) {
//             //             cryptoList.length, (index) {
//             //               RespData _cryptoTransactionList = cryptoList[index];
//             //             return DataRow(
//             //                 color: MaterialStateProperty.resolveWith<Color>(
//             //                     (Set<MaterialState> states) {
//             //                   //if (index % 2 == 0) return AppColors.bgColor;
//             //                   return index % 2 == 0
//             //                       ? AppColors.transactionDarkGreen
//             //                       : AppColors.transactionLightGreen;
//             //                 }),
//             //                 cells: [
//             //                   DataCell(Text(
//             //                     cryptoCurrencylist[index]["date"],
//             //                     style: TextStyle(
//             //                         color: Colors.white,
//             //                         fontSize:
//             //                             MediaQuery.of(context).size.width * 0.04),
//             //                   )),
//             //                   DataCell(Text(
//             //                     cryptoCurrencylist[index]["qty"],
//             //                     style: TextStyle(
//             //                         color: Colors.white,
//             //                         fontSize:
//             //                             MediaQuery.of(context).size.width * 0.04),
//             //                   )),
//             //                   DataCell(Text(
//             //                     cryptoCurrencylist[index]["type"],
//             //                     style: TextStyle(
//             //                         color: Colors.white,
//             //                         fontSize:
//             //                             MediaQuery.of(context).size.width * 0.04),
//             //                   )),
//             //                   DataCell(Text(
//             //                     cryptoCurrencylist[index]["amt"].toString() + " CR",
//             //                     style: TextStyle(
//             //                         color: Colors.white,
//             //                         fontSize:
//             //                             MediaQuery.of(context).size.width * 0.04),
//             //                   )),
//             //                 ]);
//             //           })),
//             //     )
//             //   ],
//             // ),
//             FutureBuilder(
//           initialData: null,
//           future: cryptoCurrencylist,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             print("snapshot..." + snapshot.hasData.toString());
//             if (snapshot.hasData) {
//               var cryptoList = snapshot.data.respData;
//               return cryptoList.length == 0
//                   ? Center(child: Text("No Transaction"))
//                   : ListView(
//                       padding: EdgeInsets.only(
//                           bottom: MediaQuery.of(context).size.width * 0.02),
//                       children: [
//                         FittedBox(
//                           child: DataTable(
//                               headingRowColor: MaterialStateColor.resolveWith(
//                                   (states) => AppColors.buttonColor),
//                               columns: <DataColumn>[
//                                 DataColumn(
//                                     label: Text(
//                                   "Date",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.04),
//                                 )),
//                                 DataColumn(
//                                     label: Text(
//                                   "Qty",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.04),
//                                 )),
//                                 DataColumn(
//                                     label: Text(
//                                   "Type",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.04),
//                                 )),
//                                 DataColumn(
//                                     label: Text(
//                                   "Amt(INR)",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.04),
//                                 ))
//                               ],
//                               rows: List<DataRow>.generate(cryptoList.length,
//                                   (index) {
//                                 RespData _cryptoTransactionList =
//                                     cryptoList[index];
//                                 var dateTime = _cryptoTransactionList.dtime
//                                     .toString()
//                                     .split(" ");
//                                 return DataRow(
//                                     color: MaterialStateProperty.resolveWith<
//                                         Color>((Set<MaterialState> states) {
//                                       //if (index % 2 == 0) return AppColors.bgColor;
//                                       return index % 2 == 0
//                                           ? AppColors.transactionDarkGreen
//                                           : AppColors.transactionLightGreen;
//                                     }),
//                                     cells: [
//                                       DataCell(Text(
//                                         dateTime[0].toString(),
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.04),
//                                       )),
//                                       DataCell(Text(
//                                         _cryptoTransactionList.cryptoId +
//                                             " " +
//                                             _cryptoTransactionList.quantity,
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.04),
//                                       )),
//                                       DataCell(Text(
//                                         _cryptoTransactionList.transType,
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.04),
//                                       )),
//                                       DataCell(Text(
//                                         _cryptoTransactionList.receivedAmount +
//                                             " CR",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.04),
//                                       )),
//                                     ]);
//                               })),
//                         )
//                       ],
//                     );
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         )),
//   );
// }
