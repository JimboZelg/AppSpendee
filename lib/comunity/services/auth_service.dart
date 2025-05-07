import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart'; // Asegúrate de tener esta ruta correcta

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // ✅ Nuevo método para obtener el usuario como CommunityUser
  Future<CommunityUser> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    return CommunityUser(
      id: user.uid,
      name: user.displayName ?? 'Anónimo',
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  Future<CommunityUser> fetchCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Usuario no autenticado',
      );
    }

    return CommunityUser(
      id: user.uid,
      name: user.displayName ?? 'Anónimo',
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}


