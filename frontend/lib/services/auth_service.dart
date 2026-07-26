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

      String uid = userCredential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        email: user.email,
        username: user.username,
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());
    } on FirebaseAuthException catch (e) {
      throw Exception("${e.code}: ${e.message}");
    } on FirebaseException catch (e) {
      throw Exception("${e.code}: ${e.message}");
    }
  }

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

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
