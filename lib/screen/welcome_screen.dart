import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samanoud_city/ui/round_Button.dart';
import 'package:samanoud_city/screen/singup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  Widget container = LoginPage();
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind,size: 30),
            title: Text("تسجيل الدخول", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add,size: 30),
            title: Text("تسجيل الاشتراك", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
          ),
        ],
        onTap: (index){
          setState(() {
            if(index == 0){
              container = LoginPage();
              _currentIndex = index;
            }
            else if(index ==1){
              container = SignUpPage();
              _currentIndex = index;
            }

          });

        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
      ),
      body: container,

//      SingleChildScrollView(
//        child: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
//              Colors.deepPurple[800],
//              Colors.deepPurple[500],
//              Colors.deepPurple[300],
//            ]),
//          ),
//          child: Center(
//            child: Center(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    height: 80,
//                  ),
//                  Text(
//                    "مرحباًُ بكم فى \n سوق نود",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontSize: 20,
//                      fontWeight: FontWeight.bold,
//                      fontFamily: 'Pacifico',
//                      color: Colors.white,
//                    ),
//                  ),
//                  SizedBox(
//                    height: size.height * 0.1,
//                  ),
//                  Image(
//                    image: AssetImage('images/splash1.png'),
//                    width: size.width,
//                    height: 300,
//                    alignment: Alignment.center,
//                    fit: BoxFit.fitWidth,
//                  ),
////                CircleAvatar(
////                  radius: 100.0,
////                  backgroundColor: Colors.white,
////                  backgroundImage: AssetImage('images/splash1.png'),
////                ),
//                  SizedBox(
//                    height: 40,
//                  ),
//                  RoundedButton(
//                    text: 'تسجيل الدخول',
//                    color: Colors.deepPurple,
//                    press: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) {
//                        return LoginPage();
//                      }));
//                    },
//                  ),
//                  SizedBox(
//                    height: 10,
//                  ),
//                  RoundedButton(
//                    text: 'تسجيل الاشتراك',
//                    color: Color(0xFFD52550),
//                    textColor: Colors.white,
//                    press: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) {
//                        return SignUpPage();
//                      }));
//                    },
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
    );
  }
}
