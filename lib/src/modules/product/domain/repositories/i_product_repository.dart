import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/errors/product_info_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IProductRepository {
  Future<Either<ProductInfoException, Product>> createProduct(Product product);

  Future<Either<ProductInfoException, Product>> updateProduct(Product product);

  Future<Either<ProductInfoException, List<Product>>> getProductListByEnabled();

  Future<Either<ProductInfoException, List<Product>>> getProductList();

  Future<Either<ProductInfoException, List<Product>>>
      getProductListByEnabledAndStockDefaultTrue();

  Future<Either<ProductInfoException, List<Product>>> getEnabledProductListByProvider(
      String providerId);
}
