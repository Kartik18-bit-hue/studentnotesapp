import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final IconData icon;
  final Color color;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.icon,
    required this.color,
  });

  // Factory to convert Firestore doc to Task
  factory Task.fromFirestore(Map<String, dynamic> data, String docId) {
    return Task(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      icon: _getIconFromString(data['icon'] ?? 'task'),
      color: _getColorFromHex(data['color'] ?? '#FFD600'),
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'work':
        return Icons.work;
      case 'person':
        return Icons.person;
      default:
        return Icons.task;
    }
  }

  static Color _getColorFromHex(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("FF$hex", radix: 16));
  }
}
