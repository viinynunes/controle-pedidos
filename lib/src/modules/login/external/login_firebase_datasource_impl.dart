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
  Future<credential.UserCredential> getLoggedUser() {
    // TODO: implement getLoggedUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> login(credential.UserCredential user) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      final userSnap = await userCollection
          .doc(result.user!.uid)
          .get()
          .catchError((e) => throw FirebaseException(
              plugin: 'GET USER ERROR', message: e.toString()));

      return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
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
}
