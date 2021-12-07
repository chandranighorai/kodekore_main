import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ItPayoutList extends StatefulWidget {
  var contextData, payoutList, currentSortColumn, isAscending;
  ItPayoutList(
      {this.contextData,
      this.payoutList,
      this.currentSortColumn,
      this.isAscending,
      Key key})
      : super(key: key);

  @override
  _ItPayoutListState createState() => _ItPayoutListState();
}

class _ItPayoutListState extends State<ItPayoutList> {
  List dateList = [];
  bool dataLoad;
  bool _isAscending = true;
  var pdfUrl = "";
  String dirLoc = "";
  var path = "no data";
  bool downloading = false;
  var progress = "";
  var _onPressed;
  @override
  void initState() {
    super.initState();
    dataLoad = false;
    _getAllPayoutList(widget.payoutList);
    //_downloadFile();
  }

  @override
  Widget build(BuildContext context) {
    print("....." + widget.payoutList.toString());
    int _currentSortColumn = 0;
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.52,
      bottom: MediaQuery.of(context).size.width * 0.02,
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: widget.payoutList.length == 0
              ? Center(
                  child: Text("No Transaction"),
                )
              : dataLoad == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: [
                        FittedBox(
                          child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => AppColors.buttonColor),
                              sortColumnIndex: _currentSortColumn,
                              sortAscending: _isAscending,
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
                                )),
                                DataColumn(
                                    label: Text(
                                  "Title",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                )),
                                DataColumn(
                                    label: Text(
                                  "Amt(INR)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                )),
                                DataColumn(
                                    label: Text(
                                  "Action",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ))
                              ],
                              rows: dateList.map((item) {
                                int index = int.parse(
                                    dateList.indexOf(item).toString());
                                print("item...index..." + index.toString());
                                print("item..." + item.toString());
                                return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color>((Set<MaterialState> states) {
                                      return index % 2 == 0
                                          ? AppColors.transactionDarkGreen
                                          : AppColors.transactionLightGreen;
                                    }),
                                    cells: [
                                      DataCell(Container(
                                        child: Text(
                                          item["date"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                      DataCell(Container(
                                        child: Text(
                                          item["description"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                      DataCell(Container(
                                        child: Text(
                                          item["amount"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                      DataCell(
                                          Icon(
                                            Icons.download_rounded,
                                            color: Colors.white,
                                          ), onTap: () {
                                        pdfUrl = item["path"];
                                        _pdfDownload(pdfUrl.toString());
                                        print("Pdf..." + pdfUrl.toString());
                                      })
                                    ]);
                              }).toList()),
                        )
                      ],
                    )),
    );
  }

  _getAllPayoutList(var payoutList) {
    for (int i = 0; i < payoutList.length; i++) {
      var date = payoutList[i]["dtime"].toString().split("");
      var dateShow = date[0];
      var pp = {
        "date": dateShow,
        "description": payoutList[i]["proj_title"] == null
            ? "null"
            : payoutList[i]["proj_title"],
        "amount":
            payoutList[i]["amount"] == null ? "null" : payoutList[i]["amount"],
        "path": payoutList[i]["filepath"]
      };
      dateList.add(pp);
      setState(() {
        dataLoad = true;
      });
    }
  }

  _downloadFile() async {
    Dio dio = Dio();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      if (Platform.isAndroid) {
        dirLoc = "/storage/emulated/0/Download/";
      } else {
        dirLoc = (await getApplicationDocumentsDirectory()).path;
      }
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

  _pdfDownload(String url) async {
    if (!await launch(url)) throw "Could not launch url";
  }

  // _pdfDownload() async {
  //   var dio = Dio();
  //   var dd = pdfUrl.split("/");
  //   print("DD..." + dd[dd.length - 1]);
  //   dio.download(pdfUrl, dirLoc + dd[dd.length - 1],
  //       onReceiveProgress: (receivedBytes, totalBytes) {
  //     print("here1...");
  //     setState(() {
  //       downloading = true;
  //       progress =
  //           ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
  //       print("olololo...." + progress);
  //       print("olololo...." + dirLoc + dd[dd.length - 1].toString());
  //     });
  //     if (progress.toString() == "100%") {
  //       print("progress..." + progress.toString());
  //       showCustomToast(
  //           "File Saved in " + dirLoc + dd[dd.length - 1].toString());
  //     }
  //   });
  // }
}
