import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart'; // Import the database service
import '../models/user_model.dart'; // Import the user model

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();

  // Register with email & password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // If user creation is successful, create a new document for the user in Firestore
      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email!,
          name: 'New User', // You can get this from a text field in your UI
          denomination: 'Not set', // Set default values or get from UI
          prayerTone: 'Hopeful', // Set default values or get from UI
        );
        await _db.createUserDocument(newUser);
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
