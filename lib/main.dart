import 'package:flutter/material.dart';
import 'package:samanoud_city/screen/splash_screen.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor:Colors.blueAccent,
      ),

      home: SplashScreen(),
    ));