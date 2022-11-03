import '../../../../domain/models/product_model.dart';

abstract class IProductDatasource {
  Future<ProductModel> createProduct(ProductModel product);

  Future<ProductModel> updateProduct(ProductModel product);

  Future<List<ProductModel>> getProductListByEnabled();

  Future<List<ProductModel>> getProductList();

  Future<List<ProductModel>> getProductListByEnabledAndStockDefaultTrue();

  Future<List<ProductModel>> getEnabledProductListByProvider(String providerId);
}
