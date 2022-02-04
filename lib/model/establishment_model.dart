import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:scoped_model/scoped_model.dart';

class EstablishmentModel extends Model {
  final firebaseEstablishments =
      FirebaseFirestore.instance.collection('establishments');

  bool isLoading = false;

  void createEstablishment(EstablishmentData establishment) {
    isLoading = true;
    firebaseEstablishments.doc().set(establishment.toMap());
    isLoading = false;
    notifyListeners();
  }

  void updateEstablishment(EstablishmentData establishment) {
    isLoading = true;
    firebaseEstablishments.doc(establishment.id).update(establishment.toMap());
    isLoading = false;
    notifyListeners();
  }

  void disableEstablishment(EstablishmentData establishment) {
    isLoading = true;
    establishment.enabled = false;
    firebaseEstablishments.doc(establishment.id).update(establishment.toMap());
    isLoading = false;
    notifyListeners();
  }

  Future<List<EstablishmentData>> getEnabledEstablishments() async {
    isLoading = true;
    List<EstablishmentData> estabList = [];
    final snapshot = await firebaseEstablishments
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();

    for (DocumentSnapshot e in snapshot.docs) {
      estabList.add(EstablishmentData.fromDocSnapshot(e));
    }
    isLoading = false;
    notifyListeners();
    return estabList;
  }
}
