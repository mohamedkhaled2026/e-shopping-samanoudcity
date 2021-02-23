import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:samanoud_city/ui/round_Button.dart';
import 'package:samanoud_city/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  bool processing = false;
  String productName = '';
  String productImage = '';
  String productDescription = '';
  double productPrice = 0;
  int providerID = -1;
  bool compressCompleted = false;
  Constants constants = Constants();
  File _image;
  TextEditingController productNameController;
  TextEditingController productDescriptionController;
  TextEditingController productPriceController;


  dynamic addProduct(String productName, String productImage,
      String productDescription, double productPrice, int providerID) async {
    if (await Constants.checkInternet()) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      providerID = preferences.getInt('PROVIDER_ID') ?? -1;
      print((preferences.getInt('PROVIDER_ID') ?? -1).toString() + 'qqqqqq');
      http.Response r = await http
          .post('https://unafraid-keyword.000webhostapp.com/MyApi/public/addProduct', body: {
        'PRODUCT_NAME': productName,
        'PRODUCT_IMAGE': productImage,
        'PRODUCT_DESCRIPTION': productDescription,
        'PRODUCT_PRICE': productPrice.toString(),
        'PROVIDER_ID': providerID.toString(),
      });
      if (r.statusCode != 500) {
        print(r.statusCode.toString());
        if (jsonDecode(r.body)['error'] == false) {
          return jsonDecode(r.body)['message'];
        } else {
          print(jsonDecode(r.body)['message']);
          if (jsonDecode(r.body)['message'] == 'product added successfully') {
            constants.showToast(context, 'المستخدم موجود مسبقا', Colors.red);
          } else {
            constants.showToast(context, 'حدث خطأ حاول مرة اخرى', Colors.red);
          }
        }
      } else {
        constants.showToast(
            context, 'خطأ في الخادم حاو في وقت اخر', Colors.red);
      }
    } else {
      constants.showToast(context, 'لا يوجد اتصال بالانترنت', Colors.red);
    }
    setState(() {
      processing = false;
    });
  }



  bool validateFields() {
    if (productNameController.text.length < 5) {
      //faild
      constants.showToast(context, 'اسم المنتج قصير', Colors.red);
      return false;
    } else {
      if (productDescriptionController.text.length < 10) {
        //faild
        constants.showToast(context, 'وصف قصير', Colors.red);
        return false;
      } else {
        if (productPriceController.text.length < 1) {
          //faild
          constants.showToast(context, 'اضف السعر', Colors.red);
          return false;
        } else {
          if (!compressCompleted) {
            constants.showToast(context, 'اضف صورة المنتج', Colors.red);
            return false;
          } else {
            return true;
          }
        }
      }
    }
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    final dir = await path_provider.getTemporaryDirectory();

    File file = createFile("${dir.absolute.path}/test.jpg");
    File newImage = await testCompressAndGetFile(image, file.absolute.path);
    //final bytes = File(_image.path).readAsBytesSync();
    final bytes = newImage.readAsBytesSync();
    String image64 = await base64.encode(bytes);
    productImage = image64;
    print(productImage);
    compressCompleted = true;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 60,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameController = TextEditingController();
    productDescriptionController = TextEditingController();
    productPriceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: processing,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              buildPositionedTop(size.width),
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
                  /////////////////////////////////////////////////0
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10,bottom: 10),
                            width: size.width/1.2,
                            height: size.width,
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
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'إسم المُنتج',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "أدخل إسم المُنتج هنا",
                                        hintStyle: TextStyle(fontFamily: 'Cairo'),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurple[500],
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[500],
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                      ),
//                                      onChanged: (String value) {
//                                        productName = value;
//                                      },
                                      controller: productNameController,
                                    ),
                                    ///////////////////////////////////////////////
                                    Text(
                                      'تفاصيل المُنتج',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "قم بإدخال وصف للمنتجا",
                                        hintStyle: TextStyle(fontFamily: 'Cairo'),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurple[500],
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[500],
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                      ),
//                                      onChanged: (String value) {
//                                        productDescription = value;
//                                      },
                                      controller: productDescriptionController,
                                    ),
                                    ///////////////////////////////////////////////////////
                                    Text(
                                      'سعر المُنتج',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "قم بإدخال سعر المُنتجا",
                                        hintStyle: TextStyle(fontFamily: 'Cairo'),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurple[500],
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[500],
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                      ),
//                                      onChanged: (String value) {
//                                        productPrice = double.parse(value);
//                                      },
                                    controller: productPriceController,

                                    ),
                                    ///////////////////////////////////////////////////////
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: RoundedButton(
                              text: 'إضافة',
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                              press: () async {
                                setState(() {
                                  processing = true;
                                });
                                if (validateFields()) {
                                  dynamic r = await addProduct(
                                      productNameController.text,
                                      productImage,
                                      productDescriptionController.text,
                                      double.parse(productPriceController.text),
                                      providerID);
                                  if (r == 'product added successfully') {
                                    constants.showToast(context, 'تم اضافة المنتج', Colors.green);
                                    setState(() {
                                      processing = false;
                                      compressCompleted = false;
                                      productNameController.clear();
                                      productDescriptionController.clear();
                                      productPriceController.clear();
                                      _image = null;
                                    });
                                  } else {
                                    print('error');
                                  }
                                } else {
                                  setState(() {
                                    processing = false;
                                    print('Error');
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ///////////////////////////////////////////////

                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  Positioned buildPositionedTop(double mdw) {
    return Positioned(
      child: Transform.scale(
        scale: 1.5,
        child: Transform.translate(
          offset: Offset(0, -mdw/2),
          child: Container(
            alignment: Alignment.center,
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
              "إضافة منتج",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: .1),
                ],
              ),
              child: Container(
                child: _image == null
                    ? Icon(FontAwesomeIcons.plus, color: Colors.deepPurple[500])
                    : Image.file(_image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
