import 'dart:convert';

import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/add_product_screen.dart';
import 'package:assignment_crud_app/ui/utils/app_colors.dart';
import 'package:assignment_crud_app/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

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
              Product product = ProductList[index];
              return buildProductCard(
                product: product,
                updateProductList: () { _getProductList(); },
                deleteProduct: () { _deleteProduct(ProductList[index].id!); },
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

  Future<void> _deleteProduct(String id) async {
    Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/DeleteProduct/$id');
    Response response = await get(uri);
    if (response.statusCode == 200) {
      setState(() {
        ProductList.removeWhere((product) => product.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete successful')));
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed')));
    }

  }

  Future<void> _getProductList() async {
    ProductList.clear();
    _productListScreenInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    print(uri);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          id: p['_id'],
          productName: p['ProductName'],
          productCode: p['ProductCode'].toString(),
          img: p['Img'],
          unitPrice: p['UnitPrice'].toString(),
          qty: p['Qty'].toString(),
          totalPrice: p['TotalPrice'].toString(),
        );
        ProductList.add(product);
        setState(() {});
      }
      _productListScreenInProgress = false;
      setState(() {});
    }
  }
}
