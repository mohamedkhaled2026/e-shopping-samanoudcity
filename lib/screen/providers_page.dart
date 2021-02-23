import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:samanoud_city/screen/provider_page.dart';
import 'package:samanoud_city/ui/providers_card.dart';
import 'package:samanoud_city/utils/constants.dart';

class ProvidersPage extends StatefulWidget {
  final int categoryID;
  final String categoryName;
  final String categoryImage;
  ProvidersPage(
    this.categoryID,
    this.categoryName,
    this.categoryImage,
  );
  @override
  _ProvidersPageState createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  String searchWord = '';
  Widget searching = Text('');
  Widget processing = Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.deepPurple,
      ));




  Future<List<dynamic>> getAllpROVIDERS() async {
    if (await Constants.checkInternet()) {
      if (searchWord == '') {
        http.Response response = await http
            .get(Constants.baseURL + 'getProviders/${widget.categoryID}');
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
                        'لا يوجد محلات متاحة الان',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26, color: Colors.deepPurple),
                      )),
                ],
              ));
          return null;
        }
      } else {
        http.Response response = await http.post(
            Constants.baseURL + 'getSpecificProvidersForSpecificCategory',
            body: {
              'CATEGORY_ID': widget.categoryID.toString(),
              'SEARSH_WORD': searchWord
            });
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
                        'لا يوجد محل بهذا الاسم',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26, color: Colors.deepPurple),
                      )),
                ],
              ));
          return null;
        }
      }
    }else{
      setState(() {
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
                      getAllpROVIDERS();
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
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                //_______________ shop Image ______________

                Container(
                  height: size.height * .40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(17),
                        bottomRight: Radius.circular(17)),
                    color: Colors.deepPurple,
//                    image: DecorationImage(image: NetworkImage(Constants.baseImageURL+widget.categoryPanner),
//                        fit: BoxFit.cover),
                  ),
//                  child: Container(
//                    alignment: Alignment.bottomCenter,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(20),
//                      color: Colors.black.withOpacity(0.2),
//                    ),
//                  ),
                ),
                Positioned(
                  left: 20,
                  top: 40,
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
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Text(
                                widget.categoryName,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo",
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SvgPicture.network(
                                Constants.baseImageURL + widget.categoryImage,
                                height: 100,
                                width: 80,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25, left: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29.5),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              icon: searching,
                              suffixIcon: Icon(
                                Icons.search,
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 16),
                              hintText: "بحث",
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            onChanged: (value) {
                              setState(() {
                                searching = SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                );
                              });
                              searchWord = value;
                              setState(() {
                                getAllpROVIDERS();
                              });
                              Timer(Duration(milliseconds: 100), () {
                                setState(() {
                                  searching = Text('');
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: getAllpROVIDERS(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 2.2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> cat =
                            snapshot.data[index].cast<String, dynamic>();
                        return ProvidersCard(
                          title: cat['USER_NAME'],
                          img: Constants.baseImageURL + cat['PROVIDER_IMAGE'],
                          Press: () {
                            Navigator.push(this.context,
                                MaterialPageRoute(builder: (context) {
                              return ProviderPage(cat);
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
    );
  }
}
