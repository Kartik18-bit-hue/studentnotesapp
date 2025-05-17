import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqlite_flutter_crud/JsonModels/todo_model.dart';


class DatabaseServices {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("todos");

  User? user = FirebaseAuth.instance.currentUser;

  // Add todo task
  Future<DocumentReference> addTodoTask(
      String title, String description) async {
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update todo content
  Future<void> updateTodoContent(
      String id, String title, String description) async {
    final docRef = todoCollection.doc(id);
    return await docRef.update({
      'title': title,
      'description': description,
    });
  }

  // Update todo status
  Future<void> updateTodoCompletionStatus(String id, bool completed, String text) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  // Mark todo as deleted (update completed flag — optional renaming)
  Future<void> markTodoAsDeleted(String id) async {
    return await todoCollection.doc(id).update({'completed': true});
  }

  // Get pending tasks
  Stream<List<TodoModel>> get todos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Get completed tasks
  Stream<List<TodoModel>> get completedTodos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Convert Firestore snapshot to list of TodoModel
  List<TodoModel> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TodoModel(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        completed: doc['completed'] ?? false,
        timestamp: doc['createdAt'] ?? Timestamp.now(),
      );
    }).toList();
  }
}
