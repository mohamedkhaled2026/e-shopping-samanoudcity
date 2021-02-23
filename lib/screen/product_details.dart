import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:samanoud_city/utils/SQLHelper.dart';
import 'package:samanoud_city/model/Cart.dart';

class ProductDetails extends StatefulWidget {
  Map<String, dynamic> product;
  ProductDetails(this.product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic> product;
  FlutterToast flutterToast;
  var db = SQLHELPER();
  int quantity = 1;
  void showToast(String message,Color color){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color.withOpacity(.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),),
        ],
      ),
    );
    flutterToast.showToast(child: toast,gravity: ToastGravity.BOTTOM,toastDuration: Duration(seconds: 3));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
    flutterToast = FlutterToast(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Hero(
              tag: "Name",
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.network(
                          Constants.baseImageURL+product['PRODUCT_IMAGE'],
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 550,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 40,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.deepPurple),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 40,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.deepPurple),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.pen,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    topLeft: Radius.circular(14)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "${product['PRODUCT_PRICE']}جـ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Cairo",
                              color: kTextColor,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Text(
                          product['PRODUCT_NAME'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Cairo",
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "نوع المُنتج",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Cairo",
                        color: Color(0xFF9E9E9E),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      product['PRODUCT_DESCRIPTION'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Cairo",
                        color: Color(0xFF646363),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            if(!(quantity <= 1)) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 28,
                            width: 28,
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                              fontFamily: "Cairo"),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 28,
                            width: 28,
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async{
          var db = SQLHELPER();
          CartProduct cartProduct = CartProduct.fromMap(widget.product);
          cartProduct.setProductQuantity(quantity);
          print(cartProduct.productQuantity);
          int r = await db.addProductToCart(cartProduct);
          if(r != -2){
            showToast('تم الاضاقة بنجاح',Colors.green);
          }else{
            showToast('تمت الاضاقة مسبقا',Colors.red);
          }
          List<dynamic> l = await db.getAllProducts();
          print(l);

        },
        child: Container(
          height: 80,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 18, top: 18),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "أضف إلى السلة",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

//home: Scaffold(
//
//appBar: AppBar(
//actions: <Widget>[
//IconButton(
//icon: Icon(Icons.shopping_cart,size: 30,color: Colors.white,),
//onPressed: () async{
//showModalBottomSheet(context: context, builder: (BuildContext context){
//return StatefulBuilder(builder: (BuildContext context ,StateSetter mystate){
//return Container(
//child: Center(
//child: Column(
//children: <Widget>[
//Row(
//children: <Widget>[
//IconButton(icon: Icon(Icons.add),onPressed: (){
//mystate((){
//quantity++;
//});
//},),
//Text(quantity.toString()),
//IconButton(icon: Icon(Icons.remove),onPressed: (){
//mystate((){
//quantity--;
//});
//},)
//],
//),
//IconButton(icon: Icon(Icons.add_shopping_cart),onPressed: () async{
//var db = SQLHELPER();
//CartProduct cartProduct = CartProduct.fromMap(widget.product);
//cartProduct.setProductQuantity(quantity);
//print(cartProduct.productQuantity);
//int r = await db.addProductToCart(cartProduct);
//List<dynamic> l = await db.getAllProducts();
//print(l);
//Navigator.pop(context);
//
//},)
//],
//),
//
//),
//);
//});
//});
//},
//)
//],
//title: Text(
//'Souqنoud',
//textAlign: TextAlign.center,
//),
//),
//body: SingleChildScrollView(
//child: Container(
//child: Column(
//children: <Widget>[
//Image.network(Constants.baseImageURL+'electric-device.png'),
//Text(product['PRODUCT_NAME']),
//Text(product['PRODUCT_DESCRIPTION']),
//Text(product['PRODUCT_PRICE'].toString()+'جنيه'),
//],
//),
//),
//),
//),
