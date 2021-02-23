import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:samanoud_city/screen/home_page.dart';
import 'package:samanoud_city/ui/round_Button.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:samanoud_city/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool processing = false;
  String userName = '';
  String userPassword = '';
  String userPasswordConfirm = '';
  String userPhone = '';
  String userAddress = '';
  int typeId = 1;
  Constants constants = Constants();
  //2- _______________Updating data over the internet using the http package________________
  dynamic addUser(String userPhone, String userName, String userAddress,
      String userPassword) async {
    if( await Constants.checkInternet()) {
      http.Response r =
      await http.post('http://samanoudcity.com/MyApi/public/register', body: {
        'USER_PHONE': userPhone,
        'USER_PASSWORD': userPassword,
        'USER_NAME': userName,
        'USER_ADDRESS': userAddress,
        'TYPE_ID': '2',
      });
      if(r.statusCode != 500) {
        print(r.statusCode.toString());
        if(jsonDecode(r.body)['error'] == false){
          return jsonDecode(r.body)['message'];
        }else{
          if(jsonDecode(r.body)['message'] == 'user already exists'){
            constants.showToast(context,'المستخدم موجود مسبقا',Colors.red);
          }else{
            constants.showToast(context,'حدث خطأ حاول مرة اخرى',Colors.red);
          }
        }

      }else{
        constants.showToast(context,'خطأ في الخادم حاو في وقت اخر', Colors.red);
      }
    }else{
      constants.showToast(context, 'لا يوجد اتصال بالانترنت', Colors.red);
    }
    setState(() {
      processing = false;
    });
  }


  bool validateFields() {
    if (userPhone.length != 11) {
      //faild
      constants.showToast(context, 'رقم الهاتف غير صحيح', Colors.red);
      return false;
    } else {
      if (userPassword.length < 7) {
        //faild
        constants.showToast(context, 'كلمة المرور قصيرة', Colors.red);
        return false;
      } else {
        if (userPasswordConfirm != userPassword) {
          //faild
          constants.showToast(context, 'كلمة المرور غير متطابقة', Colors.red);
          return false;
        } else {
          if (userName.length < 3) {
            //faild
            constants.showToast(context, 'اسم قصير', Colors.red);
            return false;
          } else {
            if (userAddress.length < 7) {
              //faild
              constants.showToast(context, 'دخل العنوان بالتفصيل', Colors.red);
              return false;
            } else {
              return true;
            }
          }
        }
      }
    }
  }

  Future<Map> getUserInfo(String userPhone) async {
    var response = await http.get(Constants.baseURL + 'getUserInfo/$userPhone');
    if (response.statusCode != 500) {
      print(jsonDecode(response.body)['error']);
      if (jsonDecode(response.body)['error'] == false) {
        print(jsonDecode(utf8.decode(response.bodyBytes)));
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return jsonDecode(response.body);
      }
    } else {
      Map m = Map();
      m['message'] = 'sever error';
      return m;
    }
  }

  Future<String> storeUserInfo(String userPhone) async {
    Map m = await getUserInfo(userPhone);
    print(m['message']);
    if (m['message'] == 'user exists') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('USER_ID', m['user']['USER_ID']);
      preferences.setString('USER_PHONE', m['user']['USER_PHONE']);
      preferences.setString('USER_NAME', m['user']['USER_NAME']);
      preferences.setString('USER_ADDRESS', m['user']['USER_ADDRESS']);
      preferences.setInt('USER_TYPE', m['user']['USER_TYPE']);
      preferences.setInt('PROVIDER_ID', m['user']['PROVIDER_ID']);
      preferences.setString('PROVIDER_IMAGE', m['user']['PROVIDER_IMAGE']);
      preferences.setString('PROVIDER_DESCRIPTION', m['user']['PROVIDER_DESCRIPTION']);
      preferences.setString('CATEGORY_NAME', m['user']['CATEGORY_NAME']);
      return 'success';
    } else {
      return 'faild store';
    }
  }

  File _image;
  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image ;
      print('_image: $_image');
    });
    final bytes = File(_image.path).readAsBytesSync();
    String image64 = base64.encode(bytes);
    print('333333'+image64);
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
            color: Colors.deepPurple,
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
                    SizedBox(height: 20,),
                    /////////////////////////////////////////////////0
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10,bottom: 10),
                            width: size.width/1.2,
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
                            child: SingleChildScrollView(
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
                                        textAlignVertical: TextAlignVertical.bottom,
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
                                    Text(
                                      'تأكيد كلمة المرور',
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
                                          hintText: "أعد كتابة كلمة المرور",
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
                                          userPasswordConfirm = value;
                                        },
                                      ),
                                    ),
                                    ///////////////////////////////////////////////////////
                                    Text(
                                      'إسم المستخدم',
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
                                          hintText: "أدخل إسم المستخدمو",
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
                                          userName = value;
                                        },
                                      ),
                                    ),
                                    ///////////////////////////////////////////////////////
                                    Text(
                                      'عنوان المُستخدم',
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
                                          hintText: "يُرجى مُراعاة الدقة فى كتابة العنوان",
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
                                          userAddress = value;
                                        },
                                      ),
                                    ),
                                    ///////////////////////////////////////////////////////
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: RoundedButton(
                              text: 'إنشاء',
                              color: Colors.white,
                              textColor: Colors.deepPurple,
                              press: () async {
                                setState(() {
                                  processing = true;
                                });
                                if (validateFields()) {
                                  dynamic r = await addUser(
                                      userPhone, userName, userAddress, userPassword);
                                  if (r == 'user created successfully') {
                                    storeUserInfo(userPhone);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                          return HomePage();
                                        }));
                                  } else {
                                    print('error');
                                  }
                                } else {
                                  setState(() {
                                    processing = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
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
              color: Colors.white,
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
              "إنشاء حساب جديد",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: .1),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                getImage();
              },
              child: Container(
                child: _image == null
                    ? Icon(FontAwesomeIcons.plus, color: Colors.white)
                    : Image.file(_image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
