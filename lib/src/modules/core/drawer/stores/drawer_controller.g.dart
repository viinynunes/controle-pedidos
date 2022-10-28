// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DrawerController on _DrawerControllerBase, Store {
  late final _$nameAtom =
      Atom(name: '_DrawerControllerBase.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$companyAtom =
      Atom(name: '_DrawerControllerBase.company', context: context);

  @override
  String get company {
    _$companyAtom.reportRead();
    return super.company;
  }

  @override
  set company(String value) {
    _$companyAtom.reportWrite(value, super.company, () {
      super.company = value;
    });
  }

  @override
  String toString() {
    return '''
name: ${name},
company: ${company}
    ''';
  }
}
