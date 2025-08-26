import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/product_details_screen.dart';
import 'package:assignment_crud_app/ui/screens/update_product_screen.dart';
import 'package:assignment_crud_app/ui/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class buildProductCard extends StatefulWidget {
  const buildProductCard({
    super.key,
    required this.product,
    //required this.updateProductList,
    required this.refreshProductList,
    //required this.deleteProduct,
  });

  final Product product;
  //final VoidCallback updateProductList;
  final VoidCallback refreshProductList;

  //final VoidCallback deleteProduct;

  @override
  State<buildProductCard> createState() => _buildProductCardState();


}

class _buildProductCardState extends State<buildProductCard> {



  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      child: ListTile(
        leading: SizedBox(
          height: 70,
          width: 70,
          child: Image.network(widget.product.img ?? 'Unknown', fit: BoxFit.cover),
        ),
        title: Text(
          widget.product.productName ?? 'Unknown',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Code : ${widget.product.productCode ?? 'Unknown'}'),
            Text('Product price : ${widget.product.unitPrice ?? 'Unknown'}'),
            Text('Total price : ${widget.product.totalPrice ?? 'Unknown'}'),
            Text('Qty : ${widget.product.qty ?? 'Unknown'}'),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailsScreen.name,
                    arguments: widget.product.id,
                  );
                },
                icon: Icon(Icons.description),
                color: Colors.green,
              ),

              PopupMenuButton<ProductOptions>(
                itemBuilder: (ctx) {
                  return [
                    PopupMenuItem(
                      value: ProductOptions.update,
                      child: Text('Update'),
                    ),
                    PopupMenuItem(
                      value: ProductOptions.delete,
                      child: Text('Delete'),
                    ),
                  ];
                },
                onSelected: (ProductOptions selectedOption) async {
                  if (selectedOption == ProductOptions.delete) {
                    _deleteProduct();
                  } else if (selectedOption == ProductOptions.update) {
                    final updatedProduct = await Navigator.pushNamed(
                      context,
                      UpdateProductScreen.name,
                      arguments: widget.product,
                    );
                    if (updatedProduct != null && updatedProduct == true) {
                      widget.refreshProductList();
                    }
                  }
                },
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailsScreen.name,arguments: widget.product.id,
          );
        },
      ),
    );
  }



  Future<void> _deleteProduct() async {


    Uri uri = Uri.parse(Urls.deleteProductUrl(widget.product.id!));
    Response response = await get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    if (response.statusCode == 200) {
      widget.refreshProductList();
    }
  }
}




enum ProductOptions { update, delete }
