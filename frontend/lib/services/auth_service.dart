// this is just a temporary version so login/register work for now
// friend will change the inside of these functions to use real Firebase

class AuthService {
  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      return "Please fill in both fields";
    }

    // friend: put FirebaseAuth signInWithEmailAndPassword here later

    return null;
  }

  Future<String?> register(
    String fullName,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      return "Please fill in all fields";
    }

    // friend: put FirebaseAuth createUserWithEmailAndPassword here later

    return null;
  }

  Future<void> logout() async {
    // friend: put FirebaseAuth signOut here later
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
