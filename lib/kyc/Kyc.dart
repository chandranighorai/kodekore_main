import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Consts/AppConsts.dart';
import 'package:kode_core/kyc/KycModel.dart';
import 'package:kode_core/login/Otp.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/signup/SignUpModel.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KYC extends StatefulWidget {
  String userId;
  RespData regData;
  KycData kycData;
  String pageName;
  KYC({this.userId, this.regData, this.kycData, this.pageName, Key key})
      : super(key: key);

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
  bool updateEnable = false;
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
    KycData dd;

    ///print("sda" + widget.kycData.ifsc);
    if (widget.pageName == "EditProfile") {
      bankNameText.text = widget.kycData.bankName;
      branchNameText.text = widget.kycData.branchName;
      acNoText.text = widget.kycData.acNo;
      ifscText.text = widget.kycData.ifsc;
      acNameText.text = widget.kycData.acName;
      panText.text = widget.kycData.panNo;
      adhaarText.text = widget.kycData.aadhaarNo;
      // _image = widget.kycData.kycPanFile;
      // _image1 = widget.kycData.kycAadhaarFile;
    }
    //KycData data;
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
    //GlobalKey<ScaffoldState> scaffFoldState = new GlobalKey<ScaffoldState>();
    //print("pro..." + widget.regData1.bankName);
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
                        decoration:
                            InputDecoration(hintText: "A/C Holder Name"),
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
                          _image != null
                              ? TextButton(
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () {
                                    // _chooseOption(1);
                                  },
                                )
                              : TextButton(
                                  child: Text("Upload"),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                          _image1 != null
                              ? TextButton(
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () {
                                    // _chooseOption(1);
                                  },
                                )
                              : TextButton(
                                  child: Text("Upload"),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                      updateEnable == true
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.03,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.03),
                              color: AppColors.buttonColor.withOpacity(0.2),
                              child: Text("Update".toUpperCase()),
                            )
                          : InkWell(
                              onTap: () {
                                _upDate();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.03,
                                    bottom: MediaQuery.of(context).size.width *
                                        0.03),
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

  _upDate() {
    try {
      //print("pag..." + widget.pageName.toString());
      // print("bank..." + widget.userId.toString());
      // print("bank..." + bankNameText.text.toString());
      // print("bank..." + branchNameText.text.toString());
      // print("bank..." + acNoText.text.toString());
      // print("bank..." + ifscText.text.toString());
      // print("bank..." + acNameText.text.toString());
      // print("bank..." + panText.text.toString());
      // print("bank..." + adhaarText.text.toString());
      // print("bank..." + _image.path.toString());
      // print("bank..." + _image1.path.toString());

      if (bankNameText.text.isEmpty ||
          branchNameText.text.isEmpty ||
          acNoText.text.isEmpty ||
          ifscText.text.isEmpty ||
          acNameText.text.isEmpty ||
          panText.text.isEmpty ||
          adhaarText.text.isEmpty) {
        showCustomToast("Field should not empty");
      } else if (widget.pageName != "EditProfile") {
        if (_image == null || _image1 == null) {
          showCustomToast("Please upload Pan & Adhaar photo");
        } else {
          _kyc();
        }
      }
      // (_image == null || _image1 == null) {
      //   showCustomToast("Please upload Pan & Adhaar photo");
      // }
      else {
        _kyc();
      }
    } on DioError catch (e) {
      setState(() {
        updateEnable = false;
      });
      print(e.toString());
    }
  }

  _kyc() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("pag..." + widget.pageName.toString());

      // var pan =
      //     await MultipartFile.fromFile(_image.path, filename: "pan.jpg");
      // var adhar =
      //     await MultipartFile.fromFile(_image1.path, filename: "adhar.jpg");
      // print("Pan..." + pan.toString());
      // print("Adhar..." + adhar.toString());
      setState(() {
        updateEnable = true;
      });
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
          "aadhaar_no": adhaarText.text.trim(),
          "kyc_type": widget.pageName == "EditProfile" ? "2" : "1"
        }),
        "kyc_pan_file": _image == null
            ? ""
            : await MultipartFile.fromFile(_image.path, filename: "pan.jpg"),
        "kyc_aadhaar_file": _image1 == null
            ? ""
            : await MultipartFile.fromFile(_image1.path, filename: "adhar.jpg")
      });
      //print("FormData..." + pan.toString());
      var response = await dio.post(Consts.update_kyc, data: formData);
      print("Data..." + response.data.toString());
      setState(() {
        prefs.setString(
            "KycStatus", response.data["respData"]["kyc_status"].toString());
      });
      if (response.data["success"] == 1) {
        bankNameText.text = "";
        branchNameText.text = "";
        acNoText.text = "";
        ifscText.text = "";
        acNameText.text = "";
        panText.text = "";
        adhaarText.text = "";
        setState(() {
          _image = null;
          _image1 = null;
        });
        showCustomToast(response.data["message"].toString());
        widget.pageName == "EditProfile"
            ? Navigator.pop(context)
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Otp(
                        regData: widget.regData, pageName: widget.pageName)));
        return KycModel.fromJson(response.data);
      } else {
        setState(() {
          updateEnable = false;
          showCustomToast("Slow Network");
        });
      }
    } on DioError catch (e) {
      setState(() {
        updateEnable = false;
      });
      print(e.toString());
    }
  }
}
