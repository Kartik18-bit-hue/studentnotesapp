import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timestamp;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.timestamp,
  });
}
