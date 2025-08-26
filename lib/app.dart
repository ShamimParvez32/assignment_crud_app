import 'package:assignment_crud_app/data/product.dart';
import 'package:assignment_crud_app/ui/screens/add_product_screen.dart';
import 'package:assignment_crud_app/ui/screens/product_details_screen.dart';
import 'package:assignment_crud_app/ui/screens/product_list_screen.dart';
import 'package:assignment_crud_app/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings setting){
       late Widget widget;
       if(setting.name =='/'){
         widget = const ProductListScreen();
       } else if(setting.name == AddProductScreen.name){
         widget =const AddProductScreen();
       }else if(setting.name == UpdateProductScreen.name){
         Product product = setting.arguments as Product;
         widget = UpdateProductScreen(product: product);
       }else if(setting.name == ProductDetailsScreen.name){
         final id = setting.arguments as String;
         widget = ProductDetailsScreen(id: id);
       }

       return MaterialPageRoute(builder: (context) => widget);

      },
    );
  }
}
