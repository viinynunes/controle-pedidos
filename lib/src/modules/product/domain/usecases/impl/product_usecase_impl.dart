import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/domain/repositories/i_product_repository.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:controle_pedidos/src/modules/product/errors/product_error.dart';
import 'package:dartz/dartz.dart';

class ProductUsecaseImpl implements IProductUsecase {
  final IProductRepository _repository;

  ProductUsecaseImpl(this._repository);

  @override
  Future<Either<ProductError, Product>> createProduct(Product product) async {
    if (product.name.isEmpty || product.name.length < 2) {
      return Left(ProductError('Invalid name'));
    }

    if (product.category.isEmpty) {
      return Left(ProductError('Invalid category'));
    }

    if (product.provider.id.isEmpty) {
      return Left(ProductError('Invalid provider name'));
    }

    if (product.provider.name.isEmpty) {
      return Left(ProductError('Invalid provider name'));
    }

    return _repository.createProduct(product);
  }

  @override
  Future<Either<ProductError, Product>> updateProduct(Product product) async {
    if (product.id.isEmpty) {
      return Left(ProductError('Invalid id'));
    }

    if (product.name.isEmpty || product.name.length < 2) {
      return Left(ProductError('Invalid name'));
    }

    if (product.category.isEmpty) {
      return Left(ProductError('Invalid category'));
    }

    if (product.provider.id.isEmpty) {
      return Left(ProductError('Invalid provider name'));
    }

    if (product.provider.name.isEmpty) {
      return Left(ProductError('Invalid provider name'));
    }

    return _repository.updateProduct(product);
  }

  @override
  Future<Either<ProductError, List<Product>>> getEnabledProductListByProvider(
      String providerId) async {
    if (providerId.isEmpty) {
      return Left(ProductError('Invalid provider id'));
    }

    return _repository.getEnabledProductListByProvider(providerId);
  }

  @override
  Future<Either<ProductError, List<Product>>> getProductList() {
    return _repository.getProductList();
  }

  @override
  Future<Either<ProductError, List<Product>>> getProductListByEnabled() {
    return _repository.getProductListByEnabled();
  }

  @override
  Future<Either<ProductError, List<Product>>>
      getProductListByEnabledAndStockDefaultTrue() {
    return _repository.getProductListByEnabledAndStockDefaultTrue();
  }
}
