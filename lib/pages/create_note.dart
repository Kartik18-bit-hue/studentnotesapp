import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';
import 'package:sqlite_flutter_crud/JsonModels/services/database_services.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDueDate;
  final _db = DatabaseServices();

  Future<void> _saveNote() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("User not logged in");

        final note = NoteModel(
          id: '', // Firestore will assign ID
          userId: user.uid,
          noteTitle: _titleController.text.trim(),
          noteContent: _contentController.text.trim(),
          createdAt: Timestamp.now(),
          dueDate: _selectedDueDate != null
              ? Timestamp.fromDate(_selectedDueDate!)
              : null,
        );

        await _db.addNote(note);

        if (!mounted) return;
        Navigator.of(context).pop(true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save note: $e")),
        );
      }
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter a title'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter content'
                        : null,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDueDate == null
                      ? "No Due Date Selected"
                      : "Due: ${_selectedDueDate!.toLocal().toString().split(' ')[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDueDate,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text("Save Note"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
