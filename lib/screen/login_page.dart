import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:samanoud_city/screen/provider_home_page.dart';
import 'package:samanoud_city/screen/welcome_screen.dart';
import 'package:samanoud_city/ui/round_Button.dart';
import 'package:http/http.dart' as http;
import 'package:samanoud_city/utils/constants.dart';
import 'home_page.dart';
import '../ui/round_Button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPage_State createState() => LoginPage_State();
}

class LoginPage_State extends State<LoginPage> {
  bool processing = false;
  int userType = -1;
  Constants constants = Constants();
  String userPhone = '',userPassword = '';
  Future<String> logIN(String userPhone,String userPassword) async{
    if(await Constants.checkInternet()) {
      var response = await http.post(Constants.baseURL + 'logIn',
          body: {'USER_PHONE': userPhone, 'USER_PASSWORD': userPassword});
      if (response.statusCode != 500) {
        print(jsonDecode(response.body)['error']);
        if (jsonDecode(response.body)['error'] == false) {
          print(jsonDecode(response.body)['message']);
          return jsonDecode(response.body)['message'];
        } else {
          if(jsonDecode(response.body)['message'] == 'invalid user') {
            constants.showToast(context, 'رقم الهاتف خاطئ', Colors.red);
          }else{
            constants.showToast(context,'كلمة مرور غير صحيحة', Colors.red);
          }
        }
      } else {
        constants.showToast(context,'خطأ في الخادم حاو في وقت اخر', Colors.red);
      }
    }else{

      constants.showToast(context, 'لا يوجد اتصال بالانترنت', Colors.red);
    }
    setState(() {
      processing = false;
    });

  }

  Future<Map>getUserInfo(String userPhone) async{

    var response = await http.get(Constants.baseURL+'getUserInfo/$userPhone');
    if(response.statusCode != 500){
      print(jsonDecode(response.body)['error']);
      if(jsonDecode(response.body)['error'] == false){
        print(jsonDecode(utf8.decode(response.bodyBytes)));
        return jsonDecode(utf8.decode(response.bodyBytes));

      }else{
        return jsonDecode(response.body);
      }
    }else{
      Map m = Map();
      m['message'] = 'sever error';
      return m;
    }
  }
  Future<String> storeUserInfo(String userPhone)async{
    Map m = await getUserInfo(userPhone);
    print(m['message']+'jjjjjjjj');
    if(m['message'] == 'user exists') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('USER_ID', m['user']['USER_ID']);
      preferences.setString('USER_PHONE', m['user']['USER_PHONE']);
      preferences.setString('USER_NAME', m['user']['USER_NAME']);
      preferences.setString('USER_ADDRESS', m['user']['USER_ADDRESS']);
      preferences.setInt('USER_TYPE', m['user']['TYPE_ID']);
      preferences.setInt('PROVIDER_ID', m['user']['PROVIDER_ID']);
      preferences.setString('PROVIDER_IMAGE', m['user']['PROVIDER_IMAGE']);
      preferences.setString('PROVIDER_DESCRIPTION', m['user']['PROVIDER_DESCRIPTION']);
      preferences.setString('CATEGORY_NAME', m['user']['CATEGORY_NAME']);
      userType = m['user']['TYPE_ID'];
      return'success';
    }else{
      return 'faild store';
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
    return ModalProgressHUD(
      inAsyncCall: processing,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(

            color: Colors.white,
            child: Stack(
              children: <Widget>[
                buildPositionedTop(size.width),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                      ),
                    ),
                    buildContainerAvatar(size.width),
                    SizedBox(height: 50,),
                    /////////////////////////////////////////////////0
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                              width: size.width/1.2,
                              height: 250,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      spreadRadius: .1,
                                      offset:Offset (1,1),
                                    ),
                                  ]
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'رقم الهاتف',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Cairo',
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          hintText: "قم بإدخال رقم الهاتفـا",
                                          hintStyle: TextStyle(fontFamily: 'Cairo',fontSize: 14),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple[500],
                                                style: BorderStyle.solid,
                                                width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[500],
                                                style: BorderStyle.solid,
                                                width: 1),
                                          ),
                                        ),
                                        onChanged: (String value) {
                                          userPhone = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ///////////////////////////////////////////////
                                    Text(
                                      'كلمة المرور',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        textAlignVertical: TextAlignVertical.bottom ,
                                        decoration: InputDecoration(
                                          hintText: "قم بإدخال كلمة المرو",
                                          hintStyle: TextStyle(fontFamily: 'Cairo',fontSize: 14),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple[500],
                                                style: BorderStyle.solid,
                                                width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[500],
                                                style: BorderStyle.solid,
                                                width: 1),
                                          ),
                                        ),
                                        onChanged: (String value) {
                                          userPassword = value;
                                        },
                                      ),
                                    ),
                                    ///////////////////////////////////////////////////////
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: RoundedButton(
                                text: 'دخول',
                                color: Colors.deepPurple,
                                textColor: Colors.white,
                                press:() async{
                                  setState(() {
                                    processing = true;
                                  });

                                  if(userPhone.trim().isEmpty ||userPassword.trim().isEmpty){
                                    constants.showToast(context,'من فضلك املأ الحقول',Colors.red);
                                    setState(() {
                                      processing = false;
                                    });

                                  }else{
                                    String result = await logIN(userPhone, userPassword);
                                    print(result);
                                    if(result == 'user logined successfully'){
                                      String r = await storeUserInfo(userPhone);
                                      if(r == 'success') {

                                        if(userType == 2) {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) {
                                                return HomePage();
                                              }));
                                        }else{
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) {
                                                return ProviderHomePage();
                                              }));
                                        }
                                      }else{
                                        constants.showToast(context,'حدث خطأ حاول مرة اخرى',Colors.red);
                                        setState(() {
                                          processing = false;
                                        });
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ///////////////////////////////////////////////

                  ],
                ),
              ],
            ),
          ),
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
  Container buildContainerAvatar(double mdw) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              "تسجيل الدخول",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),

            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(mdw),
              boxShadow: [
                BoxShadow(color: Colors.black,blurRadius: 3,spreadRadius: .1),
              ],
            ),
            child: Icon(
              FontAwesomeIcons.solidUser,
              size: 40,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
