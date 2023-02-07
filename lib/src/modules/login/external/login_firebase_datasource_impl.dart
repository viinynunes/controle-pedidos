import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/modules/company/infra/datasources/i_company_datasource.dart';
import 'package:controle_pedidos/src/modules/login/errors/login_error.dart';
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

    throw FirebaseException(plugin: 'Get Logged User Error');
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
        throw LoginError('Email não encontrado');
      }

      if (e.code == 'wrong-password') {
        throw LoginError('Senha Incorreta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    throw FirebaseAuthException(code: '', message: 'Erro');
  }

  @override
  Future<void> logout() async {
    companyDatasource.logout();
    return await firebaseAuth.signOut();
  }

  Future<UserModel> _getUserData(String id) async {
    final userSnap = await userCollection.doc(id).get().catchError((e) =>
        throw FirebaseException(
            plugin: 'GET USER ERROR', message: e.toString()));

    if (userSnap.exists) {
      return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
    }

    throw FirebaseException(plugin: 'GET USER ERROR', message: 'Error');
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

      await createdUser.user?.sendEmailVerification();

      final companyID =
          await _createCompany(CompanyModel.fromCompany(company: user.company));

      await _createCacheDocuments(companyID: companyID);

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

    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .set(user.toMap());

    await companyCollection
        .doc(companyID)
        .collection('user')
        .doc(userID)
        .set(user.toMap());

    final userSnap =
        await FirebaseFirestore.instance.collection('user').doc(userID).get();

    return UserModel.fromMap(map: userSnap.data() as Map<String, dynamic>);
  }

  _createCacheDocuments({required String companyID}) async {
    firebase
        .collection('company')
        .doc(companyID)
        .collection('client')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()});

    firebase
        .collection('company')
        .doc(companyID)
        .collection('establishment')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()});

    firebase
        .collection('company')
        .doc(companyID)
        .collection('order')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()});

    firebase
        .collection('company')
        .doc(companyID)
        .collection('product')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()});

    firebase
        .collection('company')
        .doc(companyID)
        .collection('provider')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()});

    firebase
        .collection('company')
        .doc(companyID)
        .collection('stock')
        .doc('00_cacheUpdated')
        .set({'updatedAt': DateTime.now()});
  }
}
