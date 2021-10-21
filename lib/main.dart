import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/home/Home.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/login.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
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
  var otpStatus;
  bool pageLoad;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageLoad = false;
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
          : otpStatus.toString() == "1" ||
                  otpStatus.toString() == "null" ||
                  otpStatus.toString() == "0"
              ? Login()
              : Home(),
    );
  }

  _getDetails() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        otpStatus = pref.getString("otpStatus");
        print("otpStatus...." + otpStatus.toString());
        pageLoad = true;
      });
    } on DioError catch (e) {
      print(e.toString());
      showCustomToast("No network");
    }
  }
}
