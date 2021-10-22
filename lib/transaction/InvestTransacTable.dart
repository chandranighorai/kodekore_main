import 'package:flutter/material.dart';

import '../util/AppColors.dart';
import 'InvestmentTransactionModel.dart';

class InvestTransactionTable extends StatefulWidget {
  BuildContext contextData;
  var modelList;
  int currentSortColumn;
  bool isAscending;
  InvestTransactionTable(
      {this.contextData,
      this.currentSortColumn,
      this.modelList,
      this.isAscending});
  @override
  _InvestTransactionTableState createState() => _InvestTransactionTableState();
}

class _InvestTransactionTableState extends State<InvestTransactionTable> {
  bool _isAscending;
  List dateList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAscending = widget.isAscending;
    _gettingList(widget.modelList);
  }

  @override
  Widget build(BuildContext context) {
    int _currentSortColumn = 0;
    print("planList..." + widget.modelList.toString());
    return Positioned(
        top: MediaQuery.of(context).size.width * 0.52,
        bottom: MediaQuery.of(context).size.width * 0.02,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                // FutureBuilder(
                //   initialData: null,
                //   future: _investProjectlist,
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     //if (snapshot.hasData) {
                //       int investSuccess = snapshot.data.success;
                //       var investProjectlist = snapshot.data.investmentTransaction;
                widget.modelList.length == 0
                    ? Center(child: Text("No Transaction"))
                    : ListView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.02),
                        children: [
                          FittedBox(
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => AppColors.buttonColor),
                              sortColumnIndex: _currentSortColumn,
                              sortAscending: _isAscending,
                              // dataRowHeight:
                              //     MediaQuery.of(context).size.width * 0.14,
                              columns: <DataColumn>[
                                DataColumn(
                                    label: Text(
                                      "Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.038),
                                    ),
                                    onSort: (columnIndex, _) {
                                      setState(() {
                                        _currentSortColumn = columnIndex;
                                        if (_isAscending == true) {
                                          _isAscending = false;
                                          dateList.sort((dateA, dateB) =>
                                              dateB["date"]
                                                  .compareTo(dateA["date"]));
                                        } else {
                                          _isAscending = true;
                                          dateList.sort((dateA, dateB) =>
                                              dateA["date"]
                                                  .compareTo(dateB["date"]));
                                        }
                                        print("DataList..." +
                                            dateList.toString());
                                      });
                                    }),
                                DataColumn(
                                    label: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  //alignment: Alignment.center,
                                  child: Text(
                                    "Plan Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.038),
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  "Amt(INR)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038),
                                ))
                              ],
                              // rows: const <DataRow>[
                              //   DataRow(cells: <DataCell>[
                              //     DataCell(Text("12/05/2021")),
                              //     DataCell(Text("IT Project Pay")),
                              //     DataCell(Text("5000"))
                              //   ])
                              // ])
                              rows: dateList.map((items) {
                                print("Iteams..." + items.toString());
                                print("Iteams..." +
                                    dateList.indexOf(items).toString());
                                int index = int.parse(
                                    dateList.indexOf(items).toString());
                                return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color>((Set<MaterialState> states) {
                                      return index % 2 == 0
                                          ? AppColors.transactionDarkGreen
                                          : AppColors.transactionLightGreen;
                                    }),
                                    cells: [
                                      DataCell(Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        //color: Colors.red,
                                        child: Text(
                                          items["date"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                      DataCell(Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          items["plan"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                      DataCell(Text(
                                        items["amount"] + " CR",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ]);
                              }).toList(),
                              // List<DataRow>.generate(
                              //     investProjectlist.length, (index) {
                              //   InvestmentTranModel list =
                              //       investProjectlist[index];
                              //   var date = list.dtime.toString().split(" ");
                              //   var date1 = date[0];
                              //   return DataRow(
                              //       color: MaterialStateProperty.resolveWith<
                              //           Color>((Set<MaterialState> states) {
                              //         //if (index % 2 == 0) return AppColors.bgColor;
                              //         return index % 2 == 0
                              //             ? AppColors.transactionDarkGreen
                              //             : AppColors.transactionLightGreen;
                              //       }),
                              //       cells: [
                              //         DataCell(Container(
                              //           width:
                              //               MediaQuery.of(context).size.width *
                              //                   0.2,
                              //           child: Text(
                              //             //investProjectlist[index]["date"],
                              //             date1,
                              //             style: TextStyle(color: Colors.white),
                              //           ),
                              //         )),
                              //         DataCell(Container(
                              //           width:
                              //               MediaQuery.of(context).size.width *
                              //                   0.5,
                              //           // alignment: Alignment.center,
                              //           child: Text(
                              //             //investProjectlist[index]["plan_name"],
                              //             list.planTitle.toString(),
                              //             style: TextStyle(color: Colors.white),
                              //           ),
                              //         )),
                              //         DataCell(Text(
                              //           // investProjectlist[index]["amt"]
                              //           //         .toString() +
                              //           list.invAmount.toString() + " CR",
                              //           style: TextStyle(color: Colors.white),
                              //         )),
                              //       ]);
                              // }),
                            ),
                          ),
                        ],
                      )
            // }
            // else {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            //},
            ));
    //),
    //);
  }

  _gettingList(var modelList) {
    for (int i = 0; i < modelList.length; i++) {
      var date = modelList[i]["dtime"].toString().split(" ");
      var dateShow = date[0];
      var pp = {
        "date": dateShow,
        "plan": modelList[i]["plan_title"] == null
            ? "null"
            : modelList[i]["plan_title"],
        "amount": modelList[i]["inv_amount"] == null
            ? "null"
            : modelList[i]["inv_amount"],
      };
      dateList.add(pp);
    }
    print("dateList..." + dateList.toString());
  }
}
