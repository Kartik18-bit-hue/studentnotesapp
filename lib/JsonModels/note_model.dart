import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String userId;
  final String noteTitle;
  final String noteContent;
  final Timestamp createdAt;
  final Timestamp? dueDate; // ✅ Add this

  NoteModel({
    required this.id,
    required this.userId,
    required this.noteTitle,
    required this.noteContent,
    required this.createdAt,
    this.dueDate, // ✅ Add this
  });

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      userId: data['userId'],
      noteTitle: data['noteTitle'],
      noteContent: data['noteContent'],
      createdAt: data['createdAt'],
      dueDate: data['dueDate'], // ✅ Add this
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'createdAt': createdAt,
      'dueDate': dueDate, // ✅ Add this
    };
  }
}
