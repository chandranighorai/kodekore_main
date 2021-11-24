import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  var pdfUrl = "";
  var path = "No data";
  String dirLoc = "";
  var platformPermission = "Unknown";
  var _onPressed;
  // Directory externalDir;
  bool downloading = false;
  var progress = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAscending = widget.isAscending;
    _downloadFile();
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
                                )),
                                DataColumn(
                                    label: Text(
                                  "Action",
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
                                        // padding: EdgeInsets.only(
                                        //     top: MediaQuery.of(context)
                                        //             .size
                                        //             .width *
                                        //         0.02,
                                        //     bottom: MediaQuery.of(context)
                                        //             .size
                                        //             .width *
                                        //         0.02),
                                        child: Text(
                                          items["plan"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                      DataCell(Text(
                                        items["amount"],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(
                                          Icon(
                                            Icons.download_sharp,
                                            color: Colors.white,
                                          ), onTap: () {
                                        print("plan Name...." +
                                            items["plan"].toString());
                                        pdfUrl = items["path"].toString();
                                        _pdfDownload();
                                      }),
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
        "path": modelList[i]["filepath"]
      };
      dateList.add(pp);
    }
    print("dateList..." + dateList.toString());
  }

  _downloadFile() async {
    Dio dio = Dio();

    final status = await Permission.storage.request();
    if (status.isGranted) {
      if (Platform.isAndroid) {
        dirLoc = "/storage/emulated/0/Download/";
        //dirLoc = "/storage/emulated/0/KodeCore/";
        //dirLoc = "/storage/emulated/0/Kodecore";
      } else {
        dirLoc = (await getApplicationDocumentsDirectory()).path;
      }
      // try {
      //   FileUtils.mkdir([dirLoc]);
      //   await dio.download(pdfUrl, dirLoc + "jkjk" + ".pdf",
      //       onReceiveProgress: (receivedBytes, totalBytes) {
      //     print("here1...");
      //     setState(() {
      //       downloading = true;
      //       progress =
      //           ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
      //       print("olololo...." + progress);
      //     });
      //   });
      // } catch (e) {
      //   print(e.toString());
      // }
      setState(() {
        downloading = false;
        progress = "Progress Complete";
        path = dirLoc + "jkjk" + ".pdf";
      });
    } else {
      setState(() {
        progress = "Permission Denied!";
        _onPressed = () {
          _downloadFile();
        };
      });
    }
  }

  _pdfDownload() async {
    var dio = Dio();
    var dd = pdfUrl.split("/");
    print("DD..." + dd[dd.length - 1]);
    dio.download(pdfUrl, dirLoc + dd[dd.length - 1],
        onReceiveProgress: (receivedBytes, totalBytes) {
      print("here1...");
      setState(() {
        downloading = true;
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        print("olololo...." + progress);
        print("olololo...." + dirLoc + dd[dd.length - 1].toString());
      });
      if (progress.toString() == "100%") {
        print("progress..." + progress.toString());
        showCustomToast(
            "File Saved in " + dirLoc + dd[dd.length - 1].toString());
      }
    });
  }
}
