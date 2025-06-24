import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({Key? key}) : super(key: key);

  Stream<List<NoteModel>> _fetchNotes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    // ✅ Fetch from user's notes subcollection
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoteModel.fromDoc(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notes")),
      body: StreamBuilder<List<NoteModel>>(
        stream: _fetchNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text("No notes available."));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    note.noteTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    note.noteContent,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to note detail/edit screen
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
