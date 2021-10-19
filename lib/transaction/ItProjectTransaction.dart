import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/Itproject/NewModel.dart';
import 'package:kode_core/Util/AppColors.dart';
import 'package:kode_core/home/Navigation.dart';
//import 'package:kode_core/itproject/ItModel.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/transaction/ItTransactionModel.dart';
import 'package:kode_core/transaction/ItTransactionTable.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItProjectTransaction extends StatefulWidget {
  var title;
  //const ItProjectTransaction({Key key}) : super(key: key);
  ItProjectTransaction(this.title);
  @override
  _ItProjectTransactionState createState() => _ItProjectTransactionState();
}

class _ItProjectTransactionState extends State<ItProjectTransaction> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  //ItModel itModel;
  var dio = Dio();
  String userId;
  var respData;
  Future<ItTransactionModel> _modelList;
  bool _load = false;
  // List itProjectlist = [
  //   {"date": "12/05/2021", "description": "IT Project Pay", "amt": 5000},
  //   {"date": "02/05/2021", "description": "IT Project Pay", "amt": 3000},
  //   {"date": "20/05/2021", "description": "IT Project Pay", "amt": 1000},
  //   {"date": "8/05/2021", "description": "IT Project Pay", "amt": 500},
  //   {"date": "8/05/2021", "description": "IT Project Pay", "amt": 3500},
  //   {"date": "8/05/2021", "description": "IT Project Pay", "amt": 4500},
  // ];

  @override
  void initState() {
    super.initState();
    _modelList = _allItList();
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
        // padding:
        //     EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
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
            //           "Transaction IT Projects",
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

            _load == true
                ? ItTransactionTable(
                    contextData: context,
                    modelList: respData,
                    currentSortColumn: _currentSortColumn,
                    isAscending: _isAscending)
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Future<ItTransactionModel> _allItList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userId = pref.getString("userId");
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": userId.toString()})
      });
      var response =
          await dio.post(Consts.IT_PROJECT_BOUGHT_BY_USER, data: formData);
      print("response data..." + response.data.toString());
      respData = response.data["respData"];
      setState(() {
        _load = true;
      });
      return ItTransactionModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}

// Widget transactionTable(
//     BuildContext context,
//     Future<ItTransactionModel> _modelList,
//     int _currentSortColumn,
//     bool _isAscending) {
//   return Positioned(
//     top: MediaQuery.of(context).size.width * 0.52,
//     bottom: MediaQuery.of(context).size.width * 0.02,
//     //left: MediaQuery.of(context).size.width * 0.02,
//     //right: MediaQuery.of(context).size.width * 0.02,
//     child: Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: FutureBuilder(
//         initialData: null,
//         future: _modelList,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             var itProjectlist = snapshot.data.itTransaction;
//             int itProjectSuccess = snapshot.data.success;
//             return itProjectSuccess == 0
//                 ? Center(child: Container(child: Text("No Transaction")))
//                 : ListView(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).size.width * 0.02),
//                     children: [
//                       FittedBox(
//                         child: DataTable(
//                           sortColumnIndex: _currentSortColumn,
//                           sortAscending: _isAscending,
//                           headingRowColor: MaterialStateColor.resolveWith(
//                               (states) => AppColors.buttonColor),
//                           // dataRowHeight:
//                           //     MediaQuery.of(context).size.width * 0.14,
//                           columns: <DataColumn>[
//                             DataColumn(
//                                 label: Text(
//                                   "Date",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.038),
//                                 ),
//                                 onSort: (columnIndex, _) {
//                                   setState(() {});
//                                 }),
//                             DataColumn(
//                                 label: Text(
//                               "Description",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: MediaQuery.of(context).size.width *
//                                       0.038),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Amt(INR)",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: MediaQuery.of(context).size.width *
//                                       0.038),
//                             ))
//                           ],
//                           // rows: const <DataRow>[
//                           //   DataRow(cells: <DataCell>[
//                           //     DataCell(Text("12/05/2021")),
//                           //     DataCell(Text("IT Project Pay")),
//                           //     DataCell(Text("5000"))
//                           //   ])
//                           // ])
//                           rows: List<DataRow>.generate(itProjectlist.length,
//                               (index) {
//                             ItTransaction itData = itProjectlist[index];
//                             var date = itData.dtime.toString().split(" ");
//                             var dateShow = date[0];
//                             return DataRow(
//                                 color: MaterialStateProperty.resolveWith<Color>(
//                                     (Set<MaterialState> states) {
//                                   return index % 2 == 0
//                                       ? AppColors.transactionDarkGreen
//                                       : AppColors.transactionLightGreen;
//                                 }),
//                                 cells: [
//                                   DataCell(Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.2,
//                                     //color: Colors.red,
//                                     child: Text(
//                                       dateShow,
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   )),
//                                   DataCell(Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.5,
//                                     child: Text(
//                                       itData.projectTitle,
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   )),
//                                   DataCell(Text(
//                                     itData.projectAmount + " CR",
//                                     style: TextStyle(color: Colors.white),
//                                   )),
//                                 ]);
//                           }),
//                         ),
//                       ),
//                     ],
//                   );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     ),
//   );
// }
