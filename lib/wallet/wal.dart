import 'package:flutter/material.dart';
import 'package:kode_core/util/AppColors.dart';
import 'package:kode_core/wallet/wallet.dart';

class Wal extends StatelessWidget {
  var title;
  //const Wal({Key key}) : super(key: key);
  Wal(this.title);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.39,
      left: MediaQuery.of(context).size.width * 0.02,
      right: MediaQuery.of(context).size.width * 0.02,
      child: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
            right: MediaQuery.of(context).size.width * 0.06),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: AppColors.bgColor,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            title == "Wallet"
                ? SizedBox()
                : InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Wallet("Wallet"))),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.10,
                      width: MediaQuery.of(context).size.width * 0.10,
                      decoration: BoxDecoration(
                          //color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage("asset/wallet.png"),
                              fit: BoxFit.contain)),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
