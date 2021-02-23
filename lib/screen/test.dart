import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samanoud_city/screen/product_details.dart';
import 'package:samanoud_city/ui/home_card.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSpace extends StatefulWidget {
  @override
  _ProviderSpaceState createState() => _ProviderSpaceState();
}

class _ProviderSpaceState extends State<ProviderSpace> {
  int providerID;
  Widget processing = Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.deepPurple,
      ));
  Future<List<dynamic>> getProviderProducts() async {
    if(await Constants.checkInternet()) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      providerID = sharedPreferences.getInt('PROVIDER_ID') ?? -1;
      http.Response response = await http
          .get(Constants.baseURL + 'getProducts/${providerID}');
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

  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(

      child: Container(
        color: Colors.white,
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
    );
  }
  Positioned buildPositionedTop(double mdw){
    return Positioned(
      child: Transform.scale(
        scale: 1.5,
        child: Transform.translate(
          offset: Offset(0,-mdw/2),
          child: Container(
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(mdw),
              color: Colors.deepPurple[800],
            ),
          ),
        ),
      ),
    );
  }
}
