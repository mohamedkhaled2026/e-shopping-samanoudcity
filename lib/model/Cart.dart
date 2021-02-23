

class CartProduct{
  int _id;
  int _productID;
  String _productName;
  int _productQuantity;
  double _productPrice;
  int _providerID;
  String _productImage;
  String _providerName;
  CartProduct(this._productID,this._productName,this._productQuantity,this._productPrice,this._providerID,this._productImage,this._providerName);
  CartProduct.map(dynamic obj){
    this._id = obj['ID'];
    this._productID = obj['PRODUCT_ID'];
    this._productName = obj['PRODUCT_NAME'];
    this._productQuantity = obj['PRODUCT_QUANTITY'];
    this._productPrice = obj['PRODUCT_PRICE'];
    this._providerID = obj['PROVIDER_ID'];
    this._providerName = obj['PROVIDER_NAME'];
    this._productImage = obj['PRODUCT_IMAGE'];
  }
  CartProduct.order(dynamic obj){
    this._productID = obj['PRODUCT_ID'];
    this._productName = obj['PRODUCT_NAME'];
    this._productQuantity = obj['PRODUCT_QUANTITY'];
    this._productPrice = obj['PRODUCT_PRICE'];
  }

  int get providerID => _providerID;
  String get providerName => _providerName;
  double get productPrice => _productPrice;
  String get productName => _productName;
  int get productQuantity => _productQuantity;
  int get productID => _productID;
  String get productImage => _productImage;
  int get id => _id;


  set productQuantity(int value) {
    _productQuantity = value;
  }
  void setProductQuantity(int value){
    _productQuantity = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['PRODUCT_ID'] = _productID;
    map['PRODUCT_NAME'] = _productName;
    map['PRODUCT_QUANTITY'] = _productQuantity;
    map['PRODUCT_PRICE'] = _productPrice;
    map['PRODUCT_IMAGE'] = _productImage;
    map['PROVIDER_ID'] = _providerID;
    map['PROVIDER_NAME'] = _providerName;
    return map;
  }

  CartProduct.fromMap(Map<String,dynamic> map){
    this._productID = map['PRODUCT_ID'];
    this._productName = map['PRODUCT_NAME'];
    this._productQuantity = map['PRODUCT_QUANTITY'];
    this._productImage = map['PRODUCT_IMAGE'];
    this._productPrice = double.parse(map['PRODUCT_PRICE'].toString());
    this._providerID = map['PROVIDER_ID'];
    this._providerName = map['PROVIDER_NAME'];
  }
}