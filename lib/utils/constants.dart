import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
const kBackgroundColor = Color(0xFFCCD1D1 );
const kBackgroundWhite = Color(0xFFECF0F1 );
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF222B45);
const kblueLightColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);
class Constants{
  static const String baseURL = 'https://unafraid-keyword.000webhostapp.com/MyApi/public/';
  static const String baseImageURL = 'https://unafraid-keyword.000webhostapp.com/MyApi/images/';

  FlutterToast flutterToast;
   static Future<bool> checkInternet() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  void showToast(BuildContext context,String message,Color color){
    flutterToast = flutterToast = FlutterToast(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
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
    flutterToast.showToast(child: toast,gravity: ToastGravity.TOP,toastDuration: Duration(seconds: 3));
  }
}