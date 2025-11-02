class UserModel {
  final String uid;
  final String name;
  final String email;
  final String denomination;
  final String prayerTone;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.denomination,
    required this.prayerTone,
  });

  // A method to convert a UserModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'denomination': denomination,
      'prayerTone': prayerTone,
    };
  }
}
