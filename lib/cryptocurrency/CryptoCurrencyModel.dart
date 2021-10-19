class CryptoCurrencyModel {
  List<RespData> respData;
  int success;
  String message;

  CryptoCurrencyModel({this.respData, this.success, this.message});

  CryptoCurrencyModel.fromJson(Map<String, dynamic> json) {
    if (json['respData'] != null) {
      respData = new List<RespData>();
      json['respData'].forEach((v) {
        print("V...." + v.toString());
        respData.add(new RespData.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.respData != null) {
      data['respData'] = this.respData.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class RespData {
  String cryptoId;
  String cryptoName;
  String cryptoSymbol;
  String cryptoDescription;
  String currentPriceInr;
  String currentPriceBtc;
  String currentPriceUsd;

  RespData(
      {this.cryptoId,
      this.cryptoName,
      this.cryptoSymbol,
      this.cryptoDescription,
      this.currentPriceInr,
      this.currentPriceBtc,
      this.currentPriceUsd});

  RespData.fromJson(Map<String, dynamic> json) {
    cryptoId = json['crypto_id'];
    cryptoName = json['crypto_name'];
    cryptoSymbol = json['crypto_symbol'];
    cryptoDescription = json['crypto_description'];
    currentPriceInr = json['current_price_inr'];
    currentPriceBtc = json['current_price_btc'];
    currentPriceUsd = json['current_price_usd'];
    // print("crypto id..." + cryptoId.toString());
    // print("crypto id..." + cryptoName.toString());
    // print("crypto id..." + cryptoSymbol.toString());
    // print("crypto id..." + cryptoDescription.toString());
    // print("crypto id..." + currentPriceInr.toString());
    // print("crypto id..." + currentPriceBtc.toString());
    // print("crypto id..." + currentPriceUsd.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crypto_id'] = this.cryptoId;
    data['crypto_name'] = this.cryptoName;
    data['crypto_symbol'] = this.cryptoSymbol;
    data['crypto_description'] = this.cryptoDescription;
    data['current_price_inr'] = this.currentPriceInr;
    data['current_price_btc'] = this.currentPriceBtc;
    data['current_price_usd'] = this.currentPriceUsd;
    return data;
  }
}
