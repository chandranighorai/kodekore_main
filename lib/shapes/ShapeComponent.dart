import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Shapes/greenClip.dart';
import 'package:kode_core/Util/AppColors.dart';

Widget ShapeComponent(BuildContext context, double shapeHeight) {
  return ClipPath(
    clipper: GreenClipper(MediaQuery.of(context).size.width, shapeHeight),
    child: Container(
      alignment: Alignment.centerRight,
      height: shapeHeight * 0.85,
      decoration: BoxDecoration(color: AppColors.bgColor),
      child: Stack(
        children: [
          Positioned(
              top: MediaQuery.of(context).size.height * 0.04,
              right: MediaQuery.of(context).size.width * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.055,
              child: Container(
                //height: 285,
                width: MediaQuery.of(context).size.width / 2.3,
                //color: Colors.amber,
                decoration: BoxDecoration(
                    //color: Colors.red,
                    image: DecorationImage(
                        image: AssetImage("asset/logo.png"),
                        fit: BoxFit.contain)),
              ))
        ],
      ),
    ),
  );
}
