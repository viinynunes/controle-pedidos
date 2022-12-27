import 'package:controle_pedidos/src/modules/login/errors/login_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/models/user_model.dart';
import '../../firebase_helper.dart';
import '../infra/datasources/i_login_datasource.dart';
import '../presenter/models/user_credential.dart' as credential;

class LoginFirebaseDatasourceImpl implements ILoginDatasource {
  final firebaseAuth = FirebaseHelper.firebaseAuth;
  final userCollection = FirebaseHelper.userCollection;

  @override
  Future<UserModel> getLoggedUser() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      return await _getUserData(user.uid);
    }

    throw FirebaseException(plugin: 'Get Logged User Error');
  }

  @override
  Future<UserModel> login(credential.UserCredential user) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      await _getUserData(result.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw LoginError('Email não encontrado');
      }

      if (e.code == 'wrong-password') {
        throw LoginError('Senha Incorreta');
      }
    }

    throw FirebaseAuthException(code: '', message: 'Erro');
  }

  @override
  Future<void> logout() async {
    return await firebaseAuth.signOut();
  }

  _getUserData(String id) async {
    final userSnap = await userCollection.doc(id).get().catchError((e) =>
        throw FirebaseException(
            plugin: 'GET USER ERROR', message: e.toString()));

    if (userSnap.exists) {
      return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw LoginError('Email inválido');
      }

      if (e.code == 'invalid-email') {
        throw LoginError('Email não encontrado');
      }
    }
  }
}
