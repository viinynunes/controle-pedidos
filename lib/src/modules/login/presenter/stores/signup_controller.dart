import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:string_validator/string_validator.dart';

import '../../domain/usecases/i_login_usecase.dart';
import '../../errors/login_error.dart';

part 'signup_controller.g.dart';

class SignupController = _SignupControllerBase with _$SignupController;

abstract class _SignupControllerBase with Store {
  final ILoginUsecase usecase;

  _SignupControllerBase(this.usecase);

  @observable
  bool loading = false;
  @observable
  bool showCompanyFields = true;
  @observable
  Option<LoginError> error = none();

  late GlobalKey<FormState> formKey;
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  @action
  initState() {
    formKey = GlobalKey<FormState>();
  }

  @action
  toggleShowCompanyFields() {
    showCompanyFields = !showCompanyFields;
  }

  @action
  signup() {
    if (isFormKeyValidated()) {}
  }

  isFormKeyValidated(){
    return formKey.currentState!.validate();
  }

  String? companyNameValidator(String? text) {
    if (companyNameController.text.isEmpty) {
      return 'Nome obrigatório';
    }

    return null;
  }

  String? userFullNameValidator(String? text) {
    if (fullNameController.text.isEmpty) {
      return 'Nome obrigatório';
    }

    return null;
  }

  String? emailValidator(String? text) {
    if (!isEmail(emailController.text)) {
      return 'Email inválido';
    }

    return null;
  }

  String? passwordValidator(String? text) {
    if (passwordController.text.length < 6) {
      return 'Senha muito curta';
    }

    return null;
  }

  String? confirmPasswordValidator(String? text) {
    if (passwordController.text != confirmPasswordController.text) {
      return 'As senhas não são iguais';
    }

    return null;
  }
}
