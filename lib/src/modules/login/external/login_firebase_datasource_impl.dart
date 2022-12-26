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
    final result = await firebaseAuth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .catchError((e) => throw FirebaseAuthException(
            code: 'LOGIN ERROR', message: e.toString()));

    if (result.user != null) {
      final userSnap = await userCollection
          .doc(result.user!.uid)
          .get()
          .catchError((e) => throw FirebaseException(
              plugin: 'GET USER ERROR', message: e.toString()));

      return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
    }

    throw FirebaseException(plugin: 'Login Error');
  }

  @override
  Future<void> logout() async {
    return await firebaseAuth.signOut();
  }
}
