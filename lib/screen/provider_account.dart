import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samanoud_city/screen/welcome_screen.dart';
import 'package:samanoud_city/ui/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
class ProviderAccount extends StatefulWidget {
  @override
  _ProviderAccountState createState() => _ProviderAccountState();
}

class _ProviderAccountState extends State<ProviderAccount> {
  String userName="";
  String userPhone="";
  String userAddress="";
  int providerId=-1;
  String providerDescription = "";
  String providerImage = "";
  String categoryName = "";
  String holder;
  List userInfo;
  retriveUserInfo() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString('USER_NAME') ?? 'none';
      userPhone = sharedPreferences.getString('USER_PHONE') ?? 'none';
      userAddress = sharedPreferences.getString('USER_ADDRESS') ?? 'none';
      providerId = sharedPreferences.getInt('PROVIDER_ID') ?? -1;
      providerDescription = sharedPreferences.getString('PROVIDER_DESCRIPTION') ?? 'none';
      providerImage = sharedPreferences.getString('PROVIDER_IMAGE') ?? 'none';
      categoryName = sharedPreferences.getString('CATEGORY_NAME') ?? 'none';

    });
    userInfo = [userName,userPhone,userAddress,providerDescription];
  }

  File _image;

  signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('USER_ID',-1);
    preferences.setString('USER_PHONE', 'none');
    preferences.setString('USER_NAME', 'none');
    preferences.setString('USER_ADDRESS', 'none');
    preferences.setInt('USER_TYPE',-1);
    preferences.setInt('PROVIDER_ID', -1);
    preferences.setString('PROVIDER_IMAGE', 'none');
    preferences.setString('PROVIDER_DESCRIPTION', 'none');
    preferences.setString('CATEGORY_NAME', 'none');
  }

  @override
  void initState() {
    super.initState();
    retriveUserInfo();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ),
                buildContainerAvatar(size.width),
                SizedBox(height: 20,),
                /////////////////////////////////////////////////
                SingleChildScrollView(
                  child: Center(
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
                              'إسم المحل',
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
                                    return showDialog(context: context,builder: (context){
                                          return EditDialog(
                                            title: "تعديل",
                                            flag:'USER_NAME',
                                            context: context,
                                            userInfo: userInfo,
                                            hintText: "اكتب الإسم الجديد للمحل هنا",
                                            textEdite: "تعديل",
                                            textCancel: "إلغاء",
                                          );
                                    });
                                    },),
                              ),
                            ),
                            ///////////////////////////////////////////////
                            Text(
                              'تفاصيل المحل',
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
                                title: Text(providerDescription,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                      color: Colors.deepPurple
                                  ),
                                ),
                                trailing: new IconButton(
                                  icon:new Icon(FontAwesomeIcons.cog,color: Colors.deepPurple,),
                                  onPressed: (){
                                    return showDialog(context: context,builder: (context){
                                      return EditDialog(
                                        title: "تعديل",
                                        flag:'PROVIDER_DESCRIPTION',
                                        userInfo: userInfo,
                                        hintText:"أضف التفاصيل الجدبدة هنا",
                                        textEdite: "تعديل",
                                        textCancel: "إلغاء",
                                      );
                                    });
                                  },),
                              ),
                            ),
                            ///////////////////////////////////////////////////////
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
                                  onPressed: (){
                                    return showDialog(context: context,builder: (context){
                                      return EditDialog(
                                        title: "تعديل",
                                        flag:'USER_PHONE',
                                        userInfo: userInfo,
                                        hintText: "قم بتعديل رقم الهاتف هنا",
                                        textEdite: "تعديل",
                                        textCancel: "إلغاء",
                                      );
                                    });
                                  },),
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
                                  onPressed: (){
                                    return showDialog(context: context,builder: (context){
                                      return EditDialog(
                                        title: "تعديل",
                                        flag:'USER_ADDRESS',
                                        userInfo: userInfo,
                                        hintText: "قم بتعديل العنوان هنا",
                                        textEdite: "تعديل",
                                        textCancel: "إلغاء",
                                      );
                                    });
                                    },),
                              ),
                            ),
                            ////////////////////////////////////////

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ///////////////////////////////////////////////

              ],
            ),
          ],
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
