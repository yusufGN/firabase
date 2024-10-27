import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  // pour avoir les mise à jour de l'utilisateur s'il est connecté ou non
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login with Email-Password pour connecter l'utilisateur
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Logout pour deconnecter l'utilisateur
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Create User with Email-Password pour créer un compte utilisateur
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
