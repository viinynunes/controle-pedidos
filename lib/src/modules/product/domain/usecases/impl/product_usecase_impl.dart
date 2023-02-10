import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/domain/repositories/i_product_repository.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:controle_pedidos/src/modules/product/errors/product_info_exception.dart';
import 'package:dartz/dartz.dart';

class ProductUsecaseImpl implements IProductUsecase {
  final IProductRepository _repository;

  ProductUsecaseImpl(this._repository);

  @override
  Future<Either<ProductInfoException, Product>> createProduct(Product product) async {
    if (product.name.isEmpty || product.name.length < 2) {
      return Left(ProductInfoException('Nome inválido'));
    }

    if (product.category.isEmpty) {
      return Left(ProductInfoException('Embalagem inválida'));
    }

    if (product.provider.id.isEmpty) {
      return Left(ProductInfoException('ID do fornecedor inválido'));
    }

    if (product.provider.name.isEmpty) {
      return Left(ProductInfoException('Nome do fornecedor inválido'));
    }

    return _repository.createProduct(product);
  }

  @override
  Future<Either<ProductInfoException, Product>> updateProduct(Product product) async {
    if (product.id.isEmpty) {
      return Left(ProductInfoException('Invalid id'));
    }

    if (product.name.isEmpty || product.name.length < 2) {
      return Left(ProductInfoException('Nome inválido'));
    }

    if (product.category.isEmpty) {
      return Left(ProductInfoException('Embalagem inválida'));
    }

    if (product.provider.id.isEmpty) {
      return Left(ProductInfoException('ID do fornecedor inválido'));
    }

    if (product.provider.name.isEmpty) {
      return Left(ProductInfoException('Nome do fornecedor inválido'));
    }

    return _repository.updateProduct(product);
  }

  @override
  Future<Either<ProductInfoException, List<Product>>> getEnabledProductListByProvider(
      String providerId) async {
    if (providerId.isEmpty) {
      return Left(ProductInfoException('ID do fornecedor inválido'));
    }

    return _repository.getEnabledProductListByProvider(providerId);
  }

  @override
  Future<Either<ProductInfoException, List<Product>>> getProductList() {
    return _repository.getProductList();
  }

  @override
  Future<Either<ProductInfoException, List<Product>>> getProductListByEnabled() {
    return _repository.getProductListByEnabled();
  }

  @override
  Future<Either<ProductInfoException, List<Product>>>
      getProductListByEnabledAndStockDefaultTrue() {
    return _repository.getProductListByEnabledAndStockDefaultTrue();
  }
}
