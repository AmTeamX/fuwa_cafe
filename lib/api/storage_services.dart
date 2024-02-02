import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData() async {
    _firestore
        .collection("customer")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      return value.data();
    });
    return null;
  }

  Future<bool> addPromotions(
      DateTime startDate, DateTime endDate, String name, String detail) async {
    try {
      await _firestore.collection("promotion").add({
        'start_date': startDate,
        'end_date': endDate,
        'name': name,
        'detail': detail
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPromotions() async {
    List<Map<String, dynamic>> promotionsList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("promotion").get();

      for (var doc in querySnapshot.docs) {
        var data =
            doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        promotionsList.add({
          'id': doc.id,
          'name': data['name'],
        });
      }

      return promotionsList;
    } catch (e) {
      return [];
    }
  }

  Future<bool> booking(String uid, DateTime date, DateTime time, String detail,
      String promoID, String serviceID) async {
    try {
      await _firestore.collection("appointment").add({
        'customer_id': uid,
        'date': date,
        'details': detail,
        'promotion_id': promoID,
        'service_id': serviceID,
        'time': time,
        'finished': "unapproved"
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
