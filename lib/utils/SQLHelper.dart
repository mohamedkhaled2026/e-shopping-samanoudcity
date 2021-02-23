import 'dart:convert';

import 'package:samanoud_city/model/Cart.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
class SQLHELPER{

  Database db;
  static const String dbName = 'cart.db';
  Future<Database> getDB() async{
    if(db != null){
      return db;
    }else{
      db = await initDB();
      return db;
    }
  }

  Future<Database> initDB() async{
    Directory decomentDirectory = await getApplicationDocumentsDirectory();
    String path = join(decomentDirectory.path, dbName);
    var myDB = await openDatabase(path,version:1,onCreate: (Database db ,int version) async{
      String sql = 'create table cart_products (ID INTEGER PRIMARY KEY AUTOINCREMENT,PRODUCT_ID INTEGER,PRODUCT_NAME TEXT,PRODUCT_PRICE REAl,PRODUCT_QUANTITY INTEGER,PRODUCT_IMAGE TEXT,PROVIDER_NAME TEXT,PROVIDER_ID INTEGER)';
      await db.execute(sql);
    });
    return myDB;
  }


  Future<int> addProductToCart(CartProduct cart) async{
    if(await isProductExist(cart.productID) == 0){
    Database myDB = await getDB();
    int result = await myDB.insert('cart_products', cart.toMap());
    return result;
    }else{
      return -2;
    }
  }

  Future<List> getAllProducts() async {
    String sql = 'select * from cart_products';
    Database myDB = await getDB();
    var result = await myDB.rawQuery(sql);
    if(result != null) {
      return result.toList();
    }else{
      return null;
    }
  }

  Future<List> getProductsForSpecificProvider(int providerID) async {
    String sql = 'select * from cart_products where PROVIDER_ID = $providerID';
    Database myDB = await getDB();
    var result = await myDB.rawQuery(sql);
    if(result != null) {
      return result.toList();
    }else{
      return null;
    }
  }
  Future<List> getProductsForSpecificProviderForOrder(int providerID) async {
    String sql = 'select PRODUCT_ID,PRODUCT_NAME,PRODUCT_PRICE,PRODUCT_QUANTITY from cart_products where PROVIDER_ID = $providerID';
    Database myDB = await getDB();
    var result = await myDB.rawQuery(sql);
    if(result != null) {
      return result.toList();
    }else{
      return null;
    }
  }

  Future<double> getTotalPriceForProvider(int providerID) async{
    String sql = 'select SUM(PRODUCT_PRICE * PRODUCT_QUANTITY) total from cart_products where PROVIDER_ID = $providerID';
    Database myDB = await getDB();
    var result = await myDB.rawQuery(sql);
    if(result != null) {
      return result.first['total'];
    }else{
      return 0;
    }
  }

  Future<CartProduct> getSpesificProduct(int productID) async {
    String sql = 'select * from cart_products where PRODUCT_ID = $productID';
    Database myDB = await getDB();
    var r = await myDB.rawQuery(sql);
    return CartProduct.fromMap(r.first);
  }

  Future<int> isProductExist(int productID) async {
    String sql = 'select * from cart_products where PRODUCT_ID = $productID';
    Database myDB = await getDB();
    var r = await myDB.rawQuery(sql);

    return r.length;
  }

  Future<int> deleteProduct(int productID) async {
    Database myDB = await getDB();
    int r = await myDB.delete('cart_products',where:'PRODUCT_ID = ?' ,whereArgs: [productID]);
    return r;
  }

  Future<int> deleteProvider(int providerID) async {
    Database myDB = await getDB();
    int r = await myDB.delete('cart_products',where:'provider_id = ?' ,whereArgs: [providerID]);
    return r;
  }

  Future<int> updateProduct(int productID,int produtQuantity) async {
    Database myDB = await getDB();
    int r = await myDB.rawUpdate('update cart_products set PRODUCT_QUANTITY = $produtQuantity where PRODUCT_ID = $productID ');
    return r;
  }

  Future<List> getProviders() async{
    String sql = 'select distinct provider_id,provider_name from cart_products';
    Database myDB = await getDB();
    var r = await myDB.rawQuery(sql);
    return r.toList();
  }


}