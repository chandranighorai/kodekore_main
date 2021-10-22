import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/notification/NotificationModel.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';

class Notification1 extends StatefulWidget {
  var title;
  var userId;
  //const Notification1({Key key}) : super(key: key);
  Notification1(this.title, this.userId);
  @override
  _Notification1State createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {
  GlobalKey<ScaffoldState> scaffFold = new GlobalKey<ScaffoldState>();
  Future<NotificationModel> _notificationList;
  var dio = Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationList = _getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffFold,
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
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
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
            //           "Notification",
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
            Positioned(
                top: MediaQuery.of(context).size.width * 0.54,
                bottom: MediaQuery.of(context).size.width * 0.04,
                left: MediaQuery.of(context).size.width * 0.06,
                right: MediaQuery.of(context).size.width * 0.06,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(context).size.width * 0.03)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 9.0)
                      ]),
                  child: FutureBuilder(
                    initialData: null,
                    future: _notificationList,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var notiList = snapshot.data.respData;
                        return notiList.length == 0
                            ? Center(
                                child: Text("No Notification Found"),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.04,
                                ),
                                itemCount: notiList.length,
                                itemBuilder: (context, int index) {
                                  NotificationList notificationList =
                                      notiList[index];
                                  return NotificationListShow(
                                      notification: notificationList);
                                });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<NotificationModel> _getNotificationList() async {
    try {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": widget.userId.toString()})
      });
      var response = await dio.post(Consts.NOTIFICATION, data: formData);
      print("Notification Data..." + response.data.toString());
      return NotificationModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No Network");
    }
  }
}

class NotificationListShow extends StatelessWidget {
  NotificationList notification;
  NotificationListShow({this.notification});
  //NotificationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = notification.dtime.split(" ");
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        right: MediaQuery.of(context).size.width * 0.06,
        //top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date[0].toString(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(notification.notificationTitle,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Text(notification.notificationBody,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
