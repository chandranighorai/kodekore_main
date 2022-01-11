import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/transaction/ItTransactionModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_utils/file_utils.dart';

class ItTransactionTable extends StatefulWidget {
  BuildContext contextData;
  //Future<ItTransactionModel> modelList;
  var modelList;
  int currentSortColumn;
  bool isAscending;
  ItTransactionTable(
      {this.contextData,
      this.modelList,
      this.currentSortColumn,
      this.isAscending});

  @override
  _ItTransactionTableState createState() => _ItTransactionTableState();
}

class _ItTransactionTableState extends State<ItTransactionTable> {
  ItTransaction table;
  //print("Table.."+table.toString());
  bool _isAscending = true;
  List dateList = [];
  bool dataLoad;
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
    dataLoad = false;
    _gettingList(widget.modelList);
    _downloadFile();
  }

  @override
  Widget build(BuildContext context) {
    print("modelList..." + widget.modelList.length.toString());
    int _currentSortColumn = 0;

    ItTransaction itData;
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.52,
      bottom: MediaQuery.of(context).size.width * 0.02,
      //left: MediaQuery.of(context).size.width * 0.02,
      //right: MediaQuery.of(context).size.width * 0.02,
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: widget.modelList.length == 0
              ? Center(child: Text("No Transaction"))
              : dataLoad == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: [
                        FittedBox(
                            child: DataTable(
                          sortColumnIndex: _currentSortColumn,
                          sortAscending: _isAscending,
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => AppColors.buttonColor),
                          dataRowHeight:
                              MediaQuery.of(context).size.width * 0.16,
                          columns: <DataColumn>[
                            DataColumn(
                                label: Text(
                                  "Date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
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
                                    print("DataList..." + dateList.toString());
                                  });
                                }),
                            DataColumn(
                                label: Text(
                              "Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            )),
                            DataColumn(
                                label: Text(
                              "Amt(INR)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            )),
                            DataColumn(
                                label: Text(
                              "Invoice",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
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
                            int index =
                                int.parse(dateList.indexOf(items).toString());
                            return DataRow(
                                color: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return index % 2 == 0
                                      ? AppColors.transactionDarkGreen
                                      : AppColors.transactionLightGreen;
                                }),
                                cells: [
                                  DataCell(Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    //color: Colors.red,
                                    child: Text(
                                      items["date"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                  )),
                                  DataCell(Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      items["description"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                  )),
                                  DataCell(Text(
                                    items["amount"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                  )),
                                  DataCell(
                                      Container(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.download_sharp,
                                          color: Colors.white,
                                        ),
                                      ), onTap: () {
                                    print("File path...." +
                                        items["path"].toString());
                                    pdfUrl = items["path"].toString();
                                    _pdfDownload();
                                    //_onPressed;
                                  }),
                                ]);
                          }).toList(),
                        ))
                      ],
                    )
          // FutureBuilder(
          //   initialData: null,
          //   future: widget.modelList,
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData) {
          //       var itProjectlist = snapshot.data.itTransaction;
          //       int itProjectSuccess = snapshot.data.success;
          //       for (int i = 0; i < itProjectlist.length; i++) {
          //         itData = itProjectlist[i];
          //         var date = itData.dtime.toString().split(" ");
          //         var dateShow = date[0];
          //         var pp = {
          //           "date": dateShow,
          //           "description": itData.projectTitle,
          //           "amount": itData.projectAmount
          //         };
          //         dateList.add(pp);
          //         // print("DataList..." + dateList.toString());
          //         // print("DataList..." + dateList.toString());
          //       }
          //       return itProjectSuccess == 0
          //           ? Center(child: Container(child: Text("No Transaction")))
          //           : ListView(
          //               padding: EdgeInsets.only(
          //                   bottom: MediaQuery.of(context).size.width * 0.02),
          //               children: [
          //                 FittedBox(
          //                   child: DataTable(
          //                     sortColumnIndex: _currentSortColumn,
          //                     sortAscending: _isAscending,
          //                     headingRowColor: MaterialStateColor.resolveWith(
          //                         (states) => AppColors.buttonColor),
          //                     // dataRowHeight:
          //                     //     MediaQuery.of(context).size.width * 0.14,
          //                     columns: <DataColumn>[
          //                       DataColumn(
          //                           label: Text(
          //                             "Date",
          //                             style: TextStyle(
          //                                 fontWeight: FontWeight.bold,
          //                                 fontSize:
          //                                     MediaQuery.of(context).size.width *
          //                                         0.038),
          //                           ),
          //                           onSort: (columnIndex, _) {
          //                             setState(() {
          //                               _currentSortColumn = columnIndex;
          //                               if (_isAscending == true) {
          //                                 _isAscending = false;
          //                                 dateList.sort((dateA, dateB) =>
          //                                     dateB["amount"]
          //                                         .compareTo(dateA["amount"]));
          //                               } else {
          //                                 _isAscending = true;
          //                                 dateList.sort((dateA, dateB) =>
          //                                     dateA["amount"]
          //                                         .compareTo(dateB["amount"]));
          //                               }
          //                               print(
          //                                   "DataList..." + dateList.toString());
          //                             });
          //                           }),
          //                       DataColumn(
          //                           label: Text(
          //                         "Description",
          //                         style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize:
          //                                 MediaQuery.of(context).size.width *
          //                                     0.038),
          //                       )),
          //                       DataColumn(
          //                           label: Text(
          //                         "Amt(INR)",
          //                         style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize:
          //                                 MediaQuery.of(context).size.width *
          //                                     0.038),
          //                       ))
          //                     ],
          //                     // rows: const <DataRow>[
          //                     //   DataRow(cells: <DataCell>[
          //                     //     DataCell(Text("12/05/2021")),
          //                     //     DataCell(Text("IT Project Pay")),
          //                     //     DataCell(Text("5000"))
          //                     //   ])
          //                     // ])
          //                     rows: dateList.map((items) {
          //                       print("Iteams..." + items.toString());
          //                       print("Iteams..." +
          //                           dateList.indexOf(items).toString());
          //                       int index =
          //                           int.parse(dateList.indexOf(items).toString());
          //                       return DataRow(
          //                           color:
          //                               MaterialStateProperty.resolveWith<Color>(
          //                                   (Set<MaterialState> states) {
          //                             return index % 2 == 0
          //                                 ? AppColors.transactionDarkGreen
          //                                 : AppColors.transactionLightGreen;
          //                           }),
          //                           cells: [
          //                             DataCell(Container(
          //                               width: MediaQuery.of(context).size.width *
          //                                   0.2,
          //                               //color: Colors.red,
          //                               child: Text(
          //                                 items["date"],
          //                                 style: TextStyle(color: Colors.white),
          //                               ),
          //                             )),
          //                             DataCell(Container(
          //                               width: MediaQuery.of(context).size.width *
          //                                   0.5,
          //                               child: Text(
          //                                 items["description"],
          //                                 style: TextStyle(color: Colors.white),
          //                               ),
          //                             )),
          //                             DataCell(Text(
          //                               items["amount"] + " CR",
          //                               style: TextStyle(color: Colors.white),
          //                             )),
          //                           ]);
          //                     }).toList(),

          //                     // List<DataRow>.generate(itProjectlist.length,
          //                     //     (index) {
          //                     //   itData = itProjectlist[index];
          //                     //   var date = itData.dtime.toString().split(" ");
          //                     //   var dateShow = date[0];
          //                     //   // dateList.add(dateShow);
          //                     //   // print("DataList..." + dateList.toString());
          //                     //   return DataRow(
          //                     //       color:
          //                     //           MaterialStateProperty.resolveWith<Color>(
          //                     //               (Set<MaterialState> states) {
          //                     //         return index % 2 == 0
          //                     //             ? AppColors.transactionDarkGreen
          //                     //             : AppColors.transactionLightGreen;
          //                     //       }),
          //                     //       cells: [
          //                     //         DataCell(Container(
          //                     //           width: MediaQuery.of(context).size.width *
          //                     //               0.2,
          //                     //           //color: Colors.red,
          //                     //           child: Text(
          //                     //             dateShow,
          //                     //             style: TextStyle(color: Colors.white),
          //                     //           ),
          //                     //         )),
          //                     //         DataCell(Container(
          //                     //           width: MediaQuery.of(context).size.width *
          //                     //               0.5,
          //                     //           child: Text(
          //                     //             itData.projectTitle,
          //                     //             style: TextStyle(color: Colors.white),
          //                     //           ),
          //                     //         )),
          //                     //         DataCell(Text(
          //                     //           itData.projectAmount + " CR",
          //                     //           style: TextStyle(color: Colors.white),
          //                     //         )),
          //                     //       ]);
          //                     // }
          //                     // ),
          //                   ),
          //                 ),
          //               ],
          //             );
          //     } else {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
          ),
    );
  }

  _gettingList(var modelList) {
    // print("ModelList..." + modelList.toString());
    // print("ModelList..." + modelList[0]["filepath"].toString());

    for (int i = 0; i < modelList.length; i++) {
      // var date = modelList[i]["dtime"] == null
      //     ? ["null", "null"]
      //     : modelList[i]["dtime"].toString().split(" ");
      var date = modelList[i]["dtime"].toString().split(" ");
      var dateShow = date[0];
      print("DataList..." + dateShow.toString());

      var pp = {
        "date": dateShow,
        "description": modelList[i]["project_title"] == null
            ? "null"
            : modelList[i]["project_title"],
        "amount": modelList[i]["received_amount"] == null
            ? "null"
            : modelList[i]["received_amount"],
        "path": modelList[i]["filepath"]
      };

      dateList.add(pp);
      print("DataList..." + dateList.toString());
    }
    setState(() {
      dataLoad = true;
    });
  }

  _downloadFile() async {
    Dio dio = Dio();

    final status = await Permission.storage.request();
    if (status.isGranted) {
      if (Platform.isAndroid) {
        //dirLoc = "/storage/emulated/0/KodeCore/";
        dirLoc = "/storage/emulated/0/Download/";
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
