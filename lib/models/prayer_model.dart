import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerModel {
  final String id;
  final String userId;
  final String text;
  final Timestamp createdAt;
  final bool isPublic;

  PrayerModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.isPublic,
  });
}