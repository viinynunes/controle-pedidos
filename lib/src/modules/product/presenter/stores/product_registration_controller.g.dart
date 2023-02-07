// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_registration_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductRegistrationController
    on _ProductRegistrationControllerBase, Store {
  late final _$loadingAtom = Atom(
      name: '_ProductRegistrationControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$newProductAtom = Atom(
      name: '_ProductRegistrationControllerBase.newProduct', context: context);

  @override
  bool get newProduct {
    _$newProductAtom.reportRead();
    return super.newProduct;
  }

  @override
  set newProduct(bool value) {
    _$newProductAtom.reportWrite(value, super.newProduct, () {
      super.newProduct = value;
    });
  }

  late final _$enabledAtom = Atom(
      name: '_ProductRegistrationControllerBase.enabled', context: context);

  @override
  bool get enabled {
    _$enabledAtom.reportRead();
    return super.enabled;
  }

  @override
  set enabled(bool value) {
    _$enabledAtom.reportWrite(value, super.enabled, () {
      super.enabled = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_ProductRegistrationControllerBase.error', context: context);

  @override
  Option<ProductError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<ProductError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$successAtom = Atom(
      name: '_ProductRegistrationControllerBase.success', context: context);

  @override
  Option<Product> get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(Option<Product> value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$providerListAtom = Atom(
      name: '_ProductRegistrationControllerBase.providerList',
      context: context);

  @override
  ObservableList<Provider> get providerList {
    _$providerListAtom.reportRead();
    return super.providerList;
  }

  @override
  set providerList(ObservableList<Provider> value) {
    _$providerListAtom.reportWrite(value, super.providerList, () {
      super.providerList = value;
    });
  }

  late final _$selectedProviderAtom = Atom(
      name: '_ProductRegistrationControllerBase.selectedProvider',
      context: context);

  @override
  Provider? get selectedProvider {
    _$selectedProviderAtom.reportRead();
    return super.selectedProvider;
  }

  @override
  set selectedProvider(Provider? value) {
    _$selectedProviderAtom.reportWrite(value, super.selectedProvider, () {
      super.selectedProvider = value;
    });
  }

  late final _$initStateAsyncAction = AsyncAction(
      '_ProductRegistrationControllerBase.initState',
      context: context);

  @override
  Future initState(Product? product) {
    return _$initStateAsyncAction.run(() => super.initState(product));
  }

  late final _$getProviderListByEnabledAsyncAction = AsyncAction(
      '_ProductRegistrationControllerBase.getProviderListByEnabled',
      context: context);

  @override
  Future getProviderListByEnabled() {
    return _$getProviderListByEnabledAsyncAction
        .run(() => super.getProviderListByEnabled());
  }

  late final _$getProviderFromProductAsyncAction = AsyncAction(
      '_ProductRegistrationControllerBase.getProviderFromProduct',
      context: context);

  @override
  Future getProviderFromProduct() {
    return _$getProviderFromProductAsyncAction
        .run(() => super.getProviderFromProduct());
  }

  late final _$saveOrUpdateAsyncAction = AsyncAction(
      '_ProductRegistrationControllerBase.saveOrUpdate',
      context: context);

  @override
  Future saveOrUpdate(BuildContext context) {
    return _$saveOrUpdateAsyncAction.run(() => super.saveOrUpdate(context));
  }

  late final _$_ProductRegistrationControllerBaseActionController =
      ActionController(
          name: '_ProductRegistrationControllerBase', context: context);

  @override
  dynamic changeEnabled() {
    final _$actionInfo = _$_ProductRegistrationControllerBaseActionController
        .startAction(name: '_ProductRegistrationControllerBase.changeEnabled');
    try {
      return super.changeEnabled();
    } finally {
      _$_ProductRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectProvider(Provider provider) {
    final _$actionInfo = _$_ProductRegistrationControllerBaseActionController
        .startAction(name: '_ProductRegistrationControllerBase.selectProvider');
    try {
      return super.selectProvider(provider);
    } finally {
      _$_ProductRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
newProduct: ${newProduct},
enabled: ${enabled},
error: ${error},
success: ${success},
providerList: ${providerList},
selectedProvider: ${selectedProvider}
    ''';
  }
}
