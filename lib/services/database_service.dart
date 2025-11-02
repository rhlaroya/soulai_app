import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart'; // Adjust the import path as needed

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a user document
  Future<void> createUserDocument(UserModel user) async {
    try {
      // Use the user's UID as the document ID
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  // Add a new prayer
  Future<void> addPrayer(String prayerText, bool isPublic) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle cases where the user is not logged in
      print("Cannot save prayer. User is not logged in.");
      return;
    }

    try {
      await _db.collection('prayers').add({
        'userId': user.uid,
        'text': prayerText,
        'isPublic': isPublic,
        'createdAt': FieldValue.serverTimestamp(), // Firestore handles the timestamp
      });
    } catch (e) {
      print('Error adding prayer: $e');
    }
  }
}
