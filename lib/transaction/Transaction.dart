import 'package:flutter/material.dart';
import 'package:kode_core/home/Navigation.dart';
import 'package:kode_core/shapes/ShapeComponent.dart';
import 'package:kode_core/transaction/CryptocurrenyTransaction.dart';
import 'package:kode_core/transaction/InvestmentTransaction.dart';
import 'package:kode_core/transaction/ItProjectTransaction.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/util/Const.dart';
import 'package:kode_core/wallet/wal.dart';
import 'package:kode_core/wallet/wallet.dart';

class Transaction extends StatefulWidget {
  var title;
  //const Transaction({Key key}) : super(key: key);
  Transaction(this.title);
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  GlobalKey<ScaffoldState> scaffFoldState = GlobalKey<ScaffoldState>();
  var transactionList = ["IT Projects", "Investment Plans", "Cryptocurrency"];
  //var transactionList = ["Investment Plans", "Cryptocurrency"];

  @override
  Widget build(BuildContext context) {
    print("..." + transactionList.length.toString());
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: AppColors.bgColor,
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
            // Positioned(
            //   top: MediaQuery.of(context).size.width * 0.39,
            //   left: MediaQuery.of(context).size.width * 0.02,
            //   right: MediaQuery.of(context).size.width * 0.02,
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         left: MediaQuery.of(context).size.width * 0.06,
            //         right: MediaQuery.of(context).size.width * 0.06),
            //     child: Row(
            //       children: [
            //         Text(
            //           "Transaction",
            //           style: TextStyle(
            //               color: AppColors.bgColor,
            //               fontSize: MediaQuery.of(context).size.width * 0.05,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Spacer(),
            //         Wal()
            //         // InkWell(
            //         //   onTap: () => Navigator.push(context,
            //         //     MaterialPageRoute(builder: (context) => Wallet())),
            //         //   child: Container(
            //         //     height: MediaQuery.of(context).size.width * 0.10,
            //         //     width: MediaQuery.of(context).size.width * 0.10,
            //         //     decoration: BoxDecoration(
            //         //         //color: Colors.red,
            //         //         image: DecorationImage(
            //         //             image: AssetImage("asset/wallet.png"),
            //         //             fit: BoxFit.contain)),
            //         //   ),
            //         // )
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.width * 0.04,
            // ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.54,
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: transactionList.length,
                      itemBuilder: (context, int index) {
                        return TransactionList(transactionList[index]);
                      })),
            )
          ],
        ),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  //const TransactionList({Key key}) : super(key: key);
  var transactionName;
  TransactionList(this.transactionName);
  @override
  Widget build(BuildContext context) {
    //print("fdfd..." + transactionName.toString());
    return InkWell(
      onTap: () {
        transactionSection(context, transactionName.toString());
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
            right: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.width * 0.03,
            bottom: MediaQuery.of(context).size.width * 0.03),
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          alignment: Alignment.center,
          color: AppColors.buttonColor,
          child: Text(
            transactionName.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
        ),
      ),
    );
  }

  transactionSection(BuildContext context, String transactionName) {
    if (transactionName == "IT Projects") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItProjectTransaction("Transaction IT Projects")));
    } else if (transactionName == "Investment Plans") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  InvestmentTransaction("Transaction Investment")));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CryptocurrencyTransaction("Transaction Cryptocurrency")));
    }
  }
}
