import 'dart:developer';

import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/product/domain/repositories/i_product_repository.dart';
import 'package:controle_pedidos/src/modules/product/errors/product_info_exception.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/external_exception.dart';
import '../datasources/i_product_datasource.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<Either<ProductInfoException, Product>> createProduct(
      Product product) async {
    try {
      final result = await _datasource
          .createProduct(ProductModel.fromProduct(product: product));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProductInfoException('Erro interno no servidor'));
    } on ProductInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProductInfoException, Product>> updateProduct(
      Product product) async {
    try {
      final result = await _datasource
          .updateProduct(ProductModel.fromProduct(product: product));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProductInfoException('Erro interno no servidor'));
    } on ProductInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProductInfoException, List<Product>>>
      getEnabledProductListByProvider(String providerId) async {
    try {
      final result =
          await _datasource.getEnabledProductListByProvider(providerId);

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProductInfoException('Erro interno no servidor'));
    } on ProductInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProductInfoException, List<Product>>> getProductList() async {
    try {
      final result = await _datasource.getProductList();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProductInfoException('Erro interno no servidor'));
    } on ProductInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProductInfoException, List<Product>>>
      getProductListByEnabled() async {
    try {
      final result = await _datasource.getProductListByEnabled();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProductInfoException('Erro interno no servidor'));
    } on ProductInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProductInfoException, List<Product>>>
      getProductListByEnabledAndStockDefaultTrue() async {
    try {
      final result =
          await _datasource.getProductListByEnabledAndStockDefaultTrue();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProductInfoException('Erro interno no servidor'));
    } on ProductInfoException catch (e) {
      return Left(e);
    }
  }
}
