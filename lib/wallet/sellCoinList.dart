import 'package:flutter/material.dart';

class SellCoinList extends StatefulWidget {
  int index;
  SellCoinList(this.index);

  _SellCoinListState createState() => _SellCoinListState();
}

class _SellCoinListState extends State<SellCoinList> {
  @override
  Widget build(BuildContext context) {
    print("Index..." + widget.index.toString());
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                widget.index == 0
                    ? Text(
                        "Kodecoin".toUpperCase(),
                      )
                    : widget.index == 1
                        ? Text("Bitcoin".toUpperCase())
                        : Text("Etherium".toUpperCase()),
                Spacer(),
                Text("")
              ],
            ),
          )
        ],
      ),
    );
  }
}
