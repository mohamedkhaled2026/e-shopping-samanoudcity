import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samanoud_city/utils/constants.dart';

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function Press;
  const CategoryCard({
    Key key,
    this.svgSrc,
    this.title,
    this.Press,
}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: Press,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
                SvgPicture.network(
                  svgSrc,
                  height: 80,
                  width: 60,
                  color: Colors.deepPurple,),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: Colors.deepPurple,
                  ),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


