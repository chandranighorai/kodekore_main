import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kode_core/Itproject/ItModelList.dart';
import 'package:kode_core/Itproject/NewModel.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/itproject/ItModel.dart';
import 'package:kode_core/itproject/ViewDetails.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';

class ItProjects extends StatefulWidget {
  var title;
  //const ItProjects({Key key}) : super(key: key);
  ItProjects(this.title);

  @override
  _ItProjectsState createState() => _ItProjectsState();
}

class _ItProjectsState extends State<ItProjects> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  var dio = Dio();

  Future<ItModel> projectList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectList = _allItProjectList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.bgColor,
      //   elevation: 0,
      // ),
      key: scaffFoldState,
      drawer: Navigation(),
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
                  onPressed: () => scaffFoldState.currentState.openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
            ),
            Wal(widget.title),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.54,
              bottom: MediaQuery.of(context).size.width * 0.02,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    initialData: null,
                    future: projectList,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var responseData = snapshot.data.respData;
                        
                        return responseData.length == 0
                            ? Center(
                                child:
                                    Container(child: Text("No Projects Yet")))
                            : ListView.builder(
                                itemCount: responseData.length,
                                itemBuilder: (context, int index) {
                                  RespData itModel = responseData[index];
                                  return ItModelList(itModelList: itModel);
                                });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<ItModel> _allItProjectList() async {
    try {
      var formData = FormData.fromMap({
        "oAuth_json": json.encode({
          "sKey": "dfdbayYfd4566541cvxcT34#gt55",
          "aKey": "3EC5C12E6G34L34ED2E36A9"
        }),
        "jsonParam": json.encode({})
      });
      var response = await dio.post(Consts.IT_PROJECT_LIST, data: formData);

      return ItModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
