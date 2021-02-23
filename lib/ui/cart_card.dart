import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samanoud_city/utils/constants.dart';

class CartCard extends StatelessWidget {
  final String image;
  final String title;
  final double price;
  final int quantity;
  final Function Press;
  final Function deletePress;
  final Function updatePress;
  const CartCard({
    Key key,
    this.image,
    this.title,
    this.price,
    this.quantity,
    this.Press,
    this.deletePress,
    this.updatePress
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(2),
          color: Colors.white,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: Press,
              child: Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: 150,
                              alignment: Alignment.topRight,
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
                              child: Image.network(Constants.baseImageURL+image,height: 150,width: 50,fit: BoxFit.cover,alignment: Alignment.center,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5),),
                    Container(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: deletePress,
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
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: updatePress,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5,right: 3,left: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "تعديل",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    SizedBox(width: 5,),
                                    Icon(Icons.edit,color: kTextColor,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


