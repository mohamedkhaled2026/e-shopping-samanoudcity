import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samanoud_city/screen/provider_account.dart';
import 'package:samanoud_city/screen/provider_add_products.dart';
import 'package:samanoud_city/screen/provider_receive_order.dart';
import 'package:samanoud_city/screen/provider_space.dart';
import 'package:samanoud_city/utils/constants.dart';

class ProviderHomePage extends StatefulWidget {
  @override
  _ProviderHomePageState createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  Widget container = ProviderSpace();
  var _currentIndex=1;
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
            container = ProviderSpace();
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
              icon: Icon(FontAwesomeIcons.storeAlt,size: 25),
              title: Text("دُكانى", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos,size: 25),
              title: Text("اضافة منتج", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Cairo")),
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
                container = ProviderAccount();
              }
              else if(index ==1){
                _currentIndex = index;
                container = ProviderSpace();
              }
              else if(index ==2){
                _currentIndex =index;
                container = AddProducts();
              }
              else if(index ==3){
                _currentIndex =index;
                container = ReceiveOrder();
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
