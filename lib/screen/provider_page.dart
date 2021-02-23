import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samanoud_city/screen/product_details.dart';
import 'package:samanoud_city/ui/home_card.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProviderPage extends StatefulWidget {
  Map<String, dynamic> provider;
  ProviderPage(this.provider);
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  Map<String, dynamic> provider;
  Widget processing = Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.deepPurple,
      ));
  Future<List<dynamic>> getProviderProducts() async {
    if(await Constants.checkInternet()) {
      http.Response response = await http
          .get(Constants.baseURL + 'getProducts/${provider['PROVIDER_ID']}');
      print(response.statusCode);
      if (response.statusCode == 201) {
        return jsonDecode(utf8.decode(response.bodyBytes))['providers'];
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
                    child: Text(
                      'لا يوجد منتجات مُتاحة لهذا المحل بعد',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, color: Colors.deepPurple),
                    )),
              ],
            ));
        return null;
      }
    }else{
      processing =  Center(
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
                    getProviderProducts();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                        child: Image.network(Constants.baseImageURL + 'shirt.jpg',height: 300,fit: BoxFit.cover,),
                    ),
                    Positioned(
                      left: 20,
                      top: 30,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
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
                Text(provider['USER_NAME'],style: TextStyle(
                  color: kTextColor,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),),
                Text(provider['PROVIDER_DESCRIPTION'],
                  style: TextStyle(
                    color: kTextColor,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(provider['USER_ADDRESS'],
                  style: TextStyle(
                  color: kTextColor,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
                Container(
                  padding: EdgeInsets.all(15),
                  child: FutureBuilder<List<dynamic>>(
                    future: getProviderProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            childAspectRatio: .7,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> product =
                                snapshot.data[index].cast<String, dynamic>();

                            return HomeCard(
                              prod_name: product['PRODUCT_NAME'],
                              prod_price: product['PRODUCT_PRICE'].toString(),
                              prod_picture: Constants.baseImageURL +
                                  product['PRODUCT_IMAGE'],
                              press: () {
                                product['PROVIDER_NAME'] = provider['USER_NAME'];
                                Navigator.push(this.context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProductDetails(product);
                                }));
                              },
                            );
                          },
                          itemCount: snapshot.data.length,
                        );
                      } else {
                        return processing;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
