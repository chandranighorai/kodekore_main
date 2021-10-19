import 'package:flutter/material.dart';
import 'package:kode_core/investmentplan/InvestmentModel.dart';
import 'package:kode_core/investmentplan/InvestmentViewDetails.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:flutter_html/flutter_html.dart';

class InvestmentPlanList extends StatefulWidget {
  RespData invesmentList;
  String userId;
  InvestmentPlanList({this.invesmentList, this.userId, Key key})
      : super(key: key);

  @override
  _InvestmentPlanListState createState() => _InvestmentPlanListState();
}

class _InvestmentPlanListState extends State<InvestmentPlanList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvestmentViewDetails(
                    invPlanId: widget.invesmentList.invPlanId,
                    invPlanTitle: widget.invesmentList.title,
                    invPlanDesc: widget.invesmentList.description,
                    invPlanAmount: widget.invesmentList.returnRate,
                    userId: widget.userId)));
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
              boxShadow: [
                BoxShadow(color: AppColors.dashboardFontColor, blurRadius: 6.0)
              ],
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.03))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.invesmentList.title}",
                style: TextStyle(
                    color: AppColors.bgColor,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.03,
              ),
              //Text("${widget.invesmentList.description}"),
              Html(
                data: (widget.invesmentList.description.length > 400)
                    ? widget.invesmentList.description.substring(0, 300) + "..."
                    : widget.invesmentList.description,
                style: {
                  "body": Style(
                      margin: EdgeInsets.all(0), padding: EdgeInsets.all(0))
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Row(
                children: [
                  Text(
                    "Return Rate: ${widget.invesmentList.returnRate} %",
                    style: TextStyle(
                        color: AppColors.bgColor,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    color: AppColors.buttonColor,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
