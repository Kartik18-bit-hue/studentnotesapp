import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlite_flutter_crud/JsonModels/services/database_services.dart';
import 'package:sqlite_flutter_crud/JsonModels/todo_model.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({super.key});

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    super.initState();
    uid = user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoModel>>(
      stream: _databaseServices.todos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TodoModel> todos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              TodoModel todoModel = todos[index];

              // Safely convert timestamp to DateTime
              DateTime dt;
              if (todoModel.timestamp is Timestamp) {
                dt = (todoModel.timestamp as Timestamp).toDate();
              } else if (todoModel.timestamp is DateTime) {
                dt = todoModel.timestamp as DateTime;
              } else {
                dt = DateTime.now(); // fallback or default
              }

              return Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todoModel.id),
                  child: ListTile(
                    title: Text(
                      todoModel.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todoModel.description,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Due: ${dt.day}/${dt.month}/${dt.year}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }
}
