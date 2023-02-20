import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:controle_pedidos/src/modules/company/infra/datasources/i_company_datasource.dart';
import 'package:controle_pedidos/src/modules/login/errors/login_info_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/models/company_model.dart';
import '../../../domain/models/user_model.dart';
import '../infra/datasources/i_login_datasource.dart';
import '../presenter/models/user_credential.dart' as credential;

class LoginFirebaseDatasourceImpl implements ILoginDatasource {
  final FirebaseFirestore firebase;

  final firebaseAuth = FirebaseAuth.instance;
  late CollectionReference<Map<String, dynamic>> userCollection;
  late CollectionReference<Map<String, dynamic>> companyCollection;

  final ICompanyDatasource companyDatasource;

  LoginFirebaseDatasourceImpl(this.firebase, this.companyDatasource) {
    userCollection = firebase.collection('user');

    companyCollection = firebase.collection('company');
  }

  @override
  Future<UserModel> getLoggedUser() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      return await _getUserData(user.uid);
    }

    throw ExternalException(error: 'Get Logged User Error');
  }

  @override
  Future<UserModel> login(credential.UserCredential user) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      final loggedUser = await _getUserData(result.user?.uid ?? '');

      return loggedUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw LoginInfoException('Email não encontrado');
      }

      if (e.code == 'wrong-password') {
        throw LoginInfoException('Senha Incorreta');
      }
    } catch (e) {
      throw ExternalException(error: e.toString());
    }

    throw ExternalException(error: 'Loggin Error on External');
  }

  @override
  Future<void> logout() async {
    companyDatasource.logout();
    return await firebaseAuth.signOut();
  }

  Future<UserModel> _getUserData(String id) async {
    var userSnap = await userCollection.doc(id).get().onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    final companySnap =
        await companyCollection.doc(userSnap.get('companyID')).get();

    if (userSnap.data() == null || companySnap.data() == null) {
      throw ExternalException(error: 'Get User Data Error on External');
    }

    var userMap = userSnap.data();

    if (userMap != null) {
      userMap['company'] = companySnap.data();

      return UserModel.fromMap(map: userMap);
    }

    throw ExternalException(error: 'Get User Data Error on External');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw LoginInfoException('Email inválido');
      }

      if (e.code == 'invalid-email') {
        throw LoginInfoException('Email não encontrado');
      }
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      UserModel user, String password) async {
    try {
      final companyID =
          await _createCompany(CompanyModel.fromCompany(company: user.company));

      await _createCacheDocuments(companyID: companyID);

      final createdUser = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      await createdUser.user?.sendEmailVerification();

      return await _createUser(companyID, createdUser.user!.uid, user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw LoginInfoException('Email já utilizado');
      }

      if (e.code == 'invalid-email') {
        throw LoginInfoException('Email Inválido');
      }

      if (e.code == 'operation-not-allowed') {
        throw LoginInfoException('Email desativado');
      }

      if (e.code == 'week-password') {
        throw LoginInfoException('A senha escolhida é muito fraca');
      }

      throw ExternalException(error: 'Logout Error on External');
    }
  }

  Future<String> _createCompany(CompanyModel company) async {
    await companyCollection.add({}).then((value) => company.id = value.id);

    await companyCollection
        .doc(company.id)
        .update(CompanyModel.fromCompany(company: company).toMap())
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    return company.id;
  }

  _createUser(String companyID, String userID, UserModel user) async {
    user.id = userID;
    user.company.id = companyID;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .set(user.toMap())
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    await companyCollection
        .doc(companyID)
        .collection('user')
        .doc(userID)
        .set({'userID': userID}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    final userSnap = await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
  }

  _createCacheDocuments({required String companyID}) async {
    firebase
        .collection('company')
        .doc(companyID)
        .collection('client')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    firebase
        .collection('company')
        .doc(companyID)
        .collection('establishment')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    firebase
        .collection('company')
        .doc(companyID)
        .collection('order')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    firebase
        .collection('company')
        .doc(companyID)
        .collection('product')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    firebase
        .collection('company')
        .doc(companyID)
        .collection('provider')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    firebase
        .collection('company')
        .doc(companyID)
        .collection('stock')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }
}
