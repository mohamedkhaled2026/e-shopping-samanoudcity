import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:samanoud_city/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  Widget processing = Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.deepPurple,
      ));
  int userID;
  Future<List<dynamic>> getUserOrders() async {
    if(await Constants.checkInternet()) {
      await retriveUserInfo();
      http.Response response =
      await http.post(Constants.baseURL + 'getOrder', body: {
        'USER_ID': userID.toString(),
      });
      print(response.statusCode);
      if (response.statusCode == 201) {
        return jsonDecode(utf8.decode(response.bodyBytes))['order'];
      } else {
        processing = Center(
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
                    child: Text('لا يوجد طلبات',
                      textAlign:TextAlign.center,
                      style: TextStyle(fontSize: 26,
                          color: Colors.deepPurple),
                    )),
              ],
            ));
      }
    }else{
      processing = Center(
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
                    'لا يوجد اتصال بالانترنت',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, color: Colors.deepPurple),
                  )),
              IconButton(
                onPressed: () {
                  setState(() {
                    getUserOrders();
                    processing = Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.deepPurple,
                        ));
                  });
                },
                icon: Icon(
                  Icons.refresh,
                  size: 35,
                  color: Colors.deepPurple,
                ),
              )
            ],
          ));
    }
  }

  retriveUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userID = sharedPreferences.getInt('USER_ID') ?? -1;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(getUserOrders());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> order =
                      snapshot.data[index].cast<String, dynamic>();
                  return Container(
                    //start of code
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.deepPurple,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                order['USER_NAME'].toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Cairo",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        //head of order
                        Container(
                          color: Colors.grey,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Colors.black26),bottom: BorderSide(color: Colors.black26)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                    child: Text(
                                      "الاجمالي",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Colors.black26),bottom: BorderSide(color: Colors.black26)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                    child: Text(
                                      "السعر",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Colors.black26),bottom: BorderSide(color: Colors.black26)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                    child: Text(
                                      "الكمية",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Colors.black26),bottom: BorderSide(color: Colors.black26)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                    child: Text(
                                      "المنتج",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //card adresses
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: jsonDecode(order['USER_ORDER']).length,
                            itemBuilder: (context, index1) {
                              List<dynamic> orderList =
                              jsonDecode(order['USER_ORDER']);
                              Map<String, dynamic> orderData = orderList[index1];
                              double orderItemPrice = orderData['PRODUCT_PRICE'] *
                                  orderData['PRODUCT_QUANTITY'];
                              return Column(
                                children: <Widget>[

                                  Container(
                                    child: //head of order

                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(color: Colors.grey),bottom: BorderSide(color: Colors.grey)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                              child: Text(
                                                orderItemPrice.toString()+' جـ',
                                                textAlign: TextAlign.center,
                                                textDirection: TextDirection.rtl,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Cairo",
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(color: Colors.grey),bottom: BorderSide(color: Colors.grey)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                              child: Text(
                                                orderData['PRODUCT_PRICE'].toString()+' جـ',
                                                textAlign: TextAlign.center,
                                                textDirection: TextDirection.rtl,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Cairo",
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(color: Colors.grey),bottom: BorderSide(color: Colors.grey)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                              child: Text(
                                                orderData['PRODUCT_QUANTITY'].toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Cairo",
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(color: Colors.grey),bottom: BorderSide(color: Colors.grey)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                              child: Text(
                                                orderData['PRODUCT_ID'].toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Cairo",
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Divider(height: 2,thickness: 2,),
                                ],
                              );
                            }),
                        Container(
                          child: Row(
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Colors.grey),bottom:  BorderSide(color: Colors.grey)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                    child: Text(
                                      order['TOTAL_PRICE'].toDouble().toString()+' جـ',
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Colors.grey)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                    child: Text(
                                      "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return processing;
          }
        },
      ),
    );
  }
}



