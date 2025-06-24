import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String? id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp? createdAt;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json, String id) {
    return TodoModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
      createdAt: json['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
