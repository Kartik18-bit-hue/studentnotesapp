import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String userId;
  final String noteTitle;
  final String noteContent;
  final Timestamp createdAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.noteTitle,
    required this.noteContent,
    required this.createdAt,
  });

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      noteTitle: data['noteTitle'] ?? '',
      noteContent: data['noteContent'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'createdAt': createdAt,
    };
  }
}
