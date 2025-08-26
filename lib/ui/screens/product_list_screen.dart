import 'dart:convert';

import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/add_product_screen.dart';
import 'package:assignment_crud_app/ui/utils/app_colors.dart';
import 'package:assignment_crud_app/ui/utils/urls.dart';
import 'package:assignment_crud_app/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  static const String name='/';
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _productListScreenInProgress = false;
  List<Product> ProductList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      appBar: AppBar(
        title: Text('Product List'),
        backgroundColor: AppColors.themeColor,
        actions: [
          IconButton(
            onPressed: () {
              _getProductList();
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Visibility(
        visible: _productListScreenInProgress == false,
        replacement: Center(child: CircularProgressIndicator()),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: ListView.separated(
            itemCount: ProductList.length,
            itemBuilder: (context, index) {
              return buildProductCard(
                product: ProductList[index],
                refreshProductList: () {  _getProductList(); },

              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Divider(thickness: 1, color: Colors.grey),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final product = await Navigator.pushNamed(
            context,
            AddProductScreen.name,
          );
          if (product != null) {
            _getProductList();
            setState(() {});
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: AppColors.themeColor,
        splashColor: Colors.cyanAccent,
      ),
    );
  }





  Future<void> _getProductList() async {
    ProductList.clear();
    _productListScreenInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(Urls.getProductUrl);
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    print(uri);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> productJson in decodedData['data']) {
        Product product = Product.fromMap(productJson);
        ProductList.add(product);
        setState(() {});
      }
      _productListScreenInProgress = false;
      setState(() {});
    }
  }
}
