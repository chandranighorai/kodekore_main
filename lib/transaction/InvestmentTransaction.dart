import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/Util/AppColors.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/investmentplan/InvestmentList.dart';
import 'package:kode_core/investmentplan/InvestmentModel.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/transaction/InvestTransacTable.dart';
import 'package:kode_core/transaction/InvestmentTransactionModel.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentTransaction extends StatefulWidget {
  var title;
  //const InvestmentTransaction({Key key}) : super(key: key);
  InvestmentTransaction(this.title);
  @override
  _InvestmentTransactionState createState() => _InvestmentTransactionState();
}

class _InvestmentTransactionState extends State<InvestmentTransaction> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  Future<InvestmentTransactionModel> _investList;
  var dio = Dio();
  String userId;
  var respData;
  bool _load = false;
  var response;
  // List investProjectlist = [
  //   {"date": "12/05/2021", "plan_name": "IT Project Pay", "amt": 5000},
  //   {"date": "02/05/2021", "plan_name": "IT Project Pay", "amt": 3000},
  //   {"date": "20/05/2021", "plan_name": "IT Project Pay", "amt": 1000},
  //   {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 3500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 4500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 5500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 6500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 4500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 5500},
  //   // {"date": "8/05/2021", "plan_name": "IT Project Pay", "amt": 6500}
  // ];
  @override
  void initState() {
    super.initState();
    _investList = _allInvestmentList();
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
            //           "Transaction Investment",
            //           style: TextStyle(
            //               color: AppColors.bgColor,
            //               fontSize: MediaQuery.of(context).size.width * 0.05,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Spacer(),
            //         Wal()
            //         // InkWell(
            //         //   onTap: () => Navigator.push(context,
            //         //     MaterialPageRoute(builder: (context) => Wallet())),
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
            _load == false
                ? Center(child: CircularProgressIndicator())
                : response.data["success"] == 0
                    ? Center(
                        child: Text(response.data["message"].toString()),
                      )
                    : InvestTransactionTable(
                        contextData: context,
                        modelList: respData,
                        currentSortColumn: _currentSortColumn,
                        isAscending: _isAscending)
          ],
        ),
      ),
    );
  }

  Future<InvestmentTransactionModel> _allInvestmentList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userId = pref.getString("userId");
      print("investmentDtaa..." + userId.toString());

      var investmentData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": userId.toString()})
      });
      response = await dio.post(Consts.INVESTMENT_PLANS_BOUGHT_BY_USER,
          data: investmentData);
      if (response.data["success"] == 0) {
        setState(() {
          _load = true;
        });
      } else {
        setState(() {
          respData = response.data["respData"];
          _load = true;
        });
        print("investmentDtaa..." + respData.toString());
        return InvestmentTransactionModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}

// Widget investTransactionTable(BuildContext context,
//     Future<InvestmentTransactionModel> _investProjectlist) {
//   return Positioned(
//     top: MediaQuery.of(context).size.width * 0.52,
//     bottom: MediaQuery.of(context).size.width * 0.02,
//     child: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: FutureBuilder(
//           initialData: null,
//           future: _investProjectlist,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasData) {
//               int investSuccess = snapshot.data.success;
//               var investProjectlist = snapshot.data.investmentTransaction;
//               return investSuccess == 0
//                   ? Center(child: Text("No Transaction"))
//                   : ListView(
//                       padding: EdgeInsets.only(
//                           bottom: MediaQuery.of(context).size.width * 0.02),
//                       children: [
//                         FittedBox(
//                           child: DataTable(
//                             headingRowColor: MaterialStateColor.resolveWith(
//                                 (states) => AppColors.buttonColor),
//                             // dataRowHeight:
//                             //     MediaQuery.of(context).size.width * 0.14,
//                             columns: <DataColumn>[
//                               DataColumn(
//                                   label: Text(
//                                 "Date",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width *
//                                             0.038),
//                               )),
//                               DataColumn(
//                                   label: Container(
//                                 width: MediaQuery.of(context).size.width * 0.5,
//                                 //alignment: Alignment.center,
//                                 child: Text(
//                                   "Plan Name",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.038),
//                                 ),
//                               )),
//                               DataColumn(
//                                   label: Text(
//                                 "Amt(INR)",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width *
//                                             0.038),
//                               ))
//                             ],
//                             // rows: const <DataRow>[
//                             //   DataRow(cells: <DataCell>[
//                             //     DataCell(Text("12/05/2021")),
//                             //     DataCell(Text("IT Project Pay")),
//                             //     DataCell(Text("5000"))
//                             //   ])
//                             // ])
//                             rows: List<DataRow>.generate(
//                                 investProjectlist.length, (index) {
//                               InvestmentTranModel list =
//                                   investProjectlist[index];
//                               var date = list.dtime.toString().split(" ");
//                               var date1 = date[0];
//                               return DataRow(
//                                   color:
//                                       MaterialStateProperty.resolveWith<Color>(
//                                           (Set<MaterialState> states) {
//                                     //if (index % 2 == 0) return AppColors.bgColor;
//                                     return index % 2 == 0
//                                         ? AppColors.transactionDarkGreen
//                                         : AppColors.transactionLightGreen;
//                                   }),
//                                   cells: [
//                                     DataCell(Container(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.2,
//                                       child: Text(
//                                         //investProjectlist[index]["date"],
//                                         date1,
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     )),
//                                     DataCell(Container(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.5,
//                                       // alignment: Alignment.center,
//                                       child: Text(
//                                         //investProjectlist[index]["plan_name"],
//                                         list.planTitle.toString(),
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     )),
//                                     DataCell(Text(
//                                       // investProjectlist[index]["amt"]
//                                       //         .toString() +
//                                       list.invAmount.toString() + " CR",
//                                       style: TextStyle(color: Colors.white),
//                                     )),
//                                   ]);
//                             }),
//                           ),
//                         ),
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
