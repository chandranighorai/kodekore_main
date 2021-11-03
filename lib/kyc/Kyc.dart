import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class KYC extends StatefulWidget {
  String userId;
  KYC({this.userId, Key key}) : super(key: key);

  @override
  _KYCState createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  TextEditingController bankNameText,
      branchNameText,
      acNoText,
      ifscText,
      acNameText,
      panText,
      adhaarText;
  var _image, _image1;
  @override
  void initState() {
    super.initState();
    bankNameText = new TextEditingController();
    branchNameText = new TextEditingController();
    acNoText = new TextEditingController();
    ifscText = new TextEditingController();
    acNameText = new TextEditingController();
    panText = new TextEditingController();
    adhaarText = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getImage(ImgSource source, int index) async {
    print("Image...1" + source.toString());
    //1 = Gallery , 2 = Camera
    var image = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: source,
        barrierDismissible: true,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        cameraText: Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    print("image..." + image.toString());
    if (index == 1) {
      setState(() {
        _image = image;
      });
    } else {
      setState(() {
        _image1 = image;
      });
    }
    print("Image..." + _image.path.toString());
  }

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
              top: MediaQuery.of(context).size.width * 0.4,
              child: Container(
                  //color: Colors.amber,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: Text(
                    "KYC",
                    style: TextStyle(
                        color: AppColors.bgColor,
                        fontSize: MediaQuery.of(context).size.width * 0.075,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.58,
              //bottom: MediaQuery.of(context).size.width * 0.18,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.width * 0.06,

              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02)),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: bankNameText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Bank Name"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: branchNameText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Branch Name"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: acNoText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "A/C No."),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: ifscText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "IFSC"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: acNameText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "A/C Name"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: panText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Pan Number"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      TextFormField(
                        controller: adhaarText,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(hintText: "Adhaar Number"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      Row(
                        children: [
                          Text("Pan Image"),
                          Spacer(),
                          TextButton(
                            child: Text("Upload"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.buttonColor)),
                            onPressed: () {
                              _chooseOption(1);
                            },
                          )
                          // Container(
                          //     padding: EdgeInsets.only(
                          //         top: MediaQuery.of(context).size.width * 0.02,
                          //         bottom:
                          //             MediaQuery.of(context).size.width * 0.02,
                          //         left:
                          //             MediaQuery.of(context).size.width * 0.05,
                          //         right:
                          //             MediaQuery.of(context).size.width * 0.05),
                          //     decoration: BoxDecoration(
                          //         color: AppColors.buttonColor,
                          //         borderRadius: BorderRadius.all(
                          //             Radius.circular(
                          //                 MediaQuery.of(context).size.width *
                          //                     0.02))),
                          //     child: Text("Upload"))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      Row(
                        children: [
                          Text("Adhaar Image"),
                          Spacer(),
                          TextButton(
                            child: Text("Upload"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.buttonColor)),
                            onPressed: () {
                              _chooseOption(2);
                            },
                          )
                          // Container(
                          //     padding: EdgeInsets.only(
                          //         top: MediaQuery.of(context).size.width * 0.02,
                          //         bottom:
                          //             MediaQuery.of(context).size.width * 0.02,
                          //         left:
                          //             MediaQuery.of(context).size.width * 0.05,
                          //         right:
                          //             MediaQuery.of(context).size.width * 0.05),
                          //     decoration: BoxDecoration(
                          //         color: AppColors.buttonColor,
                          //         borderRadius: BorderRadius.all(
                          //             Radius.circular(
                          //                 MediaQuery.of(context).size.width *
                          //                     0.02))),
                          //     child: Text("Upload"))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      InkWell(
                        onTap: () {
                          _upDate();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.03,
                              bottom: MediaQuery.of(context).size.width * 0.03),
                          color: AppColors.buttonColor,
                          child: Text("Update".toUpperCase()),
                        ),
                      )
                      // TextButton(

                      //   onPressed: null,
                      //   child: Text("Update".toUpperCase()),
                      //   style: ButtonStyle(
                      //       backgroundColor: MaterialStateProperty.all(
                      //           AppColors.buttonColor)),
                      // )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _chooseOption(int data) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              //title: Text("Do you really want to exit?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _getImage(ImgSource.Gallery, data);
                    },
                    child: Text("Gallery")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _getImage(ImgSource.Camera, data);
                    },
                    child: Text("Camera"))
              ],
            ));
  }

  _upDate() async {
    var dio = Dio();
    try {
      var pan = await MultipartFile.fromFile(_image.path, filename: "pan.jpg");
      var adhar =
          await MultipartFile.fromFile(_image1.path, filename: "adhar.jpg");
      print("Pan..." + pan.toString());
      print("Adhar..." + adhar.toString());

      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({
          "user_id": widget.userId.toString(),
          "bank_name": bankNameText.text.trim(),
          "branch_name": branchNameText.text.trim(),
          "ac_no": acNoText.text.trim(),
          "ifsc": ifscText.text.trim(),
          "ac_name": acNameText.text.trim(),
          "pan_no": panText.text.trim(),
          "aadhaar_no": adhaarText.text.trim()
        }),
        "kyc_pan_file": pan,
        "kyc_aadhaar_file": adhar
      });
      var response = await dio.post(Consts.update_kyc, data: formData);
      print("Data..." + response.data.toString());
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
