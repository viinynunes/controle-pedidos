import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:string_validator/string_validator.dart';

import '../../domain/usecases/i_login_usecase.dart';
import '../../errors/login_info_exception.dart';
import '../models/user_credential.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final ILoginUsecase loginUsecase;

  _LoginControllerBase(this.loginUsecase);

  @observable
  bool loading = false;
  @observable
  bool passwordResetEmailSentSucceffuly = false;
  @observable
  Option<LoginInfoException> error = none();

  late GlobalKey<FormState> formKey;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @action
  initState() {
    formKey = GlobalKey<FormState>();
  }

  String? emailValidator(String? text) {
    if (!isEmail(text!)) {
      return 'Email inválido';
    }

    return null;
  }

  String? passwordValidator(String? text) {
    if (!isAlphanumeric(text!)) {
      return 'Senha inválida';
    }

    if (text.length < 6){
      return 'Senha muito curta';
    }

    return null;
  }

  login() async {
    loading = true;

    final result = await loginUsecase.login(UserCredential(
        email: emailController.text.trim(), password: passwordController.text));

    result.fold((l) => error = optionOf(l), (r) => {});

    loading = false;
  }

  initUserModel() {
    return UserCredential(
        email: emailController.text.trim(), password: passwordController.text);
  }

  @action
  Future<String> sendPasswordResetEmail() async {
    final result =
        await loginUsecase.sendPasswordResetEmail(emailController.text.trim());

    result.fold((l) {
      passwordResetEmailSentSucceffuly = false;
    }, (r) async {
      passwordResetEmailSentSucceffuly = true;

      await Future.delayed(const Duration(seconds: 10));

      passwordResetEmailSentSucceffuly = false;
    });

    return '';
  }
}
