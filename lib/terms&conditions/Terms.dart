import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';

class Terms extends StatefulWidget {
  var title, content;
  //const Terms({Key key}) : super(key: key);
  Terms(this.title, this.content);
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Positioned(
                top: MediaQuery.of(context).size.width * 0.55,
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
                bottom: MediaQuery.of(context).size.width * 0.06,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(context).size.width * 0.02)),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 9.0)
                      ]),
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    children: [
                      Html(
                        data: widget.content,
                        style: {
                          "body": Style(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.all(0),
                          )
                        },
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
