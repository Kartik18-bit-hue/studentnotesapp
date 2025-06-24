import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String userId;
  final String noteTitle;
  final String noteContent;
  final Timestamp? createdAt;
  final Timestamp? dueDate;

  NoteModel({
    required this.id,
    required this.userId,
    required this.noteTitle,
    required this.noteContent,
    this.createdAt,
    this.dueDate,
  });

  factory NoteModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return NoteModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      noteTitle: data['noteTitle'] as String? ?? '',
      noteContent: data['noteContent'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      dueDate: data['dueDate'] as Timestamp?,
    );
  }

  factory NoteModel.fromMap(Map<String, dynamic> data, String id) {
    return NoteModel(
      id: id,
      userId: data['userId'] as String? ?? '',
      noteTitle: data['noteTitle'] as String? ?? '',
      noteContent: data['noteContent'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      dueDate: data['dueDate'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      if (createdAt != null) 'createdAt': createdAt,
      if (dueDate != null) 'dueDate': dueDate,
    };
  }

  NoteModel copyWith({
    String? noteTitle,
    String? noteContent,
    Timestamp? createdAt,
    Timestamp? dueDate,
  }) {
    return NoteModel(
      id: id,
      userId: userId,
      noteTitle: noteTitle ?? this.noteTitle,
      noteContent: noteContent ?? this.noteContent,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
