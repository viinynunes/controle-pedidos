import 'package:controle_pedidos/src/modules/product/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/errors/product_error.dart';
import 'package:dartz/dartz.dart';

abstract class IProductRepository {
  Future<Either<ProductError, Product>> createProduct(Product product);

  Future<Either<ProductError, Product>> updateProduct(Product product);

  Future<Either<ProductError, List<Product>>> getProductListByEnabled();

  Future<Either<ProductError, List<Product>>> getProductList();

  Future<Either<ProductError, List<Product>>>
      getProductListByEnabledAndStockDefaultTrue();

  Future<Either<ProductError, List<Product>>> getEnabledProductListByProvider(
      String providerId);
}
