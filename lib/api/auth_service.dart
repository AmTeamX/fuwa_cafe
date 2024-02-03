import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> register(
    String username,
    String password,
    String phoneNumber,
    String emailAddress,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await credential.user!.updateDisplayName(username);
      await credential.user!.updatePhotoURL(
          "https://firebasestorage.googleapis.com/v0/b/fuwa-nail-cafe.appspot.com/o/defpic.jpg?alt=media&token=d1113876-d107-4876-aad3-56159335d6d3");

      final userId = credential.user!.uid;

      await _firestore.collection("customer").doc(userId).set({
        'id': userId,
        'email': emailAddress,
        'name': username,
        'phone_number': phoneNumber,
        'role': ""
      });

      return 'successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "successful";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      }
      return 'Error: ${e.message}';
    }
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> checkIsAdmin() async {
    User? user = _firebaseAuth.currentUser;
    Map<String, dynamic>? userData = {};
    await _firestore.collection("customer").doc(user!.uid).get().then((value) {
      userData = value.data();
    });
    if (userData?['role'] == "admin") {
      return true;
    }
    return false;
  }
}
