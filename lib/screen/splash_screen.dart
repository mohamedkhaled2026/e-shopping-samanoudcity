import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:samanoud_city/screen/provider_home_page.dart';
import 'package:samanoud_city/screen/welcome_screen.dart';
import 'package:samanoud_city/ui/round_Button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String user='';
  int userType = -1;
  bool processing = false;
  retrieveUserInfo() async {
    setState(() {
      processing =true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    user = sharedPreferences.getString('USER_NAME') ?? 'none';
    userType = sharedPreferences.getInt('USER_TYPE') ?? -1;

    Timer(Duration(seconds: 1), (){
      print(user);
      if(user != 'none'){
        print(userType.toString());
        if(userType == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return ProviderHomePage();
              }));
        }
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return WelcomeScreen();
        }));

      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveUserInfo();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: ModalProgressHUD(
        inAsyncCall: processing,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.deepPurple[800],
                Colors.deepPurple[500],
                Colors.deepPurple[300],
              ]),
            ),
            child: Center(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "مرحباًُ بكم فى \n سوق نود",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Image(
                      image: AssetImage('images/splash1.png'),
                      width: size.width,
                      height: 300,
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
