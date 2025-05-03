import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final currentUser = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await firestore.collection('notes').add({
                    'uid': currentUser?.uid,
                    'noteTitle': title.text,
                    'noteContent': content.text,
                    'createdAt': DateTime.now().toIso8601String(),
                  });

                  Navigator.of(context).pop(true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to save note: $e")),
                  );
                }
              }
            },
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: title,
                validator: (value) =>
                    value!.isEmpty ? "Title is required" : null,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              TextFormField(
                controller: content,
                validator: (value) =>
                    value!.isEmpty ? "Content is required" : null,
                decoration: const InputDecoration(
                  label: Text("Content"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
