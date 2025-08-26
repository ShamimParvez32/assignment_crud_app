class Product {
  String? productName;
  String? productCode;
  String? img;
  String? unitPrice;
  String? qty;
  String? totalPrice;
  String? id;

  Product({
    this.productName,
    this.productCode,
    this.img,
    this.unitPrice,
    this.qty,
    this.totalPrice,
    this.id,
  });


  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      productName: map['ProductName'],
      productCode: map['ProductCode'].toString(),
      img: map['Img'],
      unitPrice: map['UnitPrice'].toString(),
      qty: map['Qty'].toString(),
      totalPrice: map['TotalPrice'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['ProductName'] = this.productName;
    data['ProductCode'] = this.productCode;
    data['Img'] = this.img;
    data['Qty'] = this.qty;
    data['UnitPrice'] = this.unitPrice;
    data['TotalPrice'] = this.totalPrice;
    return data;
  }


}
