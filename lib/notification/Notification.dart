import 'package:flutter/material.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';

class Notification1 extends StatefulWidget {
  var title;
  //const Notification1({Key key}) : super(key: key);
  Notification1(this.title);
  @override
  _Notification1State createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {
  GlobalKey<ScaffoldState> scaffFold = new GlobalKey<ScaffoldState>();
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
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.04,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, int index) {
                        return NotificationList();
                      }),
                ))
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        right: MediaQuery.of(context).size.width * 0.06,
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Container(
        child: Text("12/07/2021 2000 INR credit to wallet of investment",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
            )),
      ),
    );
  }
}
