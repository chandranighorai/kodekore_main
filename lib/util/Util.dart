import 'package:flutter/material.dart';

showAlertDialogWithCancel(BuildContext context) {
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


