import 'package:flutter/material.dart';
import 'package:kode_core/itproject/ItModel.dart';
import 'package:kode_core/itproject/ViewDetails.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'NewModel.dart';

class ItModelList extends StatefulWidget {
  RespData itModelList;
  ItModelList({this.itModelList, Key key}) : super(key: key);

  @override
  _ItModelListState createState() => _ItModelListState();
}

class _ItModelListState extends State<ItModelList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("modelDesc..." + widget.itModelList.toString());
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewDetails(
                    itModelList: widget.itModelList.itProjId.toString(),
                    itModelTitle: widget.itModelList.title,
                    itModelDescription: widget.itModelList.description,
                    itModelAmount: widget.itModelList.amount)));
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
            right: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.width * 0.00,
            bottom: MediaQuery.of(context).size.width * 0.03),
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.03)),
              boxShadow: [
                BoxShadow(color: AppColors.dashboardFontColor, blurRadius: 6.0)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.itModelList.title}",
                style: TextStyle(
                    color: AppColors.bgColor,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.03,
              ),
              Container(
                child: Html(
                  shrinkWrap: true,
                  data: (widget.itModelList.description.length > 400)
                      ? widget.itModelList.description.substring(0, 300) + "..."
                      : widget.itModelList.description,
                  style: {
                    "body": Style(
                        margin: EdgeInsets.all(0), padding: EdgeInsets.all(0))
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Row(
                children: [
                  Text(
                    "Project Price: ${widget.itModelList.amount} INR",
                    style: TextStyle(
                        color: AppColors.bgColor,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                      color: AppColors.buttonColor,
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: Text(
                        "View Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.035),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
