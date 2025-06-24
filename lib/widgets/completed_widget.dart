import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlite_flutter_crud/JsonModels/services/database_services.dart';
import 'package:sqlite_flutter_crud/JsonModels/todo_model.dart';

class CompletedWidget extends StatefulWidget {
  const CompletedWidget({super.key});

  @override
  State<CompletedWidget> createState() => _CompletedWidgetState();
}

class _CompletedWidgetState extends State<CompletedWidget> {
  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoModel>>(
      stream: _databaseServices.completedTodos,  // Use completedTodos stream
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TodoModel> completedTodos = snapshot.data!;

          if (completedTodos.isEmpty) {
            return const Center(child: Text("No completed tasks yet"));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: completedTodos.length,
            itemBuilder: (context, index) {
              TodoModel todo = completedTodos[index];

              // Convert timestamp to DateTime safely
              DateTime dt;
              if (todo.createdAt is Timestamp) {
                dt = (todo.createdAt as Timestamp).toDate();
              } else if (todo.createdAt is DateTime) {
                dt = todo.createdAt as DateTime;
              } else {
                dt = DateTime.now();
              }

              return Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _deleteTodo(todo),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.description,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Completed on: ${dt.day}/${dt.month}/${dt.year}",
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
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _deleteTodo(TodoModel todo) async {
    await _databaseServices.deleteTodo(todo.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deleted completed task")),
    );
  }
}
