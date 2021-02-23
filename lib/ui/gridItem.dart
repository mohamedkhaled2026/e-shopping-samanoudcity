import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String text ;
  final String imageUrl ;
  final Function onPress;
  const GridItem({
    this.text,
    this.imageUrl,
    this.onPress
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 200.0,
        width: 170.0,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.cyanAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Image.network(imageUrl),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20 ,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
            )

          ],
        ),

      ),
    );
  }
}