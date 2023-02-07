import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/domain/repositories/i_product_repository.dart';
import 'package:controle_pedidos/src/modules/product/errors/product_error.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:dartz/dartz.dart';

import '../datasources/i_product_datasource.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<Either<ProductError, Product>> createProduct(Product product) async {
    try {
      final result = await _datasource
          .createProduct(ProductModel.fromProduct(product: product));

      return Right(result);
    } catch (e) {
      return Left(ProductError(e.toString()));
    }
  }

  @override
  Future<Either<ProductError, Product>> updateProduct(Product product) async {
    try {
      final result = await _datasource
          .updateProduct(ProductModel.fromProduct(product: product));

      return Right(result);
    } catch (e) {
      return Left(ProductError(e.toString()));
    }
  }

  @override
  Future<Either<ProductError, List<Product>>> getEnabledProductListByProvider(
      String providerId) async {
    try {
      final result =
          await _datasource.getEnabledProductListByProvider(providerId);

      return Right(result);
    } catch (e) {
      return Left(ProductError(e.toString()));
    }
  }

  @override
  Future<Either<ProductError, List<Product>>> getProductList() async {
    try {
      final result = await _datasource.getProductList();

      return Right(result);
    } catch (e) {
      return Left(ProductError(e.toString()));
    }
  }

  @override
  Future<Either<ProductError, List<Product>>> getProductListByEnabled() async {
    try {
      final result = await _datasource.getProductListByEnabled();

      return Right(result);
    } catch (e) {
      return Left(ProductError(e.toString()));
    }
  }

  @override
  Future<Either<ProductError, List<Product>>>
      getProductListByEnabledAndStockDefaultTrue() async {
    try {
      final result =
          await _datasource.getProductListByEnabledAndStockDefaultTrue();

      return Right(result);
    } catch (e) {
      return Left(ProductError(e.toString()));
    }
  }
}
