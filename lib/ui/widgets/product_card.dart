import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';

class buildProductCard extends StatelessWidget {
  const buildProductCard({super.key, required this.product, required this.updateProductList, required this.deleteProduct,});
  final Product product;
  final VoidCallback updateProductList;
  final VoidCallback deleteProduct;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      child: ListTile(
        leading: SizedBox(
          height: 70,
          width: 70,
          child: Image.network(product.img?? 'Unknown', fit: BoxFit.cover),
        ),
        title: Text(product.productName?? 'Unknown',style: TextStyle(fontWeight: FontWeight.w600),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Code : ${product.productCode?? 'Unknown'}'),
            Text('Product price : ${product.unitPrice?? 'Unknown'}'),
            Text('Total price : ${product.totalPrice?? 'Unknown'}'),
            Text('Qty : ${product.qty?? 'Unknown'}'),
          ],
        ),
        trailing: Padding(


          padding: const EdgeInsets.all(8.0),

          child: Wrap(
            children: [

              IconButton(onPressed: () async{
                final updatedProduct =await Navigator.pushNamed(context, UpdateProductScreen.name,arguments: product);
                if(updatedProduct!=null && updatedProduct == true){
                  updateProductList();
                }
              }, icon: Icon(Icons.edit),color: Colors.green,),




              IconButton(onPressed: () {
                deleteProduct();
              }, 
                icon: Icon(Icons.delete),color: Colors.red,),
               
               
               
               
               PopupMenuButton<ProductOptions>(
                itemBuilder: (ctx) {
                  return [
                    PopupMenuItem(value: ProductOptions.update, child: Text('Update')),
                    PopupMenuItem(value: ProductOptions.delete, child: Text('Delete')),
                  ];
                },
                onSelected: (ProductOptions selectedOption) async {
                  if (selectedOption == ProductOptions.delete) {
                    deleteProduct();
                  }

                  else if (selectedOption == ProductOptions.update) {
                   final updatedProduct=  await Navigator.pushNamed(context, UpdateProductScreen.name,arguments: product);
                    if(updatedProduct != null && updatedProduct == true){
                      updateProductList();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
enum ProductOptions { update, delete }