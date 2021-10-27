import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/cryptocurrency/CryptoCurrency.dart';
import 'package:kode_core/investmentplan/InvestmentList.dart';
import 'package:kode_core/itproject/Itprojectlist.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
//import 'package:kode_core/Shapes/greenClip.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/util/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Navigation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  var dio = Dio();
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _notification();
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    //   if (message != null) {
    //     Map data = message.data;
    //     print(data['notification_type']);
    //   }
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   print("Message..." + message.toString());
    //   print("Message..." + notification.toString());
    //   print("Message..." + android.toString());

    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             "CHANNEL_ID",
    //             "CHANNEL_NAME",
    //             "CHANNEL_DESC",
    //             //icon: android?.smallIcon,
    //             // other properties...
    //           ),
    //         ));
    //   }
    //   print('A new onMessageOpenedApp event was published! ${message.data}');
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    // });
    _userDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffFoldState,
        drawer: Navigation(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("asset/bg4.jpg"),
            fit: BoxFit.cover,
          )),
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
              Positioned(
                top: MediaQuery.of(context).size.width * 0.35,
                child: Container(
                    //color: Colors.amber,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.06,
                        right: MediaQuery.of(context).size.width * 0.02),
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                          color: AppColors.bgColor,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.6,
                //bottom: MediaQuery.of(context).size.width * 0.08,
                left: MediaQuery.of(context).size.width * 0.00,
                right: MediaQuery.of(context).size.width * 0.00,
                child: Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ItProjects("IT Project Investment")));
                        },
                        child: Container(
                          //height: 185,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.06,
                              bottom: MediaQuery.of(context).size.width * 0.06,
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 9.0)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                    //shape: BoxShape.circle,
                                    //color: Colors.red,
                                    image: DecorationImage(
                                        image: AssetImage("asset/icon1.png"))
                                    //borderRadius: BorderRadius.all(Radius.circular(100))
                                    ),
                              ),
                              Text(
                                "IT Project Investment",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dashboardFontColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.06,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InvestmentList("Investment Plan")));
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.06),
                                //right: MediaQuery.of(context).size.width * 0.06),
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.06,
                                    bottom: MediaQuery.of(context).size.width *
                                        0.06,
                                    left: MediaQuery.of(context).size.width *
                                        0.06,
                                    right: MediaQuery.of(context).size.width *
                                        0.06),
                                width: MediaQuery.of(context).size.width / 2.5,
                                //height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 5.0)
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      decoration: BoxDecoration(
                                          //color: Colors.amber,
                                          //shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "asset/icon3.png"))),
                                      //child: Text("sd"),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                    Container(
                                        //alignment: Alignment.center,
                                        child: Text(
                                      "Investment Plans",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dashboardFontColor),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CryptoCurrency("Crypto Currency")));
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    //left: MediaQuery.of(context).size.width * 0.06),
                                    right: MediaQuery.of(context).size.width *
                                        0.06),
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.06,
                                    bottom: MediaQuery.of(context).size.width *
                                        0.06,
                                    left: MediaQuery.of(context).size.width *
                                        0.06,
                                    right: MediaQuery.of(context).size.width *
                                        0.06),
                                width: MediaQuery.of(context).size.width / 2.4,
                                //height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 9.0)
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          // shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "asset/icon2.png"))),
                                      //child: Text("sd"),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                    Container(
                                        //alignment: Alignment.center,
                                        child: Text(
                                      "Crypto Currency",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dashboardFontColor),
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        // appBar: AppBar(
        //   backgroundColor: AppColors.bgColor,
        //   //backgroundColor: Colors.red,
        //   elevation: 0,
        // ),
        //drawer: Navigation(),
        // body: Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage("asset/bg1.jpg"), fit: BoxFit.fill)),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       ShapeComponent(context, Consts.shapeHeight),
        //       // ClipPath(
        //       //   clipper: GreenClipper(MediaQuery.of(context).size.width,
        //       //       MediaQuery.of(context).size.width * 0.38),
        //       //   child: Container(
        //       //     height: MediaQuery.of(context).size.width * 0.1,
        //       //     color: AppColors.bgColor,
        //       //   ),
        //       // )
        //       Container(
        //           //color: Colors.amber,
        //           padding: EdgeInsets.only(
        //               left: MediaQuery.of(context).size.width * 0.06,
        //               right: MediaQuery.of(context).size.width * 0.02),
        //           child: Text(
        //             "Dashboard",
        //             style: TextStyle(
        //                 color: AppColors.bgColor,
        //                 fontSize: MediaQuery.of(context).size.width * 0.07,
        //                 fontWeight: FontWeight.bold),
        //           )),
        //       SizedBox(
        //         height: MediaQuery.of(context).size.width * 0.10,
        //       ),
        //       InkWell(
        //         onTap: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => ItProjects()));
        //         },
        //         child: Container(
        //           //height: 185,
        //           margin: EdgeInsets.only(
        //               left: MediaQuery.of(context).size.width * 0.06,
        //               right: MediaQuery.of(context).size.width * 0.06),
        //           padding: EdgeInsets.only(
        //               top: MediaQuery.of(context).size.width * 0.06,
        //               bottom: MediaQuery.of(context).size.width * 0.06,
        //               left: MediaQuery.of(context).size.width * 0.06,
        //               right: MediaQuery.of(context).size.width * 0.06),
        //           width: MediaQuery.of(context).size.width,
        //           decoration: BoxDecoration(
        //               color: Colors.white,
        //               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 9.0)],
        //               borderRadius: BorderRadius.all(Radius.circular(8))),
        //           child: Row(
        //             children: [
        //               Container(
        //                 width: MediaQuery.of(context).size.width / 3.5,
        //                 height: MediaQuery.of(context).size.height * 0.1,
        //                 decoration: BoxDecoration(
        //                     //shape: BoxShape.circle,
        //                     //color: Colors.red,
        //                     image: DecorationImage(
        //                         image: AssetImage("asset/icon1.png"))
        //                     //borderRadius: BorderRadius.all(Radius.circular(100))
        //                     ),
        //               ),
        //               Text(
        //                 "IT Project Investment",
        //                 style: TextStyle(
        //                     fontSize: MediaQuery.of(context).size.width * 0.045,
        //                     fontWeight: FontWeight.bold,
        //                     color: AppColors.dashboard_font_color),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: MediaQuery.of(context).size.width * 0.06,
        //       ),
        //       Container(
        //         width: MediaQuery.of(context).size.width,
        //         child: Row(
        //           children: [
        //             InkWell(
        //               onTap: () {
        //                 // Navigator.push(
        //                 //     context,
        //                 //     MaterialPageRoute(
        //                 //         builder: (context) => InvestmentList()));
        //               },
        //               child: Container(
        //                 margin: EdgeInsets.only(
        //                     left: MediaQuery.of(context).size.width * 0.06),
        //                 //right: MediaQuery.of(context).size.width * 0.06),
        //                 padding: EdgeInsets.only(
        //                     top: MediaQuery.of(context).size.width * 0.06,
        //                     bottom: MediaQuery.of(context).size.width * 0.06,
        //                     left: MediaQuery.of(context).size.width * 0.06,
        //                     right: MediaQuery.of(context).size.width * 0.06),
        //                 width: MediaQuery.of(context).size.width / 2.5,
        //                 //height: MediaQuery.of(context).size.height * 0.2,
        //                 decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     boxShadow: [
        //                       BoxShadow(color: Colors.grey, blurRadius: 5.0)
        //                     ],
        //                     borderRadius: BorderRadius.all(Radius.circular(8))),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       width: MediaQuery.of(context).size.width / 3.5,
        //                       height: MediaQuery.of(context).size.height * 0.1,
        //                       decoration: BoxDecoration(
        //                           //color: Colors.amber,
        //                           //shape: BoxShape.circle,
        //                           image: DecorationImage(
        //                               image: AssetImage("asset/icon3.png"))),
        //                       //child: Text("sd"),
        //                     ),
        //                     SizedBox(
        //                       height: MediaQuery.of(context).size.width * 0.02,
        //                     ),
        //                     Container(
        //                         //alignment: Alignment.center,
        //                         child: Text(
        //                       "Investment Plans",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontSize:
        //                               MediaQuery.of(context).size.width * 0.045,
        //                           fontWeight: FontWeight.bold,
        //                           color: AppColors.dashboard_font_color),
        //                     ))
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             Spacer(),
        //             InkWell(
        //               onTap: () {
        //                 // Navigator.push(
        //                 //     context,
        //                 //     MaterialPageRoute(
        //                 //         builder: (context) => CryptoCurrency()));
        //               },
        //               child: Container(
        //                 margin: EdgeInsets.only(
        //                     //left: MediaQuery.of(context).size.width * 0.06),
        //                     right: MediaQuery.of(context).size.width * 0.06),
        //                 padding: EdgeInsets.only(
        //                     top: MediaQuery.of(context).size.width * 0.06,
        //                     bottom: MediaQuery.of(context).size.width * 0.06,
        //                     left: MediaQuery.of(context).size.width * 0.06,
        //                     right: MediaQuery.of(context).size.width * 0.06),
        //                 width: MediaQuery.of(context).size.width / 2.4,
        //                 //height: MediaQuery.of(context).size.height * 0.06,
        //                 decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     boxShadow: [
        //                       BoxShadow(color: Colors.grey, blurRadius: 9.0)
        //                     ],
        //                     borderRadius: BorderRadius.all(Radius.circular(8))),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       width: MediaQuery.of(context).size.width / 3.5,
        //                       height: MediaQuery.of(context).size.height * 0.1,
        //                       decoration: BoxDecoration(
        //                           // color: Colors.amber,
        //                           // shape: BoxShape.circle,
        //                           image: DecorationImage(
        //                               image: AssetImage("asset/icon2.png"))),
        //                       //child: Text("sd"),
        //                     ),
        //                     SizedBox(
        //                       height: MediaQuery.of(context).size.width * 0.02,
        //                     ),
        //                     Container(
        //                         //alignment: Alignment.center,
        //                         child: Text(
        //                       "Crypto Currency",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontSize:
        //                               MediaQuery.of(context).size.width * 0.045,
        //                           fontWeight: FontWeight.bold,
        //                           color: AppColors.dashboard_font_color),
        //                     ))
        //                   ],
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you really want to exit?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No")),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes"))
              ],
            ));
  }

  // _notification() async {
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'high_importance1_channel', // id
  //     'High Importance Notifications', // title
  //     'This channel is used for important notifications.', // description
  //     importance: Importance.max,
  //   );
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  // }

  _userDetails() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userId = pref.get("userId");
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({"user_id": userId})
      });
      var response = await dio.post(Consts.USER_LIST, data: formData);
      print("response in home..." + response.data.toString());
      print("response in home..." + response.data["respData"]["fcm_token"].toString());

      setState(() {
        pref.setString(
            "FCM", response.data["respData"]["fcm_token"].toString());
      });
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
