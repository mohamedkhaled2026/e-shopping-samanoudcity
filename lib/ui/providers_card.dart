import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samanoud_city/utils/constants.dart';

class ProvidersCard extends StatelessWidget {
  String title;
  String img;
  final Function Press;

  ProvidersCard({
    this.title,
    this.img, this.Press,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap: Press,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5,right: 10,left: 10,bottom: 5),
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        image: DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.fill,
                        ),
                    ),
//                    child: Container(
//                      decoration: BoxDecoration(
//                        color: Colors.black.withOpacity(0.4),
//                        borderRadius: BorderRadius.all(Radius.circular(25)),
//                      ),
                      child: imageData(title),
//                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  imageData(title){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0x33000000),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
          ),

          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: "Cairo",
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }



