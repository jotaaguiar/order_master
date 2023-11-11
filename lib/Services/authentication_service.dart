import 'package:firebase_auth/firebase_auth.dart';

class authentication_service {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerUser(
      {required String username,
      required String email,
      required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await userCredential.user!.updateDisplayName(username);
  }

  Future<String?> authUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }
  String? getDisplayName() {
    return _firebaseAuth.currentUser?.displayName;
  }
}
