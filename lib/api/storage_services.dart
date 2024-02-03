import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> uploadImageAndUpdateProfile(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = _firebaseAuth.currentUser!.uid;
      String imageName =
          'user_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask =
          _storage.ref().child(imageName).putFile(imageFile);
      TaskSnapshot storageSnapshot = await uploadTask;
      String downloadUrl = await storageSnapshot.ref.getDownloadURL();

      user!.updatePhotoURL(downloadUrl);
      await _firestore.collection('customer').doc(uid).update({
        'profile_image': downloadUrl,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

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

  Future<bool> editPromotion(String promoId, DateTime startDate,
      DateTime endDate, String name, String detail) async {
    try {
      await _firestore.collection("promotion").doc(promoId).update({
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
      String promoID, String serviceID, String ct, String addon) async {
    try {
      await _firestore.collection("appointment").add({
        'customer_id': uid,
        'date': date,
        'details': detail,
        'promotion_id': promoID,
        'service_id': serviceID,
        'time': time,
        'finished': "unapproved",
        'costomer_count': ct,
        'addon': addon
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateData(String nName, String nPhone, String nEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await _firestore
          .collection("customer")
          .doc(user!.uid)
          .update({'name': nName, 'phone_number': nPhone, 'email': nEmail});
      user.updateDisplayName(nName);
      user.updateEmail(nEmail);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setStatus(String docid, String status) async {
    try {
      await _firestore
          .collection("appointment")
          .doc(docid)
          .update({'finished': status});
      return true;
    } catch (e) {
      return false;
    }
  }
}
