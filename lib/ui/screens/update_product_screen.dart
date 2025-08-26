import 'dart:convert';

import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/product_list_screen.dart';
import 'package:assignment_crud_app/ui/utils/app_colors.dart';
import 'package:assignment_crud_app/ui/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {

  const UpdateProductScreen({super.key, required this.product,});
  final Product product;
  static const String name = '/ update';

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _qtyTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _priceTEController.addListener(_calculateTotal);
    _qtyTEController.addListener(_calculateTotal);
    _nameTEController.text = widget.product.productName ?? '';
    _priceTEController.text = widget.product.unitPrice ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _qtyTEController.text = widget.product.qty ?? '';
    _imageTEController.text = widget.product.img ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
  }

  void _calculateTotal() {
    final double price = double.tryParse(_priceTEController.text) ?? 0;
    final int qty = int.tryParse(_qtyTEController.text) ?? 0;
    final double total = price * qty;
    _totalPriceTEController.text = total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
        backgroundColor: AppColors.themeColor,
      ),
      backgroundColor: AppColors.bodyColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEController,
                  decoration: buildInputDecoration(
                    'Write product name',
                    'Product Name',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'write your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _codeTEController,
                  decoration: buildInputDecoration('product code', 'Code'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'write product code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _imageTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: buildInputDecoration('Image', 'image'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'input Image';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _priceTEController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: buildInputDecoration('product Price', 'Price'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'input price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _qtyTEController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: buildInputDecoration('product Qty', 'Qty'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'input qty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _totalPriceTEController,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: buildInputDecoration(
                    'Total price',
                    'Total price ',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'input total price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: _updateProductInProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () {
                      _updateProduct();
                    },
                    child: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      // indigo
                      foregroundColor: Colors.white,
                      // text/icon color
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(hintText, labelText) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      filled: true,
      fillColor: Colors.white70,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      border: OutlineInputBorder(borderSide: BorderSide.none),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = false;
    setState(() {});
    Uri uri = Uri.parse(Urls.updateProductUrl(widget.product.id!),);
    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _qtyTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _priceTEController.text.trim(),
    };
    Response response = await post(uri,headers: {'Content-type': 'application/json'},body:jsonEncode(requestBody));

      if(response.statusCode ==200){
        ScaffoldMessenger.of(context,).showSnackBar(SnackBar(content: Text('product Updated')));
        Navigator.pushReplacementNamed(context, ProductListScreen.name,arguments: true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('product not Updated')));
      }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameTEController.dispose();
    _codeTEController.dispose();
    _imageTEController.dispose();
    _priceTEController.dispose();
    _totalPriceTEController.dispose();
    _qtyTEController.dispose();
  }
}
