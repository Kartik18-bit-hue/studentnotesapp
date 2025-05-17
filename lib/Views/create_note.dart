import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';

class CreateNotePage extends StatefulWidget {
  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveNote() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please log in to save notes.")));
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final note = NoteModel(
          id: '',
          userId: user.uid,
          noteTitle: _titleController.text.trim(),
          noteContent: _contentController.text.trim(),
          createdAt: Timestamp.now(),
        );

        await FirebaseFirestore.instance.collection('notes').add(note.toMap());
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save note: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter content' : null,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text("Save Note"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
