import 'dart:convert';
import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/update_product_screen.dart';
import 'package:assignment_crud_app/ui/utils/app_colors.dart';
import 'package:assignment_crud_app/ui/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.id,});

  final String id;
  static const String name = '/product-details';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isLoading = false;
  Product? _product;

  @override
  void initState() {
    super.initState();
      _fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppColors.themeColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_product == null) return const Center(child: Text('Product not found'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildProductImage(),
          const SizedBox(height: 16),
          _buildProductName(),
          const SizedBox(height: 16),
          _buildDetailItem('Product Code', _product!.productCode),
          _buildDetailItem('Product Price', _product!.unitPrice),
          _buildDetailItem('Total Price', _product!.totalPrice),
          _buildDetailItem('Quantity', _product!.qty),
          const SizedBox(height: 16),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 200,
      width: double.infinity,
      child: _product!.img != null && _product!.img!.isNotEmpty
          ? Image.network(
        _product!.img!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, size: 50),
    );
  }

  Widget _buildProductName() {
    return Text(
      _product!.productName ?? 'Unknown',
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 36),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Unknown')),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () async{
        final updatedProduct =await Navigator.pushNamed(context, UpdateProductScreen.name, arguments: _product);
        if (updatedProduct != null && updatedProduct == true) {
          _fetchProduct();
        }
      },
      child: const Icon(Icons.edit),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }



  Future<void> _fetchProduct() async {
    _isLoading = true;
    setState(() {});
    Uri uri = Uri.parse(Urls.getProductByIdUrl(widget.id));
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    print(uri);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> p in decodedData['data']) {
         _product = Product.fromMap(p);
        setState(() {});
      }
      _isLoading = false;
      setState(() {});
    }
  }
}