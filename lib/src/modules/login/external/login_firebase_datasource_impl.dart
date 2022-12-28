import 'package:controle_pedidos/src/modules/login/errors/login_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/models/company_model.dart';
import '../../../domain/models/user_model.dart';
import '../../firebase_helper.dart';
import '../infra/datasources/i_login_datasource.dart';
import '../presenter/models/user_credential.dart' as credential;

class LoginFirebaseDatasourceImpl implements ILoginDatasource {
  final firebaseAuth = FirebaseHelper.firebaseAuth;
  final userCollection = FirebaseHelper.userCollection;
  final companyCollection = FirebaseHelper.companyCollection;

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

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      UserModel user, String password) async {
    try {
      final createdUser = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      final companyID =
          await _createCompany(CompanyModel.fromCompany(company: user.company));

      return await _createUser(companyID, createdUser.user!.uid, user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw LoginError('Email já utilizado');
      }

      if (e.code == 'invalid-email') {
        throw LoginError('Email Inválido');
      }

      if (e.code == 'operation-not-allowed') {
        throw LoginError('Email desativado');
      }

      if (e.code == 'week-password') {
        throw LoginError('A senha escolhida é muito fraca');
      }

      throw LoginError('Unexpected error');
    }
  }

  Future<String> _createCompany(CompanyModel company) async {
    await companyCollection.add({}).then((value) => company.id = value.id);

    await companyCollection
        .doc(company.id)
        .update(CompanyModel.fromCompany(company: company).toMap());

    return company.id;
  }

  _createUser(String companyID, String userID, UserModel user) async {
    user.id = userID;
    user.company.id = companyID;

    await companyCollection
        .doc(companyID)
        .collection('user')
        .doc(userID)
        .set(user.toMap());

    final userSnap = await companyCollection
        .doc(companyID)
        .collection('user')
        .doc(userID)
        .get();

    return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
  }
}
