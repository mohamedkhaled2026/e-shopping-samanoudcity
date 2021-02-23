import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samanoud_city/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDialog extends StatefulWidget {
  final String title, hintText, textEdite, textCancel, onChangeText, flag;
  final List userInfo;
  final Function press;
  final Color color, textColor;
  final BuildContext context;
  const EditDialog({
    Key key,
    this.title,
    this.hintText,
    this.textEdite,
    this.textCancel,
    this.flag,
    this.userInfo,
    this.onChangeText,
    this.press,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.context,
  }) : super(key: key);
  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  bool processing = false;
  Constants constants = Constants();
  String oldUserPhone;
  String holder;

  Future<String> updateProviderInfo() async {
    if (await Constants.checkInternet()) {
      print(widget.userInfo);
      var response =
          await http.post(Constants.baseURL + 'updateProviderInfo', body: {
        'USER_NAME': widget.userInfo[0],
        'USER_PHONE': oldUserPhone,
        'NEW_USER_PHONE': widget.userInfo[1],
        'USER_ADDRESS': widget.userInfo[2],
        'PROVIDER_DESCRIPTION': widget.userInfo[3]
      });
      if (response.statusCode != 500) {
        print(jsonDecode(response.body)['error'].toString()+'11111111111111');
        if (jsonDecode(response.body)['error'] == false) {
          //constants.showToast(widget.context, 'تم تحديث البيانات', Colors.red);
          print(jsonDecode(response.body)['message']);
          return jsonDecode(response.body)['message'];
        } else {
          constants.showToast(widget.context, 'حدث حطاؤ حاول مرة احرى', Colors.red);
          return jsonDecode(response.body)['message'];
        }
      } else {
        constants.showToast(
            widget.context, 'خطأ في الخادم حاو في وقت اخر', Colors.red);
      }
    } else {
      constants.showToast(widget.context, 'لا يوجد اتصال بالانترنت', Colors.red);
    }
    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          widget.title,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
            color: Colors.deepPurple,
          ),
        ),
        content: TextFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(fontFamily: 'Cairo'),
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
                  color: Colors.grey[500], style: BorderStyle.solid, width: 1),
            ),
          ),
          onChanged: (String value) {
            holder = value;
          },
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                print(widget.userInfo);
                print('111111111');
                SharedPreferences preferences = await SharedPreferences.getInstance();
                if (widget.flag == 'USER_NAME') {
                  print(widget.userInfo[0]);
                  widget.userInfo[0] = holder;
                  oldUserPhone = widget.userInfo[1];
                  print(widget.userInfo[0]);
                } else if (widget.flag == 'USER_ADDRESS') {
                  widget.userInfo[2] = holder;
                  oldUserPhone = widget.userInfo[1];
                } else if (widget.flag == 'PROVIDER_DESCRIPTION') {
                  widget.userInfo[3] = holder;
                  oldUserPhone = widget.userInfo[1];
                }

                if((await updateProviderInfo()) == 'user updated successfully'){
                  print('wwwwwwwwwwwwwwwwwwwwwwww');
                  preferences.setString('USER_PHONE', widget.userInfo[1]);
                  preferences.setString('USER_NAME', widget.userInfo[0]);
                  preferences.setString('USER_ADDRESS', widget.userInfo[2]);
                  preferences.setString('PROVIDER_DESCRIPTION', widget.userInfo[3]);
                  print(preferences.getString('USER_NAME'));
                }
                Navigator.pop(context);

              },
              child: Text(
                widget.textEdite,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
              )),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                widget.textCancel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
              )),
        ],
      ),
    );
  }
}
