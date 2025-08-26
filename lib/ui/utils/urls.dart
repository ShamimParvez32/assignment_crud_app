class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2008/api/v1';
  static const String addProductUrl='$_baseUrl/CreateProduct';
  static const String getProductUrl='$_baseUrl/ReadProduct';
  static  String updateProductUrl(String id)=>'$_baseUrl/UpdateProduct/$id';
  static  String deleteProductUrl(String id) =>'$_baseUrl/DeleteProduct/$id';
  static  String getProductByIdUrl(String id)=>'$_baseUrl/ReadProductById/$id';
}