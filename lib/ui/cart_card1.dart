import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samanoud_city/utils/constants.dart';

class CartCard extends StatelessWidget {
  final String image;
  final String title;
  final double price;
  final int quantity;
  final Function Press;
  const CartCard({
    Key key,
    this.image,
    this.title,
    this.price,
    this.quantity,
    this.Press,
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Card(
        child: Container(
          child:Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topRight,
                      height: 150,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width:20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Text(
                                " المُنتج : $title",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Cairo",
                                  color: kTextColor,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                "الكمية: $quantity",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Cairo"
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                "السعر : $priceجـ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Cairo"
                                ),
                                textAlign: TextAlign.end,
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(3),
                      color: Colors.deepPurple,
                      padding: EdgeInsets.all(5),
                      child: Image.asset(image,height: 150,width: 50,fit: BoxFit.cover,alignment: Alignment.center,),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey.withOpacity(0.5),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "حذف",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: 5,),
                            Icon(Icons.delete,color: kTextColor,),
                          ],
                        ),
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "تأكيد",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.bold,
                            ),),
                          SizedBox(width: 5,),
                          Icon(Icons.monetization_on,color: kTextColor,),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



//
//Row(
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//Image.network(Constants.baseImageURL+image,height: 50,width: 50,),
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//SizedBox(height: 10,),
//Text(
//title,
//style: TextStyle(
//fontSize: 20,
//fontWeight: FontWeight.w600,
//fontFamily: 'Cairo',
//color: Colors.deepPurple,
//),),
//SizedBox(height: 10,),
//Text(
//quantity.toString(),
//style: TextStyle(
//fontSize: 18,
//fontWeight: FontWeight.w400,
//fontFamily: 'Cairo',
//color: Colors.black38,
//),),
//SizedBox(height: 10,),
//Text(
//price.toString(),
//style: TextStyle(
//fontSize: 18,
//fontWeight: FontWeight.w400,
//fontFamily: 'Cairo',
//color: Colors.black38,
//),),
//Container(
//child: Row(
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//Container(
//alignment: Alignment.center,
//height: 28,
//width: 28,
//padding:EdgeInsets.all(4) ,
//margin: EdgeInsets.all(4),
//decoration: BoxDecoration(
//color : Colors.black26,
//borderRadius : BorderRadius.circular(5),
//),
//child: Center(
//child: Icon(
//Icons.remove,
//size: 20,
//color: Colors.black,
//),
//),
//),
//Container(
//alignment: Alignment.center,
//height: 28,
//width: 28,
//padding:EdgeInsets.all(4) ,
//margin: EdgeInsets.all(4),
//decoration: BoxDecoration(
//color : Colors.black26,
//borderRadius : BorderRadius.circular(5),
//),
//child: Center(
//child: Icon(
//Icons.add,
//size: 20,
//color: Colors.black,
//),
//),
//),
//],
//),
//)
//
//
//],
//),
//],
//),

