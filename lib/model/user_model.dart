import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> userData = {};
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signIn(
      {required String email, required String password, required VoidCallback onSuccess, required VoidCallback onError}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async{
      firebaseUser = value.user;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onError();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut({required VoidCallback onLogout}) async {
    await _auth.signOut();
    userData = {};
    firebaseUser = null;
    onLogout();
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser!.uid)
            .get();

        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }
}
