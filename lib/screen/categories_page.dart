import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:samanoud_city/ui/category_card.dart';
import 'package:samanoud_city/screen/providers_page.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPage createState() => _CategoriesPage();
}

class _CategoriesPage extends State<CategoriesPage> {
  String user = '';
  String searchWord = '';
  Widget processing = Center(
      child: CircularProgressIndicator(
    backgroundColor: Colors.deepPurple,
  ));
  Widget searching = Text('');

  retriveUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      user = sharedPreferences.getString('USER_NAME') ?? 'none';
    });
  }

  Future<List<dynamic>> getAllCategories() async {
    if (await Constants.checkInternet()) {
      if (searchWord == '') {
        http.Response response =
            await http.get(Constants.baseURL + 'getAllCategories');
        if (response.statusCode == 201) {
          return jsonDecode(utf8.decode(response.bodyBytes))['categories'];
        } else {
          return null;
        }
      } else {
        print('object');
        http.Response response = await http.post(
            Constants.baseURL + 'getSpesificCategory',
            body: {'SEARSH_WORD': searchWord});
        if (response.statusCode == 201) {
          return jsonDecode(utf8.decode(response.bodyBytes))['categories'];
        } else {
          processing = Center(
              child: Text(
            'لا يوجد قسم بهذا الاسم',
            style: TextStyle(color: Colors.deepPurple, fontSize: 24),
          ));
          return null;
        }
      }
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
                'لا يوجد اتصال بالانترنت',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, color: Colors.deepPurple),
              )),
          IconButton(
            onPressed: () {
              setState(() {
                getAllCategories();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retriveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .35,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "مرحباًُ بكم فى \n سوق نود",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 25, left: 25),
                  margin: EdgeInsets.symmetric(vertical: 20),
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
                    onChanged: (value) async {
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
                      await getAllCategories();
                      Timer(Duration(milliseconds: 100), () {
                        setState(() {
                          searching = Text('');
                        });
                      });
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: getAllCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          addAutomaticKeepAlives: false,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> cat =
                                snapshot.data[index].cast<String, dynamic>();
                            return CategoryCard(
                              title: cat['CATEGORY_NAME'],
                              svgSrc: Constants.baseImageURL +
                                  cat['CATEGORY_IMAGE'],
                              Press: () {
                                Navigator.push(this.context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProvidersPage(
                                      cat['CATEGORY_ID'],
                                      cat['CATEGORY_NAME'],
                                      cat['CATEGORY_IMAGE']);
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
      ],
    );
  }
}
