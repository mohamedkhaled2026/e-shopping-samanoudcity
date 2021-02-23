import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samanoud_city/screen/categories_page.dart';
import 'package:samanoud_city/screen/orderPage.dart';
import 'package:samanoud_city/screen/user_account.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget container = CategoriesPage();
  var _currentIndex=1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async {
        if(_currentIndex == 1){
          return true;
        }else{
          setState(() {
            container = CategoriesPage();
            _currentIndex = 1;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundWhite,
        body: container,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidUserCircle,size: 25,),
              title: Text("حسابى", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.thLarge,size: 25),
              title: Text("الأقسام", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shoppingCart,size: 25),
              title: Text("سلتى", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shoppingBasket,size: 25),
              title: Text("الطلبات", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
          ],
          onTap: (index){
            setState(() {
              if(index == 0){
                _currentIndex = index;
                container = UserAccountPage();
              }
              else if(index ==1){
                _currentIndex = index;
                container = CategoriesPage();
              }
              else if(index ==2){
                _currentIndex =index;
                container = CartPage();
              }
              else if(index ==3){
                _currentIndex =index;
                container = OrderPage();
              }
            });

          },

          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
