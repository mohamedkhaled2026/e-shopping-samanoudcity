import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:samanoud_city/ui/cart_card.dart';
import 'package:samanoud_city/utils/SQLHelper.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPage createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  var db = SQLHELPER();
  int quantity = 1;
  int userID;
  int providerID;
  String userOrder;
  double totalPrice;
  bool processing = false;
  Constants constants = Constants();
  Future<String> addOrder(
      int userID, int providerID, String userOrder, double totalPrice) async {
    if (await Constants.checkInternet()) {
      setState(() {
        processing = true;
      });
      var response = await http.post(Constants.baseURL + 'addOrder', body: {
        'USER_ID': userID.toString(),
        'PROVIDER_ID': providerID.toString(),
        'USER_ORDER': userOrder,
        'TOTAL_PRICE': totalPrice.toString()
      });
      if (response.statusCode != 500) {
        if (jsonDecode(response.body)['error'] == 'false') {
          setState(() {
            processing = false;
          });
          constants.showToast(context, 'تم طلب الاوردر', Colors.red);
          return jsonDecode(response.body)['message'];
        } else {
          setState(() {
            processing = false;
          });
          return jsonDecode(response.body)['message'];
        }
      } else {
        constants.showToast(
            context, 'خطأ في الخادم حاو في وقت اخر', Colors.red);
      }
    } else {
      constants.showToast(context, 'لا يوجد اتصال بالانترنت', Colors.red);
    }
    setState(() {
      processing = false;
    });
  }

  retriveUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userID = sharedPreferences.getInt('USER_ID') ?? -1;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ModalProgressHUD(
      inAsyncCall: processing,
      child: SafeArea(
        child: Container(
          color: kBackgroundWhite,
          child: FutureBuilder<List<dynamic>>(
            future: db.getProviders(),
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          margin: EdgeInsets.only(right: 5, left: 5),
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: Colors.deepPurple,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  snapshot.data[index]
                                      .cast<String, dynamic>()['PROVIDER_NAME'],
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.white)),
                              Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: Colors.amber,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    await retriveUserInfo();
                                    providerID = snapshot.data[index]
                                        .cast<String, dynamic>()['PROVIDER_ID'];
                                    userOrder = jsonEncode((await db
                                        .getProductsForSpecificProviderForOrder(
                                            providerID)));
                                    totalPrice = await db
                                        .getTotalPriceForProvider(providerID);
                                    String r = await addOrder(userID,
                                        providerID, userOrder, totalPrice);
                                    if (r == 'order added successfully') {
                                      db.deleteProvider(providerID);
                                      setState(() {
                                        db.getProviders();
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.white,
                                      ),
                                      Text('اطلب',
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              fontFamily: "Cairo"))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 250,
                          child: FutureBuilder<List<dynamic>>(
                            future: db.getProductsForSpecificProvider(snapshot
                                .data[index]
                                .cast<String, dynamic>()['PROVIDER_ID']),
                            builder: (context, snapshot) {
                              bool isNull = false;
                              isNull = snapshot.hasData;
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map<String, dynamic> cartProduct = snapshot
                                        .data[index]
                                        .cast<String, dynamic>();
                                    return Container(
                                        margin: EdgeInsets.all(5),
                                        child: CartCard(
                                          image: cartProduct['PRODUCT_IMAGE'],
                                          title: cartProduct['PRODUCT_NAME'],
                                          price: cartProduct['PRODUCT_PRICE'],
                                          quantity:
                                              cartProduct['PRODUCT_QUANTITY'],
                                          deletePress: () {
                                            db.deleteProduct(
                                                cartProduct['PRODUCT_ID']);
                                            setState(() {
                                              db.getProviders();
                                            });
                                          },
                                          updatePress: () {
                                            quantity =
                                                cartProduct['PRODUCT_QUANTITY'];
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.grey[600],
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter mystate) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      height: 200,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    mystate(() {
                                                                      quantity++;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                quantity
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Cairo',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    if (!(quantity <=
                                                                        1)) {
                                                                      mystate(
                                                                          () {
                                                                        quantity--;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              db.updateProduct(
                                                                  cartProduct[
                                                                      'PRODUCT_ID'],
                                                                  quantity);
                                                              setState(() {
                                                                db.getProviders();
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              height: 60,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom: 5,
                                                                      top: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .deepPurple,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            14)),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "أضف إلى السلة",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "Cairo",
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .shopping_cart,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                                });
                                          },
                                        ));
                                  },
                                  itemCount: snapshot.data.length,
                                );
                              } else {
                                if (!isNull) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ));
                                } else {
                                  return Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                          'لا يوجد منتجات داخل سلتك الخاصة'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ]);
                    },
                  );
                } else {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 100,
                        color: Colors.deepPurple,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'لا يوجد منتجات في السلة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26, color: Colors.deepPurple),
                          )),
                    ],
                  ));
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
