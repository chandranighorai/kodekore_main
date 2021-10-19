import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(String message, [Color mColor]) {
  mColor = Color(0x99000000);
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[100],
      textColor: Colors.black,
      fontSize: 16.0);
}

// logoutData(BuildContext context)
// {
//  return showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text("Do you really want to exit?"),
//               actions: <Widget>[
//                 TextButton(
//                     onPressed: () => Navigator.pop(context, false),
//                     child: Text("No")),
//                 TextButton(
//                     onPressed: () => Navigator.pop(context, true),
//                     child: Text("Yes"))
//               ],
//             ));
// }
