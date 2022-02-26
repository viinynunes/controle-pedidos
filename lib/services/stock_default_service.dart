import 'package:controle_pedidos/data/product_data.dart';

class StockDefaultService {
  List<ProductData> orderProductsByProviderAndName(List<ProductData> list) {
    list.sort((a, b) {
      int compare = a.provider.name
          .toLowerCase()
          .compareTo(b.provider.name.toLowerCase());

      if (compare == 0) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else {
        return compare;
      }
    });

    return list;
  }
}
