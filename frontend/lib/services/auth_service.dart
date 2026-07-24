import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register(UserModel user, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: password,
          );
      // Get generated UID
      String uid = userCredential.user!.uid;

      // Create updated user model with UID
      UserModel newUser = UserModel(
        uid: uid,
        email: user.email,
        username: user.username,
      );

      // Save user profile in Firestore
      await _firestore.collection('users').doc(uid).set(newUser.toMap());
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Login User
  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
