// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingController on _OnboardingControllerBase, Store {
  late final _$currentPageAtom =
      Atom(name: '_OnboardingControllerBase.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$_OnboardingControllerBaseActionController =
      ActionController(name: '_OnboardingControllerBase', context: context);

  @override
  dynamic initState() {
    final _$actionInfo = _$_OnboardingControllerBaseActionController
        .startAction(name: '_OnboardingControllerBase.initState');
    try {
      return super.initState();
    } finally {
      _$_OnboardingControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changePage(int page) {
    final _$actionInfo = _$_OnboardingControllerBaseActionController
        .startAction(name: '_OnboardingControllerBase.changePage');
    try {
      return super.changePage(page);
    } finally {
      _$_OnboardingControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic nextPage() {
    final _$actionInfo = _$_OnboardingControllerBaseActionController
        .startAction(name: '_OnboardingControllerBase.nextPage');
    try {
      return super.nextPage();
    } finally {
      _$_OnboardingControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPage: ${currentPage}
    ''';
  }
}
