import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Home.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance1_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((value) {
    var fcmToken = value.toString();
    print("FCM...in kodrcore..." + fcmToken.toString());
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((val) {
    runApp(MyApp());
  });
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kode Core',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Kode Core'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var otpStatus, kycStatus, fcm;
  bool pageLoad;
  var expireDate, todaysDate;
  DateTime dt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageLoad = false;
    todaysDate = DateTime.now();
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print("Message..." + message.notification.toString());
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
      print('A new onMessageOpenedApp event was published! ${message.data}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!' +
          message.data.toString());
    });
    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageLoad == false
          ? Center(
              child: CircularProgressIndicator(
                  //backgroundColor: AppColors.buttonColor,
                  //valueColor: AppColors.buttonColor,
                  ),
            )
          : (otpStatus.toString() == "1" ||
                  otpStatus.toString() == "null" ||
                  otpStatus.toString() == "0")
              ? Login()
              : (((expireDate == null) || (dt.isBefore(todaysDate))))
                  ? Login()
                  : Home(),
    );
  }

  _getDetails() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        otpStatus = pref.getString("otpStatus");
        kycStatus = pref.getString("KycStatus");
        fcm = pref.getString("FCM");

        print("otpStatus...." + otpStatus.toString());
        print("kycStatus...." + kycStatus.toString());
        print("FCM...." + fcm.toString());
        expireDate = pref.getString("ExpireDate");
        print("expire date..." + expireDate.toString());
        if (expireDate != null) {
          dt = DateTime.parse(expireDate.toString());
          print("todays date..." + todaysDate.runtimeType.toString());
          print("todays date..." + dt.runtimeType.toString());
        }
        // if (dt.isBefore(todaysDate)) {
        //   print("yes");
        // } else {
        //   print("no");
        // }
        // print("expireDate..." + expireDate.toString());
        pageLoad = true;
      });
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No network");
    }
  }
}
