import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithPhoneNumber() async {
    try {
//  AuthResult result = await _auth.signInAnonymously();
//  FirebaseUser
    } catch (e) {}
  }
}
