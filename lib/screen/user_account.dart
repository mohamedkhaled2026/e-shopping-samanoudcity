import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samanoud_city/screen/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


class UserAccountPage extends StatefulWidget {
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {

  //_________________________________________________________________________
  String userName="";
  String userPhone="";
  String userAddress="";
  retriveUserInfo() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString('USER_NAME') ?? 'none';
      userPhone = sharedPreferences.getString('USER_PHONE') ?? 'none';
      userAddress = sharedPreferences.getString('USER_ADDRESS') ?? 'none';

    });

    print(sharedPreferences.getString('USER_NAME') ?? 'none');
  }

  signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('USER_ID',-1);
    preferences.setString('USER_PHONE', 'none');
    preferences.setString('USER_NAME', 'none');
    preferences.setString('USER_ADDRESS', 'none');
    preferences.setInt('USER_TYPE',-1);
  }


//_________________  Image Picker Method  ____________________
  File _image ;


  @override
  void initState() {
    super.initState();
    retriveUserInfo();
  }



  //__________________________________________________________________________
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return SingleChildScrollView(
      child: Stack(
          children: <Widget>[
            buildPositionedTop(size.width),
            Positioned(
              right: 20,
              top: 30,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 20,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return WelcomeScreen();
                    }));
                  },
                ),
              ),
            ),
           Column(
            children: <Widget>[
              SafeArea(child: SizedBox(height: 5,)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5),
                ),
              ),
              buildContainerAvatar(size.width),
              SizedBox(height: 15,),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  //buildContainerAvatar(size.width),
                 // SizedBox(height: 20,),
                  /////////////////////////////////////////////////
                  Center(
                    child: Container(
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
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'إسم المستخدم',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cairo',

                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Colors.grey[200],spreadRadius: .1),
                                ],
                              ),
                              child: ListTile(
                                title: Text(userName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                trailing: new IconButton(
                                  icon:new Icon(FontAwesomeIcons.cog,color: Colors.deepPurple,),
                                  onPressed: (){
                                    print("Name");},),
                              ),
                            ),
                            ///////////////////////////////////////////////
                            Text(
                              'رقم الهاتف',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cairo',

                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Colors.grey[200],spreadRadius: .1),
                                ],
                              ),
                              child: ListTile(
                                title: Text(userPhone,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                      color: Colors.deepPurple
                                  ),
                                ),
                                trailing: new IconButton(
                                  icon:new Icon(FontAwesomeIcons.cog,color: Colors.deepPurple,),
                                  onPressed: (){},),
                              ),
                            ),
                            ///////////////////////////////////////////////////////
                            Text(
                              'العنوان',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cairo',

                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Colors.grey[200],spreadRadius: .1),
                                ],
                              ),
                              child: ListTile(
                                title: Text(userAddress,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                      color: Colors.deepPurple
                                  ),
                                ),
                                trailing: new IconButton(
                                  icon:new Icon(FontAwesomeIcons.cog,color: Colors.deepPurple,),
                                  onPressed: (){},),
                              ),
                            ),
                            ///////////////////////////////////////////////////////
                          ],
                        ),
                      ),
                    ),
                  ),
                  ///////////////////////////////////////////////

                ],
              ),
          ],
        )
      ],
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
              "حسابى",
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
              FontAwesomeIcons.userAlt,
              size: 40,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

}
