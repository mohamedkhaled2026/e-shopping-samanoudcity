import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String prod_name;
  final String prod_picture;
  final String prod_price;
  final Function press;
  const HomeCard({
    Key key,
    this.prod_name,
    this.prod_picture,
    this.prod_price,
    this.press,
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 200,

                    child: CachedNetworkImage(
                      imageUrl: prod_picture,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          //CircularProgressIndicator(value: downloadProgress.progress),
                      Container(alignment:Alignment.bottomCenter,height:10,child: LinearProgressIndicator(value: downloadProgress.progress,backgroundColor: Colors.deepPurple,)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
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


imageData( prod_name , prod_price){
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Color(0x77FFFFFF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              prod_name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "Cairo",
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "جـ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Cairo",
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  prod_price ,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Cairo",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}


