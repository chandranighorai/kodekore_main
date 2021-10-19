// import 'dart:convert';

// import 'package:groceryapp/login/LoginScreen.dart';
// import 'package:groceryapp/search/SearchModel.dart';
// import 'package:groceryapp/util/Variables.dart';

// import '../reviews/PostReviewScreen.dart';
// import '../reviews/ReviewsScreen.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:platform_device_id/platform_device_id.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../products/ProductModel.dart';
// import '../shapes/screen_clip.dart';
// import '../shopping_cart/ShoppingCartScreen.dart';
// import '../util/AppColors.dart';
// import '../util/Consts.dart';
// import '../util/Util.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:image_viewer/image_viewer.dart';

// class ProductDetails extends StatefulWidget {
//   final ProductModel itemProduct;
//   final Productdata productdata;
//   final bool isAgent;
//   final String previousScreen;
//   final bool isSearch;

//   const ProductDetails(
//       {Key key,
//       this.itemProduct,
//       this.isAgent,
//       this.previousScreen,
//       this.productdata,
//       this.isSearch})
//       : super(key: key);
//   @override
//   _ProductDetails createState() => _ProductDetails();
// }

// class _ProductDetails extends State<ProductDetails> {
//   List<String> imgList = [];

//   bool isApiCalling;
//   bool isAgent;
//   bool _isSearch;
//   bool isWish;
//   int _itemCount;
//   double productPrice;
//   double price;
//   double priceCart = 0;
//   int quantity;
//   bool _isAddedToCart;
//   bool _callingUpdateApi;
//   int rowId;
//   SharedPreferences prefs;
//   int _noOfProduct = 0;
//   String deviceID;
//   var requestParam;
//   TextEditingController quantityController;
//   int weightIndex = 0;
//   var arrCartProducts;
//   var productSize;

//   bool isUserLoggedIn;
//   double colorchange;
//   @override
//   void initState() {
//     // TODO: implement initState
//     isAgent = widget.isAgent;
//     productPrice = 0;
//     quantityController = TextEditingController();
//     _itemCount = 1;
//     quantityController.text = "$_itemCount";
//     _isAddedToCart = false;
//     _callingUpdateApi = false;
//     _isSearch = false;
//     quantity = 0;
//     super.initState();

//     _isSearch = widget.isSearch;
//     if (_isSearch == null) {
//       _isSearch = false;
//     }
//     if (_isSearch) {
//       imgList = widget.productdata.galleryImages;
//       isWish = widget.productdata.isInWishlist == 1 ? true : false;
//       // print("product_attr..." +
//       //     widget.productdata.productAttribute[0].productPrice.length
//       //         .toString());
//       if (isAgent) {
//         if (widget.productdata.productType == "variable") {
//           productPrice = double.parse(widget
//               .productdata.productAttribute[0].productDistributorPrice
//               .toString());
//           colorchange = productPrice;
//         } else {
//           productPrice = double.parse(
//               widget.productdata.productDistributorPrice.toString());
//           colorchange = productPrice;
//         }
//       } else {
//         if (widget.productdata.productType == "variable") {
//           productPrice = double.parse(
//               widget.productdata.productAttribute[0].productPrice.toString());
//           colorchange = productPrice;
//         } else {
//           productPrice =
//               double.parse(widget.productdata.productPrice.toString());
//           colorchange = productPrice;
//         }
//       }
//     } else {
//       imgList = widget.itemProduct.galleryImages;
//       debugPrint('imgList');
//       // print("imageList..." + imgList.length.toString());
//       // print("IsAgent..." + isAgent.toString());
//       if (isAgent) {
//         isWish = widget.itemProduct.isInWishList == 1 ? true : false;
//         if (widget.itemProduct.productType == "variable") {
//           productPrice = double.parse(widget
//               .itemProduct.productAttribute[0].productDistributorPrice
//               .toString());
//           colorchange = productPrice;
//         } else {
//           productPrice = double.parse(
//               widget.itemProduct.productDistributorPrice.toString());
//           colorchange = productPrice;
//         }
//       } else {
//         if (widget.itemProduct.productType == "variable") {
//           productPrice = double.parse(
//               widget.itemProduct.productAttribute[0].productPrice.toString());
//           colorchange = productPrice;
//         } else {
//           productPrice =
//               double.parse(widget.itemProduct.productPrice.toString());
//           colorchange = productPrice;
//         }
//       }
//     }
//     price = productPrice * _itemCount;

//     isApiCalling = false;

//     isUserLoggedIn = false;

//     _handleFetchCart();

//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   initPlatformState() async {
//     String deviceId;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       deviceId = await PlatformDeviceId.getDeviceId;
//     } on PlatformException {
//       deviceId = 'Failed to get deviceId.';
//     }
//     debugPrint("Please device id ${deviceId}");

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       deviceID = deviceId;
//       //print("deviceId->$deviceID");
//     });
//   }

//   Future<Null> _handleAddCart(
//       String productId,
//       String productTitle,
//       String productPrice,
//       String productQty,
//       String productRegularPrice) async {
//     prefs = await SharedPreferences.getInstance();
//     print("isSearch...add cart Click...");
//     print("ID..." + productId.toString());
//     print("ID..." + productTitle.toString());
//     print("ID..." + productPrice.toString());
//     print("ID..." + productQty.toString());
//     print("ID..." + productRegularPrice.toString());

//     //print("isSearch...add cart Click..."+_itemCount.toString());
//     var user_id = prefs.getString('user_id');

//     if (user_id == null) {
//       user_id = '';
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LoginScreen(),
//         ),
//       );
//     } else {
//       //print(user_id);
//       print("isSearch...weightIndex..." + weightIndex.toString());
//       print("isSearch...productQty..." + productQty.toString());
//       print("isSearch...productQty..." + _itemCount.toString());
//       var requestParam = "?";
//       requestParam += "user_id=" + user_id;
//       // requestParam += "&device_id=" + deviceID.toString();
//       requestParam += "&product_id=" + productId;
//       requestParam += "&name=" + productTitle.trim();
//       requestParam += "&price=" + productPrice;
//       requestParam += "&quantity=" + _itemCount.toString();
//       requestParam += "&size=" + productQty.toString();
//       requestParam += "&regular_price=" + productRegularPrice.toString();

//       print(
//           "add cart.." + Uri.parse(Consts.ADD_CART + requestParam).toString());

//       setState(() {
//         _callingUpdateApi = true;
//       });

//       final http.Response response = await http.get(
//         Uri.parse(Consts.ADD_CART + requestParam),
//       );

//       if (response.statusCode == 200) {
//         //print(response.body);
//         var responseData = jsonDecode(response.body);
//         var serverCode = responseData['code'];
//         if (serverCode == "200") {
//           if (user_id == '') {
//             prefs.setString("user_id", responseData['user_id'].toString());
//             prefs.setString("usertype", responseData['user_type'].toString());
//           }
//           setState(() {
//             _isAddedToCart = true;
//             quantity += 1;
//             rowId = int.parse(responseData['row_id'].toString());
//             Variables.itemCount = quantity;
//           });
//         }

//         var serverMessage = responseData['message'];
//         showCustomToast(serverMessage);
//       } else {}

//       setState(() {
//         _callingUpdateApi = false;
//       });
//     }
//     _handleFetchCart();
//   }

//   Future<Null> _handleFetchCart() async {
//     prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');
//     String productId;
//     if (user_id == null) {
//       return null;
//     }
//     setState(() {
//       isUserLoggedIn = true;
//       _isAddedToCart = false;
//       _itemCount = 1;
//     });
//     var requestParam = "?";
//     requestParam += "user_id=" + user_id;
//     print("cart requestParam...." + requestParam);
//     final http.Response response = await http.get(
//       Uri.parse(Consts.VIEW_CART + requestParam),
//     );
//     print(
//         "viewCart..." + Uri.parse(Consts.VIEW_CART + requestParam).toString());
//     // print(response.body);
//     if (response.statusCode == 200) {
//       var responseData = jsonDecode(response.body);
//       var serverCode = responseData['code'];
//       var serverMessage = responseData['message'];
//       if (serverCode == "200") {
//         setState(() {
//           arrCartProducts = responseData["productdata"];
//         });
//         if (arrCartProducts.length > 0) {
//           for (int i = 0; i < arrCartProducts.length; i++) {
//             if (_isSearch) {
//               productId = widget.productdata.productId;
//               if (widget.productdata.productType == "variable") {
//                 productSize =
//                     widget.productdata.productAttribute[weightIndex].name;
//               } else {
//                 productSize = widget.productdata.productQuantityInfo;
//               }
//             } else {
//               productId = widget.itemProduct.productId;
//               if (widget.itemProduct.productType == "variable") {
//                 setState(() {
//                   productSize =
//                       widget.itemProduct.productAttribute[weightIndex].name;
//                   print("productSize...000" + productSize.toString());
//                 });
//               } else {
//                 setState(() {
//                   productSize = widget.itemProduct.productQuantityInfo;
//                 });
//               }
//             }
//             if (productId == arrCartProducts[i]['product_id'].toString()) {
//               print("productId..." + productId.toString());
//               print("productId..." + productSize.toString());
//               if (productSize == arrCartProducts[i]['size'].toString()) {
//                 setState(() {
//                   _isAddedToCart = true;
//                   rowId = int.parse(arrCartProducts[i]['row_id'].toString());
//                   _itemCount = int.parse(arrCartProducts[i]['qty'].toString());
//                   quantityController.text = "$_itemCount";
//                   price = productPrice * _itemCount;
//                 });
//               }
//             }
//           }
//           setState(() {
//             quantity = arrCartProducts.length;
//             Variables.itemCount = quantity;
//           });
//           //Variables.itemCount = quantity;
//         } else {
//           setState(() {
//             quantityController.text = "$_itemCount";
//           });
//         }
//       } else {
//         //print("Else part");
//         setState(() {
//           quantity = 0;
//           _itemCount = 1;
//           _isAddedToCart = false;
//           price = productPrice * _itemCount;
//           _callingUpdateApi = false;
//           quantityController.text = "$_itemCount";
//           Variables.itemCount = quantity;
//         });
//         //Variables.itemCount = quantity;
//       }
//     }
//   }

//   _updateCart(String productId, int quantity) async {
//     print("Quantity..." + quantity.toString());
//     if (quantity <= 0) {}
//     setState(() {
//       _callingUpdateApi = true;
//     });
//     var requestParam = "?";
//     requestParam += "row_id=" + rowId.toString();
//     requestParam += "&quantity=" + quantity.toString();
//     final http.Response response = await http.get(
//       Uri.parse(Consts.UPDATE_CART + requestParam),
//     );
//     print("updateCart///" + Consts.UPDATE_CART + requestParam);
//     if (response.statusCode == 200) {
//       print(response.body);
//       setState(() {
//         _callingUpdateApi = false;
//       });
//       var responseData = jsonDecode(response.body);
//       var serverCode = responseData['code'];
//       var serverMessage = responseData['message'];

//       if (serverCode == "200") {
//         showCustomToast(serverMessage);
//       }
//     } else {}
//   }

//   _gotoShoppinCartScreen() async {
//     var openCart = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ShoppingCartScreen(),
//       ),
//     );

//     if (openCart != null && openCart == "refresh cart") {
//       debugPrint("Returned data $openCart");
//       _handleFetchCart();
//       setState(() {});
//     }
//   }

//   _addtocartBtnPressed() {
//     debugPrint("_addtocartBtnPressed pressed");
//     // print(
//     //     "product size..." + widget.itemProduct.productQuantityInfo.toString());
//     if (_isAddedToCart) {
//       if (_isSearch == true) {
//         if (_itemCount == 0) {
//           _handleRemove(widget.productdata.productId);
//         } else {
//           _updateCart(widget.productdata.productId, _itemCount);
//         }
//       } else {
//         print("Row in remove..." + _itemCount.toString());
//         if (_itemCount == 0) {
//           _handleRemove(widget.itemProduct.productId);
//         } else {
//           _updateCart(widget.itemProduct.productId, _itemCount);
//         }
//       }
//     } else {
//       print("isSearch...clicked");
//       print("isSearch..." + _isSearch.toString());
//       if (_isSearch) {
//         //print("_search..." + _isSearch.toString());
//         //newly try....when does not take the click on variable data
//         if (widget.productdata.productType == "variable") {
//           //print("_search..." + price.toString());
//           _handleAddCart(
//               widget.productdata.productId,
//               widget.productdata.productTitle,
//               price.toString(),
//               widget.productdata.productAttribute[weightIndex].name.toString(),
//               widget
//                   .productdata.productAttribute[weightIndex].productRegularPrice
//                   .toString());
//         } else {
//           _handleAddCart(
//               widget.productdata.productId,
//               widget.productdata.productTitle,
//               widget.productdata.productPrice,
//               widget.productdata.productQuantityInfo.toString(),
//               widget.productdata.productRegularPrice.toString());
//         }
//       } else {
//         // print("_search..." + _isSearch.toString());
//         // print("_search..." + widget.itemProduct.toString());
//         //newly try....when does not take the click on variable data
//         if (widget.itemProduct.productType == "variable") {
//           _handleAddCart(
//             widget.itemProduct.productId,
//             widget.itemProduct.productTitle,
//             price.toString(),
//             widget.itemProduct.productAttribute[weightIndex].name.toString(),
//             widget.itemProduct.productAttribute[weightIndex].productRegularPrice
//                 .toString(),
//           );
//         } else {
//           _handleAddCart(
//               widget.itemProduct.productId,
//               widget.itemProduct.productTitle,
//               widget.itemProduct.productPrice,
//               widget.itemProduct.productQuantityInfo.toString(),
//               widget.itemProduct.productRegularPrice.toString());
//         }
//       }
//     }
//   }

//   _handleRemove(String productId) async {
//     print("Row in remove...");
//     print("Row in remove..." + rowId.toString());
//     prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');

//     if (user_id == null) {
//       return;
//     }
//     var requestParam = "?";
//     requestParam += "user_id=" + user_id;
//     requestParam += "&product_id=" + productId;
//     requestParam += "&row_id=" + rowId.toString();

//     final http.Response response = await http.get(
//       Uri.parse(Consts.DELETE_CART + requestParam),
//     );
//     // final http.Response response = await http.get(
//     //   Uri.parse(Consts.DELETE_CART_FROM_DETAILS + requestParam),
//     // );
//     print("remove api..." +
//         Uri.parse(Consts.DELETE_CART_FROM_DETAILS + requestParam).toString());
//     if (response.statusCode == 200) {
//       var responseData = jsonDecode(response.body);
//       var serverCode = responseData['status'];
//       if (serverCode == "success") {
//         quantity = quantity - 1;
//         Variables.itemCount = Variables.itemCount - 1;
//         setState(() {
//           _isAddedToCart = false;
//           rowId = 0;
//           _itemCount = 1;
//           quantityController.text = "$_itemCount";
//           price = productPrice * _itemCount;
//         });
//       }

//       var serverMessage = responseData['message'];
//       showCustomToast(serverMessage);
//     } else {}
//   }

//   wishAdd(bool isWish, ProductModel itemProduct) async {
//     //print(isWish);
//     var addwis = "";
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');
//     if (user_id == null) {
//       user_id = '';
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LoginScreen(),
//         ),
//       );
//     } else {
//       if (isWish) {
//         addwis = "add";
//       } else {
//         addwis = "remove";
//       }
//       requestParam = "?";
//       requestParam += "user_id=" + user_id;
//       requestParam += "&device_id=" + deviceID.toString();
//       requestParam += "&product_id=" + itemProduct.productId;
//       requestParam += "&action=" + addwis;
//       //print(Consts.ADD_TO_WISHLIST + requestParam);
//       final http.Response response = await http.get(
//         Uri.parse(Consts.ADD_TO_WISHLIST + requestParam),
//       );

//       //print(response.statusCode);
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         var serverCode = responseData['code'];
//         var serverMessage = responseData['message'];
//         if (serverCode == "200") {
//           showCustomToast(serverMessage);
//           if (user_id == '') {
//             prefs.setString("user_id", responseData['user_id'].toString());
//             prefs.setString("usertype", responseData['user_type'].toString());
//           }
//           setState(() {
//             widget.itemProduct.isInWishList = isWish ? 1 : 0;
//           });
//         } else {
//           showCustomToast(serverMessage);
//         }
//       } else {
//         showCustomToast(Consts.SERVER_NOT_RESPONDING);
//       }
//     }
//   }

//   wishAddsearch(bool isWish, Productdata itemProduct) async {
//     //print(isWish);
//     var addwis = "";
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');
//     if (user_id == null) {
//       user_id = '';
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LoginScreen(),
//         ),
//       );
//     } else {
//       if (isWish) {
//         addwis = "add";
//       } else {
//         addwis = "remove";
//       }
//       requestParam = "?";
//       requestParam += "user_id=" + user_id;
//       requestParam += "&device_id=" + deviceID.toString();
//       requestParam += "&product_id=" + widget.productdata.productId;
//       requestParam += "&action=" + addwis;
//       //print(Consts.ADD_TO_WISHLIST + requestParam);
//       final http.Response response = await http.get(
//         Uri.parse(Consts.ADD_TO_WISHLIST + requestParam),
//       );

//       //print(response.statusCode);
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         var serverCode = responseData['code'];
//         var serverMessage = responseData['message'];
//         if (serverCode == "200") {
//           showCustomToast(serverMessage);
//           if (user_id == '') {
//             prefs.setString("user_id", responseData['user_id'].toString());
//             prefs.setString("usertype", responseData['user_type'].toString());
//           }
//           setState(() {
//             widget.productdata.isInWishlist = isWish ? 1 : 0;
//           });
//         } else {
//           showCustomToast(serverMessage);
//         }
//       } else {
//         showCustomToast(Consts.SERVER_NOT_RESPONDING);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ProductModel itemProduct = widget.itemProduct;
//     //print("product_id..." + widget.itemProduct.productId.toString());
//     //print("product_id..." + widget.productdata.productId.toString());
//     //Productdata pro = widget.productdata;
//     //print("isInWishList...in pd" + widget.itemProduct.isInWishList.toString());
//     //print("isInWishList...in pd" + pro.isInWishlist.toString());

//     // print("all item in productDetails..." +
//     //     itemProduct.productAttribute[0].toString());
//     // debugPrint(itemProduct.isInWishList.toString());
//     double shapeHeight = 170;
//     return WillPopScope(
//       onWillPop: () {
//         Navigator.pop(context, "refresh cart");
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         // drawer: Navigation(),
//         appBar: AppBar(
//           backgroundColor: AppColors.appBarColor,
//           title: Center(
//               child: Text(
//             "Vedic",
//             style: TextStyle(fontFamily: "Philosopher", fontSize: 36),
//           )),
//           actions: <Widget>[
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () => {
//                     // if(isWish==true){
//                     setState(
//                       () {
//                         isWish = !isWish;
//                       },
//                     ),
//                     _isSearch != true
//                         ? wishAdd(isWish, itemProduct)
//                         : wishAddsearch(isWish, widget.productdata),

//                     // wishAdd(),
//                   },
//                   child: _isSearch == true
//                       ? Container(
//                           child: widget.productdata.isInWishlist == 1
//                               ? Image.asset(
//                                   "images/ic_wishlistActive.png",
//                                   height: 30,
//                                 )
//                               : Image.asset(
//                                   "images/ic_wishlist.png",
//                                   height: 30,
//                                 ),
//                         )
//                       : Container(
//                           child: itemProduct.isInWishList == 1
//                               ? Image.asset(
//                                   "images/ic_wishlistActive.png",
//                                   height: 30,
//                                 )
//                               : Image.asset(
//                                   "images/ic_wishlist.png",
//                                   height: 30,
//                                 ),
//                         ),

//                   // itemProduct.isInWishList == 1
//                   //     ? Image.asset(
//                   //         "images/ic_wishlistActive.png",
//                   //         height: 30,
//                   //       )
//                   //     : Image.asset(
//                   //         "images/ic_wishlist.png",
//                   //         height: 30,
//                   //       ),
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.02,
//                 ),
//                 InkWell(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 10.0),
//                     child: Container(
//                       width: 40,
//                       child: Stack(
//                         children: [
//                           Center(
//                             child: Icon(
//                               Icons.shopping_cart,
//                               color: Colors.white,
//                               size: 34,
//                             ),
//                           ),
//                           Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 30.0),
//                               child: Container(
//                                 width: 25,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: AppColors.appMainColor,
//                                   border: Border.all(
//                                     color: Colors.white,
//                                     width: 0.2,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     Variables.itemCount == null
//                                         ? "0"
//                                         : "${Variables.itemCount}",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     // _handleAddCart(itemProduct);
//                     _gotoShoppinCartScreen();
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//         body: SafeArea(
//           child: Container(
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("images/image_bg.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Stack(
//                             children: <Widget>[
// // The containers in the background
//                               new Column(
//                                 children: <Widget>[
//                                   // shapeComponet(context, Consts.shapeHeight),
//                                   ClipPath(
//                                     clipper: RedShape(
//                                         MediaQuery.of(context).size.width,
//                                         shapeHeight * 0.62),
//                                     child:
//                                         // Row(
//                                         //   children: [
//                                         Container(
//                                       height: shapeHeight,
//                                       decoration: BoxDecoration(
//                                         color: Color(0XFFc80718),
//                                       ),
//                                       child: Stack(children: [
//                                         Container(
//                                           margin: EdgeInsets.only(
//                                             left: 20,
//                                             right: 10,
//                                           ),
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                               top: 15,
//                                             ),
//                                             child: Text(
//                                               _isSearch != true
//                                                   ? itemProduct.productTitle
//                                                   : widget
//                                                       .productdata.productTitle,
//                                               style: TextStyle(
//                                                 fontSize: 21,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         // Positioned(
//                                         //   top: MediaQuery.of(context)
//                                         //           .size
//                                         //           .height *
//                                         //       0.024,
//                                         //   right: MediaQuery.of(context)
//                                         //           .size
//                                         //           .width *
//                                         //       0.02,
//                                         //   // left: MediaQuery.of(context)
//                                         //   //         .size
//                                         //   //         .width *
//                                         //   //     0.25,
//                                         //   child: InkWell(
//                                         //     onTap: () => {
//                                         //       // if(isWish==true){
//                                         //       setState(
//                                         //         () {
//                                         //           isWish = !isWish;
//                                         //         },
//                                         //       ),
//                                         //       wishAdd(isWish, itemProduct),

//                                         //       // wishAdd(),
//                                         //     },
//                                         //     child: itemProduct.isInWishList == 1
//                                         //         ? Image.asset(
//                                         //             "images/ic_wishlistActive.png",
//                                         //             height: 25,
//                                         //           )
//                                         //         : Image.asset(
//                                         //             "images/ic_wishlist.png",
//                                         //             height: 25,
//                                         //           ),
//                                         //   ),
//                                         // )
//                                       ]),
//                                     ),
//                                     // Spacer(),

//                                     //   ],
//                                     // ),
//                                   ),
//                                 ],
//                               ),

// // The card widget with top padding,
// // incase if you wanted bottom padding to work,
// // set the `alignment` of container to Alignment.bottomCenter
//                               new Container(
//                                 alignment: Alignment.topCenter,
//                                 color: Colors.transparent,
//                                 padding: new EdgeInsets.only(
//                                   //top: shapeHeight * 1.12,
//                                   top: shapeHeight * 0.7,
//                                   right: 0.0,
//                                   left: 0.0,
//                                 ),
//                                 child: CarouselSlider(
//                                   options: CarouselOptions(
//                                     autoPlay: true,
//                                     enlargeCenterPage: true,
//                                     reverse: false,
//                                     // aspectRatio: 2.2,
//                                     //height: 260,
//                                     height: MediaQuery.of(context).size.width *
//                                         0.95,
//                                     viewportFraction: 0.8,
//                                     //  enlargeStrategy:
//                                     //      CenterPageEnlargeStrategy.height,
//                                   ),
//                                   items: imgList
//                                       .map(
//                                         (item) => Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 8.0,
//                                           ),
//                                           child: Container(
//                                             //height: 400,
//                                             decoration: BoxDecoration(
//                                               //color: Colors.red,
//                                               color: Colors.transparent,
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(9),
//                                               ),
//                                               border: Border.all(
//                                                   color: AppColors
//                                                       .categoryProductLayout,
//                                                   width: 1),
//                                             ),
//                                             child: Stack(
//                                               children: [
//                                                 Container(
//                                                   // height: 250,
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width -
//                                                       50,
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             9),
//                                                     child: Image.network(
//                                                       item,
//                                                       //fit: BoxFit.fill,
//                                                       //fit: BoxFit.fill,
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width -
//                                                               50,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Align(
//                                                   alignment:
//                                                       Alignment.bottomCenter,
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       // _addtocartBtnPressed();
//                                                       ImageViewer
//                                                           .showImageSlider(
//                                                         images: imgList,
//                                                         startingPosition: 0,
//                                                       );
//                                                     },
//                                                     child: Container(
//                                                       height: 60,
//                                                       width: 60,
//                                                       // decoration: BoxDecoration(
//                                                       //   shape: BoxShape.circle,
//                                                       //   // color: AppColors
//                                                       //   //     .appMainColor,
//                                                       // ),
//                                                       // child: Image.asset(
//                                                       //   "images/view_img.png",
//                                                       //   height: 50,
//                                                       //   width: 50,
//                                                       // ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                       .toList(),
//                                 ),
// // ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 18.0,
//                               right: 8.0,
//                               top: 20,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 // crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     // color: AppColors.appBarColor,
//                                     child: Column(
//                                       children: [
//                                         // Row(
//                                         //   mainAxisAlignment:
//                                         //       MainAxisAlignment.spaceBetween,
//                                         //   children: [
//                                         //     Flexible(
//                                         //       child: Text(
//                                         //         _isSearch != true
//                                         //             ? itemProduct.productTitle
//                                         //             : widget.productdata
//                                         //                 .productTitle,
//                                         //         style: TextStyle(
//                                         //           color: AppColors
//                                         //               .categoryTextColor,
//                                         //           fontSize: 18,
//                                         //           fontWeight: FontWeight.w700,
//                                         //         ),
//                                         //       ),
//                                         //     ),
//                                         //   ],
//                                         // ),
//                                         //   ],
//                                         // ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             //_productListwish
//                                             // InkWell(
//                                             //   onTap: () => {
//                                             //     // if(isWish==true){
//                                             //     setState(
//                                             //       () {
//                                             //         isWish = !isWish;
//                                             //       },
//                                             //     ),
//                                             //     wishAdd(isWish, itemProduct),

//                                             //     // wishAdd(),
//                                             //   },
//                                             //   child:
//                                             //       itemProduct.isInWishList == 1
//                                             //           ? Image.asset(
//                                             //               "images/ic_wishlistActive.png",
//                                             //               height: 25,
//                                             //             )
//                                             //           : Image.asset(
//                                             //               "images/ic_wishlist.png",
//                                             //               height: 25,
//                                             //             ),
//                                             // ),
//                                           ],
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "\u20B9 $price",
//                                               style: TextStyle(
//                                                 color: Colors.red,
//                                                 fontSize: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.05,
//                                                 // fontSize: 16,
//                                                 //fontWeight: FontWeight.w900,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             //Spacer(),
//                                             // Container(
//                                             //   //color: Colors.amber,
//                                             //   padding: EdgeInsets.only(
//                                             //       left: MediaQuery.of(context)
//                                             //               .size
//                                             //               .width *
//                                             //           0.05),
//                                             //   child: Row(
//                                             //     crossAxisAlignment:
//                                             //         CrossAxisAlignment.center,
//                                             //     mainAxisAlignment:
//                                             //         MainAxisAlignment.center,
//                                             //     children: [
//                                             // InkWell(
//                                             //   onTap: () {
//                                             //     if (_noOfProduct > 0) {
//                                             //       setState(() {
//                                             //         _noOfProduct =
//                                             //             _noOfProduct - 1;
//                                             //       });
//                                             //     } else {
//                                             //       setState(() {
//                                             //         _noOfProduct = 0;
//                                             //       });
//                                             //     }
//                                             //   },
//                                             //   child: Container(
//                                             //     padding: EdgeInsets.only(
//                                             //         left: MediaQuery.of(
//                                             //                     context)
//                                             //                 .size
//                                             //                 .width *
//                                             //             0.02,
//                                             //         right: MediaQuery.of(
//                                             //                     context)
//                                             //                 .size
//                                             //                 .width *
//                                             //             0.02),
//                                             //     decoration: BoxDecoration(
//                                             //         color:
//                                             //             Colors.grey[100],
//                                             //         border: Border.all(
//                                             //             color:
//                                             //                 Colors.black),
//                                             //         shape:
//                                             //             BoxShape.circle),
//                                             //     child: Text("-",
//                                             //         textAlign:
//                                             //             TextAlign.center,
//                                             //         style: TextStyle(
//                                             //             fontSize: MediaQuery.of(
//                                             //                         context)
//                                             //                     .size
//                                             //                     .width *
//                                             //                 0.06)),
//                                             //   ),
//                                             // ),
//                                             // SizedBox(
//                                             //     width:
//                                             //         MediaQuery.of(context)
//                                             //                 .size
//                                             //                 .width *
//                                             //             0.02),
//                                             // Text(
//                                             //   _noOfProduct.toString(),
//                                             //   style: TextStyle(
//                                             //       fontSize: MediaQuery.of(
//                                             //                   context)
//                                             //               .size
//                                             //               .width *
//                                             //           0.05),
//                                             // ),
//                                             // SizedBox(
//                                             //     width:
//                                             //         MediaQuery.of(context)
//                                             //                 .size
//                                             //                 .width *
//                                             //             0.02),
//                                             // InkWell(
//                                             //   onTap: () {
//                                             //     if (_noOfProduct >= 0) {
//                                             //       setState(() {
//                                             //         _noOfProduct =
//                                             //             _noOfProduct + 1;
//                                             //       });
//                                             //     } else {
//                                             //       setState(() {
//                                             //         _noOfProduct = 0;
//                                             //       });
//                                             //     }
//                                             //   },
//                                             //   child: Container(
//                                             //     padding: EdgeInsets.all(
//                                             //         MediaQuery.of(context)
//                                             //                 .size
//                                             //                 .width *
//                                             //             0.013),
//                                             //     decoration: BoxDecoration(
//                                             //         color:
//                                             //             Colors.grey[100],
//                                             //         border: Border.all(
//                                             //             color:
//                                             //                 Colors.black),
//                                             //         shape:
//                                             //             BoxShape.circle),
//                                             //     child: Text("+",
//                                             //         textAlign:
//                                             //             TextAlign.justify,
//                                             //         style: TextStyle(
//                                             //             fontSize: MediaQuery.of(
//                                             //                         context)
//                                             //                     .size
//                                             //                     .width *
//                                             //                 0.05)),
//                                             //   ),
//                                             // ),
//                                             //     ],
//                                             //   ),
//                                             // ),
//                                             // Row(
//                                             //   mainAxisSize: MainAxisSize.min,
//                                             //   mainAxisAlignment: MainAxisAlignment.end,
//                                             //   children: [
//                                             //     Container(
//                                             //       child: Stack(
//                                             //         children: [
//                                             //           Row(
//                                             //             children: [
//                                             //               Container(
//                                             //                 height: 50,
//                                             //                 width: 50,
//                                             //                 child: IconButton(
//                                             //                   icon: Image.asset(
//                                             //                       'images/ic_minus.png'),
//                                             //                   onPressed: () {
//                                             //                     DcrBtn();
//                                             //                   },
//                                             //                 ),
//                                             //               ),
//                                             //               Container(
//                                             //                 width: 60,
//                                             //                 alignment: Alignment.center,
//                                             //                 child: TextField(
//                                             //                   enableInteractiveSelection:
//                                             //                       false,
//                                             //                   keyboardType:
//                                             //                       TextInputType.number,
//                                             //                   inputFormatters: <
//                                             //                       TextInputFormatter>[
//                                             //                     FilteringTextInputFormatter
//                                             //                         .allow(
//                                             //                       RegExp(r'[0-9]'),
//                                             //                     ),
//                                             //                   ],
//                                             //                   controller:
//                                             //                       quantityController,
//                                             //                   textAlign:
//                                             //                       TextAlign.center,
//                                             //                   style: TextStyle(
//                                             //                     color: Colors.black,
//                                             //                   ),
//                                             //                   decoration:
//                                             //                       InputDecoration(
//                                             //                     filled: true,
//                                             //                     fillColor:
//                                             //                         Color(0XFFF8F8F8),
//                                             //                     focusedBorder:
//                                             //                         UnderlineInputBorder(
//                                             //                       borderSide:
//                                             //                           BorderSide(
//                                             //                         color: Color(
//                                             //                             0XFFD4DFE8),
//                                             //                         width: 2,
//                                             //                       ),
//                                             //                     ),
//                                             //                     hintText: "0",
//                                             //                     hintStyle: TextStyle(
//                                             //                       color: Colors.black,
//                                             //                     ),
//                                             //                   ),
//                                             //                   onChanged: (value) {
//                                             //                     if (value != "") {
//                                             //                       setState(() {
//                                             //                         _itemCount =
//                                             //                             int.parse(
//                                             //                                 value);
//                                             //                         if (value == "") {
//                                             //                           price =
//                                             //                               productPrice *
//                                             //                                   1;
//                                             //                         }
//                                             //
//                                             //                         if (_itemCount >=
//                                             //                             1) {
//                                             //                           price =
//                                             //                               productPrice *
//                                             //                                   _itemCount;
//                                             //                         } else if (_itemCount ==
//                                             //                             0) {
//                                             //                           price =
//                                             //                               productPrice *
//                                             //                                   1;
//                                             //                         } else {
//                                             //                           price =
//                                             //                               productPrice *
//                                             //                                   1;
//                                             //                         }
//                                             //                       });
//                                             //                     } else {
//                                             //                       debugPrint("Blank");
//                                             //                       setState(() {
//                                             //                         price =
//                                             //                             productPrice *
//                                             //                                 1;
//                                             //                         _itemCount = 0;
//                                             //                       });
//                                             //                     }
//                                             //                   },
//                                             //                 ),
//                                             //               ),
//                                             //               Container(
//                                             //                 height: 50,
//                                             //                 width: 50,
//                                             //                 child: IconButton(
//                                             //                   icon: Image.asset(
//                                             //                       'images/ic_plus.png'),
//                                             //                   onPressed: () {
//                                             //                     IncrBtn();
//                                             //                   },
//                                             //                 ),
//                                             //               ),
//                                             //             ],
//                                             //           ),
//                                             //           _callingUpdateApi
//                                             //               ? Center(
//                                             //                   child: Container(
//                                             //                     margin: EdgeInsets.only(
//                                             //                       top: 15,
//                                             //                     ),
//                                             //                     height: 20,
//                                             //                     width: 20,
//                                             //                     child:
//                                             //                         CircularProgressIndicator(
//                                             //                       valueColor:
//                                             //                           new AlwaysStoppedAnimation<
//                                             //                                   Color>(
//                                             //                               Colors
//                                             //                                   .blueGrey),
//                                             //                       strokeWidth: 2,
//                                             //                     ),
//                                             //                   ),
//                                             //                 )
//                                             //               : Container(),
//                                             //         ],
//                                             //       ),
//                                             //     ),
//                                             //   ],
//                                             // ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         _isSearch != true
//                                             ? ((widget.itemProduct
//                                                         .productType ==
//                                                     "simple")
//                                                 ? SizedBox()
//                                                 : Container(
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width *
//                                                             0.35,
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                             .size
//                                                             .width,
//                                                     child: ListView.builder(
//                                                         scrollDirection:
//                                                             Axis.horizontal,
//                                                         shrinkWrap: true,
//                                                         itemCount: widget
//                                                             .itemProduct
//                                                             .productAttribute
//                                                             .length,
//                                                         itemBuilder: (context,
//                                                             int index) {
//                                                           //colorchange = false;
//                                                           return InkWell(
//                                                             onTap: () {
//                                                               print("Index0..." +
//                                                                   index
//                                                                       .toString());
//                                                               print("qnt..." +
//                                                                   quantityController
//                                                                       .text
//                                                                       .toString());
//                                                               showAddToCArt(
//                                                                   widget
//                                                                       .itemProduct
//                                                                       .productAttribute[
//                                                                           index]
//                                                                       .name
//                                                                       .toString(),
//                                                                   index,
//                                                                   double.parse(widget
//                                                                       .itemProduct
//                                                                       .productAttribute[
//                                                                           index]
//                                                                       .productPrice
//                                                                       .toString()));
//                                                               //widget.itemProduct.

//                                                               setState(() {
//                                                                 //_handleFetchCart();
//                                                                 if (quantityController
//                                                                         .text
//                                                                         .toString() ==
//                                                                     "0") {
//                                                                   price = double.parse(widget
//                                                                       .itemProduct
//                                                                       .productAttribute[
//                                                                           index]
//                                                                       .productPrice
//                                                                       .toString());
//                                                                 } else {
//                                                                   price = double.parse(widget
//                                                                           .itemProduct
//                                                                           .productAttribute[
//                                                                               index]
//                                                                           .productPrice
//                                                                           .toString()) *
//                                                                       int.parse(
//                                                                           quantityController
//                                                                               .text);
//                                                                 }

//                                                                 productPrice = double.parse(widget
//                                                                     .itemProduct
//                                                                     .productAttribute[
//                                                                         index]
//                                                                     .productPrice
//                                                                     .toString());
//                                                                 print('Price...' +
//                                                                     price
//                                                                         .toString());
//                                                                 print('product Price...' +
//                                                                     productPrice
//                                                                         .toString());
//                                                                 colorchange = double.parse(widget
//                                                                     .itemProduct
//                                                                     .productAttribute[
//                                                                         index]
//                                                                     .productPrice
//                                                                     .toString());
//                                                                 // print("ColorChange..." +
//                                                                 //     colorchange
//                                                                 //         .toString());
//                                                                 // colorchange =
//                                                                 //     true;
//                                                               });
//                                                             },
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(8.0),
//                                                               child: Container(
//                                                                 padding: EdgeInsets.all(
//                                                                     MediaQuery.of(context)
//                                                                             .size
//                                                                             .width *
//                                                                         0.02),
//                                                                 decoration: BoxDecoration(
//                                                                     boxShadow: [
//                                                                       BoxShadow(
//                                                                           color: double.parse(widget.itemProduct.productAttribute[index].productPrice.toString()) == colorchange
//                                                                               ? Colors.red.withOpacity(0.2)
//                                                                               : Colors.transparent,
//                                                                           blurRadius: 2.0)
//                                                                     ],
//                                                                     border: Border.all(
//                                                                         color: Colors
//                                                                             .grey)),
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                         widget
//                                                                             .itemProduct
//                                                                             .productAttribute[
//                                                                                 index]
//                                                                             .name
//                                                                             .toString(),
//                                                                         style:
//                                                                             TextStyle(
//                                                                           fontWeight:
//                                                                               FontWeight.bold,
//                                                                         )),
//                                                                     // Text("dd"),
//                                                                     Divider(
//                                                                       thickness:
//                                                                           2,
//                                                                       color: Colors
//                                                                           .grey,
//                                                                     ),
//                                                                     Text(
//                                                                       "\u20B9 ${widget.itemProduct.productAttribute[index].productPrice.toString()}",
//                                                                       style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .bold,
//                                                                           fontSize:
//                                                                               MediaQuery.of(context).size.width * 0.04),
//                                                                     ),
//                                                                     Text(
//                                                                       "\u20B9 ${widget.itemProduct.productAttribute[index].productRegularPrice.toString()}",
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .grey,
//                                                                           fontSize: MediaQuery.of(context).size.width *
//                                                                               0.04,
//                                                                           decoration:
//                                                                               TextDecoration.lineThrough),
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }),
//                                                   ))
//                                             : widget.productdata.productType ==
//                                                     "simple"
//                                                 ? SizedBox()
//                                                 : Container(
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width *
//                                                             0.35,
//                                                     // padding: EdgeInsets.only(
//                                                     //     left: 8,
//                                                     //     right: 8,
//                                                     //     top: 2,
//                                                     //     bottom: 2),
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                             .size
//                                                             .width,
//                                                     //color: Colors.amber,
//                                                     child: _isSearch == true
//                                                         ? ListView.builder(
//                                                             scrollDirection:
//                                                                 Axis.horizontal,
//                                                             shrinkWrap: true,
//                                                             itemCount: widget
//                                                                 .productdata
//                                                                 .productAttribute
//                                                                 .length,
//                                                             itemBuilder:
//                                                                 (context,
//                                                                     int index) {
//                                                               return InkWell(
//                                                                 onTap: () {
//                                                                   print("Index..." +
//                                                                       index
//                                                                           .toString());
//                                                                   print("qnt..." +
//                                                                       quantityController
//                                                                           .text
//                                                                           .toString());
//                                                                   showAddToCArt(
//                                                                       widget
//                                                                           .productdata
//                                                                           .productAttribute[
//                                                                               index]
//                                                                           .name
//                                                                           .toString(),
//                                                                       index,
//                                                                       double.parse(widget
//                                                                           .productdata
//                                                                           .productAttribute[
//                                                                               index]
//                                                                           .productPrice
//                                                                           .toString()));
//                                                                   //widget.itemProduct.
//                                                                   setState(() {
//                                                                     if (quantityController
//                                                                             .text
//                                                                             .toString() ==
//                                                                         "0") {
//                                                                       price = double.parse(widget
//                                                                           .productdata
//                                                                           .productAttribute[
//                                                                               index]
//                                                                           .productPrice
//                                                                           .toString());
//                                                                     } else {
//                                                                       price = double.parse(widget
//                                                                               .productdata
//                                                                               .productAttribute[index]
//                                                                               .productPrice
//                                                                               .toString()) *
//                                                                           int.parse(quantityController.text);
//                                                                     }

//                                                                     print("Index...1.." +
//                                                                         price
//                                                                             .toString());
//                                                                     weightIndex =
//                                                                         index;
//                                                                     productPrice = double.parse(widget
//                                                                         .productdata
//                                                                         .productAttribute[
//                                                                             index]
//                                                                         .productPrice
//                                                                         .toString());
//                                                                     colorchange = double.parse(widget
//                                                                         .productdata
//                                                                         .productAttribute[
//                                                                             index]
//                                                                         .productPrice
//                                                                         .toString());
//                                                                     // print("ColorChange..." +
//                                                                     //     colorchange
//                                                                     //         .toString());
//                                                                     print("Index...1.." +
//                                                                         productPrice
//                                                                             .toString());
//                                                                     // colorchange =
//                                                                     //     true;
//                                                                     // print("Index...1.." +
//                                                                     //     colorchange
//                                                                     //         .toString());
//                                                                   });
//                                                                 },
//                                                                 child: Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                               .all(
//                                                                           8.0),
//                                                                   child:
//                                                                       Container(
//                                                                     padding: EdgeInsets.all(MediaQuery.of(context)
//                                                                             .size
//                                                                             .width *
//                                                                         0.02),
//                                                                     // height:
//                                                                     //     MediaQuery.of(context)
//                                                                     //         .size
//                                                                     //         .width,
//                                                                     decoration: BoxDecoration(
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: double.parse(widget.productdata.productAttribute[index].productPrice.toString()) == colorchange ? Colors.red.withOpacity(0.2) : Colors.transparent,
//                                                                               blurRadius: 2.0)
//                                                                         ],
//                                                                         border: Border.all(
//                                                                             color:
//                                                                                 Colors.grey)),
//                                                                     child:
//                                                                         Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Text(
//                                                                             widget.productdata.productAttribute[index].name
//                                                                                 .toString(),
//                                                                             style:
//                                                                                 TextStyle(fontWeight: FontWeight.bold)),
//                                                                         // Text("dd"),
//                                                                         Divider(
//                                                                           thickness:
//                                                                               2,
//                                                                           color:
//                                                                               Colors.grey,
//                                                                         ),
//                                                                         Text(
//                                                                           "\u20B9 ${widget.productdata.productAttribute[index].productPrice.toString()}",
//                                                                           style: TextStyle(
//                                                                               fontWeight: FontWeight.bold,
//                                                                               fontSize: MediaQuery.of(context).size.width * 0.04),
//                                                                         ),
//                                                                         Text(
//                                                                           "\u20B9 ${widget.productdata.productAttribute[index].productRegularPrice.toString()}",
//                                                                           style: TextStyle(
//                                                                               color: Colors.grey,
//                                                                               fontSize: MediaQuery.of(context).size.width * 0.04,
//                                                                               decoration: TextDecoration.lineThrough),
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             })
//                                                         : widget.itemProduct
//                                                                     .productType ==
//                                                                 "variable"
//                                                             ? ListView.builder(
//                                                                 scrollDirection: Axis
//                                                                     .horizontal,
//                                                                 shrinkWrap:
//                                                                     true,
//                                                                 itemCount: widget
//                                                                     .itemProduct
//                                                                     .productAttribute
//                                                                     .length,
//                                                                 itemBuilder: (context,
//                                                                     int index) {
//                                                                   return InkWell(
//                                                                     onTap: () {
//                                                                       print("Index0..itemporo." +
//                                                                           index
//                                                                               .toString());
//                                                                       print("qnt..." +
//                                                                           quantityController
//                                                                               .text
//                                                                               .toString());
//                                                                       // print("Index00..." +
//                                                                       //     (double.parse(widget.productdata.productAttribute[index].productPrice.toString())
//                                                                       //         .toString()));
//                                                                       //widget.itemProduct.
//                                                                       showAddToCArt(
//                                                                           widget
//                                                                               .itemProduct
//                                                                               .productAttribute[
//                                                                                   index]
//                                                                               .name
//                                                                               .toString(),
//                                                                           index,
//                                                                           double.parse(widget
//                                                                               .itemProduct
//                                                                               .productAttribute[index]
//                                                                               .productPrice
//                                                                               .toString()));
//                                                                       setState(
//                                                                           () {
//                                                                         if (quantityController.text.toString() ==
//                                                                             "0") {
//                                                                           price = double.parse(widget
//                                                                               .itemProduct
//                                                                               .productAttribute[index]
//                                                                               .productPrice
//                                                                               .toString());
//                                                                         } else {
//                                                                           price =
//                                                                               double.parse(widget.itemProduct.productAttribute[index].productPrice.toString()) * int.parse(quantityController.text);
//                                                                         }
//                                                                         weightIndex =
//                                                                             index;
//                                                                         // productPrice =
//                                                                         //     price;
//                                                                         productPrice = double.parse(widget
//                                                                             .itemProduct
//                                                                             .productAttribute[index]
//                                                                             .productPrice
//                                                                             .toString());
//                                                                         colorchange = double.parse(widget
//                                                                             .itemProduct
//                                                                             .productAttribute[index]
//                                                                             .productPrice
//                                                                             .toString());
//                                                                         // print("ColorChange..." +
//                                                                         //     colorchange.toString());

//                                                                         print("Index...1.." +
//                                                                             productPrice.toString());
//                                                                         // colorchange =
//                                                                         //     true;
//                                                                         // print("Index...1.." +
//                                                                         //     colorchange
//                                                                         //         .toString());
//                                                                       });
//                                                                     },
//                                                                     child:
//                                                                         Padding(
//                                                                       padding:
//                                                                           const EdgeInsets.all(
//                                                                               8.0),
//                                                                       child:
//                                                                           Container(
//                                                                         padding:
//                                                                             EdgeInsets.all(MediaQuery.of(context).size.width *
//                                                                                 0.02),
//                                                                         // height:
//                                                                         //     MediaQuery.of(context)
//                                                                         //         .size
//                                                                         //         .width,
//                                                                         decoration:
//                                                                             BoxDecoration(boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: double.parse(widget.itemProduct.productAttribute[index].productPrice.toString()) == colorchange ? Colors.red.withOpacity(0.2) : Colors.transparent,
//                                                                               blurRadius: 2.0)
//                                                                         ], border: Border.all(color: Colors.grey)),
//                                                                         child:
//                                                                             Column(
//                                                                           crossAxisAlignment:
//                                                                               CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Text(widget.itemProduct.productAttribute[index].name.toString(),
//                                                                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                                                                             // Text("dd"),
//                                                                             Divider(
//                                                                               thickness: 2,
//                                                                               color: Colors.grey,
//                                                                             ),
//                                                                             Text(
//                                                                               "\u20B9 ${widget.itemProduct.productAttribute[index].productPrice.toString()}",
//                                                                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04),
//                                                                             ),
//                                                                             Text(
//                                                                               "\u20B9 ${widget.itemProduct.productAttribute[index].productRegularPrice.toString()}",
//                                                                               style: TextStyle(color: Colors.grey, fontSize: MediaQuery.of(context).size.width * 0.04, decoration: TextDecoration.lineThrough),
//                                                                             )
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 })
//                                                             : ListView.builder(
//                                                                 scrollDirection: Axis
//                                                                     .horizontal,
//                                                                 shrinkWrap:
//                                                                     true,
//                                                                 itemCount: widget
//                                                                     .productdata
//                                                                     .productAttribute
//                                                                     .length,
//                                                                 itemBuilder:
//                                                                     (context,
//                                                                         int index) {
//                                                                   return InkWell(
//                                                                     onTap: () {
//                                                                       print("Index..." +
//                                                                           index
//                                                                               .toString());
//                                                                       print("qnt..." +
//                                                                           quantityController
//                                                                               .text
//                                                                               .toString());

//                                                                       //widget.itemProduct.
//                                                                       showAddToCArt(
//                                                                           widget
//                                                                               .productdata
//                                                                               .productAttribute[
//                                                                                   index]
//                                                                               .name
//                                                                               .toString(),
//                                                                           index,
//                                                                           double.parse(widget
//                                                                               .productdata
//                                                                               .productAttribute[index]
//                                                                               .productPrice
//                                                                               .toString()));
//                                                                       setState(
//                                                                           () {
//                                                                         if (quantityController.text.toString() ==
//                                                                             "0") {
//                                                                           price = double.parse(widget
//                                                                               .productdata
//                                                                               .productAttribute[index]
//                                                                               .productPrice
//                                                                               .toString());
//                                                                         } else {
//                                                                           price =
//                                                                               double.parse(widget.productdata.productAttribute[index].productPrice.toString()) * int.parse(quantityController.text);
//                                                                         }
//                                                                         weightIndex =
//                                                                             index;
//                                                                         // productPrice =
//                                                                         //     price;
//                                                                         productPrice = double.parse(widget
//                                                                             .productdata
//                                                                             .productAttribute[index]
//                                                                             .productPrice
//                                                                             .toString());
//                                                                         colorchange = double.parse(widget
//                                                                             .productdata
//                                                                             .productAttribute[index]
//                                                                             .productPrice
//                                                                             .toString());
//                                                                         print("ColorChange..." +
//                                                                             colorchange.toString());
//                                                                         print("Index...1.." +
//                                                                             productPrice.toString());
//                                                                         // colorchange =
//                                                                         //     true;
//                                                                         // print("Index...1.." +
//                                                                         //     colorchange
//                                                                         //         .toString());
//                                                                       });
//                                                                     },
//                                                                     child:
//                                                                         Padding(
//                                                                       padding:
//                                                                           const EdgeInsets.all(
//                                                                               8.0),
//                                                                       child:
//                                                                           Container(
//                                                                         padding:
//                                                                             EdgeInsets.all(MediaQuery.of(context).size.width *
//                                                                                 0.02),
//                                                                         // height:
//                                                                         //     MediaQuery.of(context)
//                                                                         //         .size
//                                                                         //         .width,
//                                                                         decoration:
//                                                                             BoxDecoration(boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: double.parse(widget.productdata.productAttribute[index].productPrice.toString()) == colorchange ? Colors.red.withOpacity(0.2) : Colors.transparent,
//                                                                               blurRadius: 2.0)
//                                                                         ], border: Border.all(color: Colors.grey)),
//                                                                         child:
//                                                                             Column(
//                                                                           crossAxisAlignment:
//                                                                               CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Text(widget.productdata.productAttribute[index].name.toString(),
//                                                                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                                                                             // Text("dd"),
//                                                                             Divider(
//                                                                               thickness: 2,
//                                                                               color: Colors.grey,
//                                                                             ),
//                                                                             Text(
//                                                                               "\u20B9 ${widget.productdata.productAttribute[index].productPrice.toString()}",
//                                                                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04),
//                                                                             ),
//                                                                             Text(
//                                                                               "\u20B9 ${widget.productdata.productAttribute[index].productRegularPrice.toString()}",
//                                                                               style: TextStyle(color: Colors.grey, fontSize: MediaQuery.of(context).size.width * 0.04, decoration: TextDecoration.lineThrough),
//                                                                             )
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 }),
//                                                   ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Container(
// // height: 150,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text("Description",
//                                                   style: TextStyle(
//                                                       fontSize:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width *
//                                                               0.05,
//                                                       fontWeight:
//                                                           FontWeight.bold)),
//                                               SizedBox(
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.02,
//                                               ),
//                                               Text(
//                                                 _isSearch != true
//                                                     ? itemProduct
//                                                         .productDescription
//                                                     : widget.productdata
//                                                         .productDescription,
//                                                 style: TextStyle(
//                                                   color: AppColors
//                                                       .categoryTextColor,
//                                                   fontSize: 14,
//                                                   height: 1.5,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               // Text(
//                                               //   "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like",
//                                               //   style: TextStyle(
//                                               //       color: AppColors.categoryTextColor,
//                                               //       fontSize: 16,
//                                               //       fontWeight: FontWeight.w400,
//                                               //       fontFamily: "Philosopher"),
//                                               // ),
//                                               SizedBox(
//                                                 height: 50,
//                                               ),
//                                               // Center(
//                                               //   child: Container(
//                                               //     width:
//                                               //         MediaQuery.of(context).size.width - 100,
//                                               //     height: 45,
//                                               //     decoration: BoxDecoration(
//                                               //       color: Colors.black,
//                                               //       borderRadius:
//                                               //           BorderRadius.all(Radius.circular(9)),
//                                               //     ),
//                                               //     child: !_isAddedToCart
//                                               //         ? TextButton(
//                                               //             onPressed: () {
//                                               //               _handleAddCart(itemProduct);
//                                               //             },
//                                               //             child: Text(
//                                               //               'Add to cart'.toUpperCase(),
//                                               //               style: TextStyle(
//                                               //                 color: Colors.white,
//                                               //               ),
//                                               //             ))
//                                               //         : TextButton(
//                                               //             onPressed: () {
//                                               //               Navigator.push(
//                                               //                 context,
//                                               //                 MaterialPageRoute(
//                                               //                   builder: (context) =>
//                                               //                       ShoppingCartScreen(),
//                                               //                 ),
//                                               //               );
//                                               //             },
//                                               //             child: Text(
//                                               //               'Go to cart'.toUpperCase(),
//                                               //               style: TextStyle(
//                                               //                 color: Colors.white,
//                                               //               ),
//                                               //             ),
//                                               //           ),
//                                               //   ),
//                                               // ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               isUserLoggedIn
//                                                   ? Column(
//                                                       children: [
//                                                         Container(
//                                                           height: 1,
//                                                           color:
//                                                               Color(0XFFCECDCD),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         )
//                                                       ],
//                                                     )
//                                                   : Container(),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 70,
//                   color: Colors.black,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height,
//                         width: MediaQuery.of(context).size.width / 2,
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ReviewScreen(
//                                         productId: _isSearch != true
//                                             ? widget.itemProduct.productId
//                                             : widget.productdata.productId,
//                                         productTitle: _isSearch != true
//                                             ? itemProduct.productTitle
//                                             : widget.productdata.productTitle,
//                                         // itemProduct: _isSearch != true ? widget.productdata:itemProduct,
//                                         // itemProduct: _isSearch != true ? widget.productdata:itemProduct,
//                                         isUserLoggedIn: isUserLoggedIn,
//                                       )),
//                             );
//                           },
//                           child: Text(
//                             'Reviews'.toUpperCase(),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: MediaQuery.of(context).size.height,
//                         width: 0.5,
//                         color: Colors.white,
//                       ),
//                       Expanded(
//                         child: Container(
//                           height: MediaQuery.of(context).size.height,
//                           child: Center(
//                             child: _isAddedToCart
//                                 ? Stack(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             height: 70,
//                                             width: 50,
//                                             child: IconButton(
//                                               icon: Image.asset(
//                                                   'images/ic_minus.png'),
//                                               onPressed: () {
//                                                 DcrBtn();
//                                               },
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               height: 70,
//                                               alignment: Alignment.center,
//                                               child: TextField(
//                                                 enableInteractiveSelection:
//                                                     false,
//                                                 keyboardType:
//                                                     TextInputType.number,
//                                                 inputFormatters: <
//                                                     TextInputFormatter>[
//                                                   FilteringTextInputFormatter
//                                                       .allow(
//                                                     RegExp(r'[0-9]'),
//                                                   ),
//                                                 ],
//                                                 controller: quantityController,
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   isDense: true,
//                                                   contentPadding:
//                                                       EdgeInsets.all(10),
//                                                   filled: true,
//                                                   fillColor: Color(0XFFF8F8F8),
//                                                   focusedBorder:
//                                                       UnderlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color: Color(0XFFD4DFE8),
//                                                       width: 2,
//                                                     ),
//                                                   ),
//                                                   hintText: "Qantity",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                                 onSubmitted: (value) {
//                                                   debugPrint(
//                                                       "Value in  input box $value");
//                                                   if (value == "" ||
//                                                       value == null) {
//                                                     showCustomToast(
//                                                         "Please input quantity");
//                                                   } else {
//                                                     if (int.parse(value) > 0) {
//                                                       _addtocartBtnPressed();
//                                                     } else {
//                                                       showCustomToast(
//                                                           "Please input quantity");
//                                                     }
//                                                   }
//                                                 },
//                                                 onChanged: (value) {
//                                                   // print("Price..." +
//                                                   //     value.toString());
//                                                   if (value != "") {
//                                                     setState(() {
//                                                       _itemCount =
//                                                           int.parse(value);
//                                                       if (value == "") {
//                                                         price =
//                                                             productPrice * 1;
//                                                       }

//                                                       if (_itemCount >= 1) {
//                                                         price = productPrice *
//                                                             _itemCount;
//                                                       } else if (_itemCount ==
//                                                           0) {
//                                                         price =
//                                                             productPrice * 1;
//                                                       } else {
//                                                         price =
//                                                             productPrice * 1;
//                                                       }
//                                                     });
//                                                   } else {
//                                                     debugPrint("Blank");
//                                                     setState(() {
//                                                       price = productPrice * 1;
//                                                       _itemCount = 0;
//                                                     });
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           Container(
//                                             height: 70,
//                                             width: 50,
//                                             child: IconButton(
//                                               icon: Image.asset(
//                                                   'images/ic_plus.png'),
//                                               onPressed: () {
//                                                 // print("klkl..." +
//                                                 //     price.toString());
//                                                 // setState(() {
//                                                 //   // productPrice = price;
//                                                 //   // print("productPrice..." +
//                                                 //   //     productPrice.toString());
//                                                 // });
//                                                 IncrBtn();
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       _callingUpdateApi
//                                           ? Center(
//                                               child: Container(
//                                                 margin: EdgeInsets.only(
//                                                   top: 15,
//                                                 ),
//                                                 height: 20,
//                                                 width: 20,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   valueColor:
//                                                       new AlwaysStoppedAnimation<
//                                                               Color>(
//                                                           Colors.blueGrey),
//                                                   strokeWidth: 2,
//                                                 ),
//                                               ),
//                                             )
//                                           : Container(),
//                                     ],
//                                   )
//                                 : InkWell(
//                                     onTap: () {
//                                       print("Add to Cart");
//                                       _addtocartBtnPressed();
//                                     },
//                                     child: Container(
//                                       child: Center(
//                                         child: Text(
//                                           "Add To Cart".toUpperCase(),
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   IncrBtn() {
//     // setState(() => _itemCount++);
//     // priceCart=price*_itemCount;
//     // print("Product_price..." + productPrice.toString());
//     print("Product_price1..." + productPrice.toString());
//     setState(() {
//       _itemCount++;
//       quantityController.text = "$_itemCount";
//       //price = price * _itemCount;
//       price = productPrice * _itemCount;

//       quantityController.selection = TextSelection.fromPosition(
//           TextPosition(offset: quantityController.text.length));
//     });
//     _addtocartBtnPressed();
//   }

//   DcrBtn() {
//     setState(() {
//       _itemCount <= 0 ? _itemCount = 0 : _itemCount--;
//       _itemCount == 0
//           ? quantityController.clear()
//           : quantityController.text = "$_itemCount";
//       price = _itemCount > 0 ? productPrice * _itemCount : productPrice * 1;

//       quantityController.selection = TextSelection.fromPosition(
//           TextPosition(offset: quantityController.text.length));
//     });

//     _addtocartBtnPressed();
//   }

//   setQuantity() {
//     showCustomToast("${quantityController.text}");
//     setState(() {});
//   }

//   void showAddToCArt(String size, int index, double productProce) {
//     // print("list price...");
//     print("productSize..." + size.toString());
//     print("productSize..." + productProce.toString());
//     print("productSize...0" + Variables.itemCount.toString());
//     // print("list price..." + arrCartProducts.length.toString());
//     String proId;
//     if (_isSearch) {
//       proId = widget.productdata.productId;
//     } else {
//       proId = widget.itemProduct.productId;
//     }
//     if (Variables.itemCount == 0) {
//       print("productSizee..." + productProce.toString());
//       setState(() {
//         weightIndex = index;
//         price = productProce;
//         colorchange = productProce;
//         _handleFetchCart();
//       });
//     } else {
//       if (arrCartProducts.length > 0) {
//         for (int i = 0; i < arrCartProducts.length; i++) {
//           if (proId == arrCartProducts[i]['product_id'].toString()) {
//             if (size == arrCartProducts[i]['size'].toString()) {
//               setState(() {
//                 quantityController.text = arrCartProducts[i]['qty'];
//               });
//             } else {
//               setState(() {
//                 setState(() {
//                   quantityController.text = "1";
//                 });
//               });
//             }
//           } else {
//             setState(() {
//               quantityController.text = "1";
//             });
//           }
//         }
//       }
//       // else {
//       //   print("opopop.....");
//       //   print("productSize...0" + size.toString());
//       //   setState(() {
//       //     price = productProce;
//       //     colorchange = productProce;
//       //   });
//       // }
//       setState(() {
//         weightIndex = index;
//         _handleFetchCart();
//       });
//     }

//     // var productId1;
//     // if (arrCartProducts.length > 0) {
//     //   for (int i = 0; i < arrCartProducts.length; i++) {
//     //     if (_isSearch) {
//     //       productId1 = widget.productdata.productId;
//     //       print("list price..serach." + productId1.toString());
//     //     } else {
//     //       productId1 = widget.itemProduct.productId;
//     //       print("list price..." + productId1.toString());
//     //       //print("list price..." + arrCartProducts[i].toString());
//     //     }
//     //     if (productId1 == arrCartProducts[i]['product_id'].toString()) {
//     //       print("list price...00.." + arrCartProducts[i]['size'].toString());
//     //       if (size == arrCartProducts[i]['size'].toString()) {
//     //         print("list price...0." + arrCartProducts[i]['size'].toString());

//     //         setState(() {
//     //           _isAddedToCart = true;
//     //           rowId = int.parse(arrCartProducts[i]['row_id'].toString());
//     //           print("row id list price...0." +
//     //               arrCartProducts[i]['row_id'].toString());
//     //           _itemCount = int.parse(arrCartProducts[i]['qty'].toString());
//     //           quantityController.text = "$_itemCount";
//     //           price = productPrice * _itemCount;
//     //           weightIndex = index;
//     //           //_handleFetchCart();

//     //           if (quantityController.text.toString() == "0") {
//     //             price = double.parse(widget
//     //                 .itemProduct.productAttribute[index].productPrice
//     //                 .toString());
//     //           } else {
//     //             price = double.parse(widget
//     //                     .itemProduct.productAttribute[index].productPrice
//     //                     .toString()) *
//     //                 int.parse(quantityController.text);
//     //           }

//     //           productPrice = double.parse(widget
//     //               .itemProduct.productAttribute[index].productPrice
//     //               .toString());
//     //           print("price..." + price.toString());
//     //           print("product price..." + productPrice.toString());
//     //           _handleFetchCart();
//     //         });
//     //       } else {
//     //         print("price..." + _isAddedToCart.toString());
//     //         setState(() {
//     //           _isAddedToCart = false;
//     //           weightIndex = index;
//     //           quantity = 1;
//     //           _itemCount = quantity;
//     //           quantityController.text = "$_itemCount";
//     //           //_handleFetchCart();

//     //           if (quantityController.text.toString() == "0") {
//     //             price = double.parse(widget
//     //                 .itemProduct.productAttribute[index].productPrice
//     //                 .toString());
//     //           } else {
//     //             price = double.parse(widget
//     //                     .itemProduct.productAttribute[index].productPrice
//     //                     .toString()) *
//     //                 int.parse(quantityController.text);
//     //           }

//     //           productPrice = double.parse(widget
//     //               .itemProduct.productAttribute[index].productPrice
//     //               .toString());
//     //           print("price..." + price.toString());
//     //           print("product price..." + productPrice.toString());
//     //           _handleFetchCart();
//     //         });
//     //       }
//     //     }
//     //   }
//     //   setState(() {
//     //     quantity = arrCartProducts.length;
//     //     Variables.itemCount = quantity;
//     //   });
//     // } else {
//     //   setState(() {
//     //     quantityController.text = "$_itemCount";
//     //   });
//     // }
//   }
// }
