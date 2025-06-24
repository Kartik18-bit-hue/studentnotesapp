import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqlite_flutter_crud/JsonModels/todo_model.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';

class DatabaseServices {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // ---------- Todos ----------
  CollectionReference get userTodoCollection {
    final user = currentUser;
    if (user == null) throw Exception("User not logged in");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("todos");
  }

  Future<DocumentReference?> addTodoTask(String title, String description) async {
    try {
      return await userTodoCollection.add({
        'title': title,
        'description': description,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding task: $e");
      return null;
    }
  }

  Future<void> updateTodoContent(String id, String title, String description) async {
    try {
      await userTodoCollection.doc(id).update({
        'title': title,
        'description': description,
      });
    } catch (e) {
      print("Error updating content: $e");
    }
  }

  Future<void> updateTodoCompletionStatus(String id, bool completed) async {
    try {
      await userTodoCollection.doc(id).update({'completed': completed});
    } catch (e) {
      print("Error updating completion: $e");
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await userTodoCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }

  Stream<List<TodoModel>> get todos {
    return userTodoCollection
        .where('completed', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  Stream<List<TodoModel>> get completedTodos {
    return userTodoCollection
        .where('completed', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  List<TodoModel> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TodoModel.fromJson(data, doc.id);
    }).toList();
  }

  // ---------- Notes ----------
  CollectionReference get userNoteCollection {
    final user = currentUser;
    if (user == null) throw Exception("User not logged in");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("notes");
  }

  Future<DocumentReference?> addNote(NoteModel note) async {
    try {
      return await userNoteCollection.add(note.toMap());
    } catch (e) {
      print("Error adding note: $e");
      return null;
    }
  }

  Future<void> updateNote(String id, {required String title, required String content}) async {
    try {
      await userNoteCollection.doc(id).update({
        'noteTitle': title,
        'noteContent': content,
      });
    } catch (e) {
      print("Error updating note: $e");
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await userNoteCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Stream<List<NoteModel>> get notes {
    return userNoteCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_noteListFromSnapshot);
  }

  Stream<List<NoteModel>> notesDueBefore(DateTime date) {
    return userNoteCollection
        .where('dueDate', isLessThan: Timestamp.fromDate(date))
        .orderBy('dueDate', descending: true)
        .snapshots()
        .map(_noteListFromSnapshot);
  }

  List<NoteModel> _noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return NoteModel.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }
}
