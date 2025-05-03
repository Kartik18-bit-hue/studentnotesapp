import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';
import 'package:sqlite_flutter_crud/SQLite/sqlite.dart';
import 'package:sqlite_flutter_crud/Views/create_note.dart';
import 'package:sqlite_flutter_crud/Authtentication/login.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      notes = handler.getNotes();
      handler.initDB().whenComplete(() {
        setState(() {
          notes = getAllNotes();
        });
      });
    }
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotes();
  }

  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNote()),
          ).then((value) {
            if (value) {
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: keyword,
              onChanged: (value) {
                setState(() {
                  notes = value.isNotEmpty ? searchNote() : getAllNotes();
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NoteModel>>(
              future: notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final items = snapshot.data ?? <NoteModel>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        subtitle: Text(items[index].createdAt),
                        title: Text(items[index].noteTitle),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            db.deleteNote(items[index].noteId!).whenComplete(() {
                              _refresh();
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            title.text = items[index].noteTitle;
                            content.text = items[index].noteContent;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          db.updateNote(
                                            title.text,
                                            content.text,
                                            items[index].noteId,
                                          ).whenComplete(() {
                                            _refresh();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text("Update"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ],
                                title: const Text("Update note"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: title,
                                      decoration: const InputDecoration(
                                        label: Text("Title"),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: content,
                                      decoration: const InputDecoration(
                                        label: Text("Content"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
