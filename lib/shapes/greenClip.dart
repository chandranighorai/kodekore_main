import 'package:flutter/material.dart';

class GreenClipper extends CustomClipper<Path> {
  double width;
  double height;
  GreenClipper(this.width, this.height);
  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    //path.lineTo(0, size.height * 0.04);
    print("size.width..." + size.width.toString());
    path.lineTo(
      0.0,
      height,
    );
    var firstStartpoint =
        Offset(size.width / 8 - size.width / 4, size.height - 98);
    var firstEndpoint =
        Offset(size.width / 4 + size.width / 200 + 8, size.height - 90);
    path.quadraticBezierTo(
      firstStartpoint.dx,
      firstStartpoint.dy,
      firstEndpoint.dx,
      firstEndpoint.dy,
    );
    var secStartpoint =
        Offset(size.width / 1.7 + size.width / 80 - 80, size.height - 88);
    var secEndpoint =
        Offset(size.width / 1.5 + size.width / 100 - 35, size.height - 46);
    path.quadraticBezierTo(
      secStartpoint.dx,
      secStartpoint.dy,
      secEndpoint.dx,
      secEndpoint.dy,
    );
    var tStartpoint =
        Offset(3 * (size.width / 6) + size.width / 3, size.height);
    var tecEndpoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      tStartpoint.dx,
      tStartpoint.dy,
      tecEndpoint.dx,
      tecEndpoint.dy,
    );
    // path.lineTo(width * 0.9, height * 0.80);
    path.lineTo(size.width, 0);
    // path.quadraticBezierTo(size.width / 11, size.height - 60 * 3.5,
    //     size.width / 2, size.height - 30);
// path.quadraticBezierTo(
    //     6.7 / 8 * size.width, size.height * 1.6, size.width, lowPoint * 1);
    // path.lineTo(size.width, 0);

    //path.quadraticBezierTo(width * 1.0, height * 0.90, width * 9, 0);
    // path.quadraticBezierTo(size.width - 0, 0.0, size.width - 10, 0.0);
    //path.lineTo(0.0, 0.0);
    // path.quadraticBezierTo(0.0, 10, 0.0, size.height * 0.20);

    //first control point
    // var firstControlPoint = new Offset(size.width / 2.8, size.width / 40 - 20);
    // var firstEndPoint = new Offset(size.width / 2, size.height / 3 - 40);

    // //second control point
    // var secondControlPoint =
    //     new Offset(size.width - (size.width / 5), size.height / 8);
    // var secondEndPoint = new Offset(size.width / 2, size.height / 4);

    // //first quadraticBezierTo
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstEndPoint.dx, firstEndPoint.dy);

    // //second quadraticBezierTo
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondEndPoint.dx, secondEndPoint.dy);

    // //second line
    // path.lineTo(size.width, size.height / 6);
    // path.lineTo(size.width, 0);
    path.close();
    //*******
    // final lowPoint = size.height - 30;
    // final highPoint = size.height - 60;
    // path.lineTo(0, size.height);
    // path.quadraticBezierTo(
    //     size.width / 12, highPoint * 1, size.width / 2.95, lowPoint);
    // path.quadraticBezierTo(
    //     6.7 / 8 * size.width, size.height * 1.6, size.width, lowPoint * 1);
    // path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
