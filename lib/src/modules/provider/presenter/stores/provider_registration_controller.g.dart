// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_registration_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProviderRegistrationController
    on _ProviderRegistrationControllerBase, Store {
  late final _$loadingAtom = Atom(
      name: '_ProviderRegistrationControllerBase.loading', context: context);

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

  late final _$newProviderAtom = Atom(
      name: '_ProviderRegistrationControllerBase.newProvider',
      context: context);

  @override
  bool get newProvider {
    _$newProviderAtom.reportRead();
    return super.newProvider;
  }

  @override
  set newProvider(bool value) {
    _$newProviderAtom.reportWrite(value, super.newProvider, () {
      super.newProvider = value;
    });
  }

  late final _$enabledAtom = Atom(
      name: '_ProviderRegistrationControllerBase.enabled', context: context);

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

  late final _$establishmentListAtom = Atom(
      name: '_ProviderRegistrationControllerBase.establishmentList',
      context: context);

  @override
  ObservableList<Establishment> get establishmentList {
    _$establishmentListAtom.reportRead();
    return super.establishmentList;
  }

  @override
  set establishmentList(ObservableList<Establishment> value) {
    _$establishmentListAtom.reportWrite(value, super.establishmentList, () {
      super.establishmentList = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_ProviderRegistrationControllerBase.error', context: context);

  @override
  Option<ProviderInfoException> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<ProviderInfoException> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$successAtom = Atom(
      name: '_ProviderRegistrationControllerBase.success', context: context);

  @override
  Option<bool> get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(Option<bool> value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$selectedEstablishmentAtom = Atom(
      name: '_ProviderRegistrationControllerBase.selectedEstablishment',
      context: context);

  @override
  Establishment? get selectedEstablishment {
    _$selectedEstablishmentAtom.reportRead();
    return super.selectedEstablishment;
  }

  @override
  set selectedEstablishment(Establishment? value) {
    _$selectedEstablishmentAtom.reportWrite(value, super.selectedEstablishment,
        () {
      super.selectedEstablishment = value;
    });
  }

  late final _$initStateAsyncAction = AsyncAction(
      '_ProviderRegistrationControllerBase.initState',
      context: context);

  @override
  Future initState(Provider? provider) {
    return _$initStateAsyncAction.run(() => super.initState(provider));
  }

  late final _$getEstablishmentByEnabledAsyncAction = AsyncAction(
      '_ProviderRegistrationControllerBase.getEstablishmentByEnabled',
      context: context);

  @override
  Future getEstablishmentByEnabled() {
    return _$getEstablishmentByEnabledAsyncAction
        .run(() => super.getEstablishmentByEnabled());
  }

  late final _$getEstablishmentFromProviderAsyncAction = AsyncAction(
      '_ProviderRegistrationControllerBase.getEstablishmentFromProvider',
      context: context);

  @override
  Future getEstablishmentFromProvider() {
    return _$getEstablishmentFromProviderAsyncAction
        .run(() => super.getEstablishmentFromProvider());
  }

  late final _$saveOrUpdateAsyncAction = AsyncAction(
      '_ProviderRegistrationControllerBase.saveOrUpdate',
      context: context);

  @override
  Future saveOrUpdate(BuildContext context) {
    return _$saveOrUpdateAsyncAction.run(() => super.saveOrUpdate(context));
  }

  late final _$_ProviderRegistrationControllerBaseActionController =
      ActionController(
          name: '_ProviderRegistrationControllerBase', context: context);

  @override
  dynamic changeEnabled() {
    final _$actionInfo = _$_ProviderRegistrationControllerBaseActionController
        .startAction(name: '_ProviderRegistrationControllerBase.changeEnabled');
    try {
      return super.changeEnabled();
    } finally {
      _$_ProviderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectEstablishment(Establishment establishment) {
    final _$actionInfo =
        _$_ProviderRegistrationControllerBaseActionController.startAction(
            name: '_ProviderRegistrationControllerBase.selectEstablishment');
    try {
      return super.selectEstablishment(establishment);
    } finally {
      _$_ProviderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
newProvider: ${newProvider},
enabled: ${enabled},
establishmentList: ${establishmentList},
error: ${error},
success: ${success},
selectedEstablishment: ${selectedEstablishment}
    ''';
  }
}
