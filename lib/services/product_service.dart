import '../data/product_data.dart';

class ProductService {
  void sortProductsByName(List<ProductData> productList) {
    productList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
