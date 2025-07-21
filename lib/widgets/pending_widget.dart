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
  final DatabaseServices _databaseServices = DatabaseServices();
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

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
          final todos = snapshot.data!;

          if (todos.isEmpty) {
            return const Center(child: Text("No pending tasks"));
          }

          // Check for overdue and mark as completed
          for (var todo in todos) {
            if (todo.dueDate != null && todo.dueDate is Timestamp) {
              DateTime dueDate = (todo.dueDate as Timestamp).toDate();
              if (dueDate.isBefore(DateTime.now())) {
                _databaseServices.updateTodoCompletionStatus(todo.id!, true);
              }
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              // Get createdAt as DateTime
              DateTime createdAt = DateTime.now();
              if (todo.createdAt is Timestamp) {
                createdAt = (todo.createdAt as Timestamp).toDate();
              }

              // Get dueDate as DateTime
              DateTime? dueDate;
              if (todo.dueDate != null && todo.dueDate is Timestamp) {
                dueDate = (todo.dueDate as Timestamp).toDate();
              }

              // Check if overdue
              final bool isOverdue = dueDate != null && dueDate.isBefore(DateTime.now());

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _markAsCompleted(todo),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.check,
                        label: 'Done',
                      ),
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
                    title: Text(todo.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.description),
                        const SizedBox(height: 5),
                        if (dueDate != null)
                          Text(
                            "Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}",
                            style: TextStyle(
                              color: isOverdue ? Colors.red : Colors.grey,
                              fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                            ),
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

  void _markAsCompleted(TodoModel todo) async {
    await _databaseServices.updateTodoCompletionStatus(todo.id!, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Marked as completed")),
    );
  }

  void _deleteTodo(TodoModel todo) async {
    await _databaseServices.deleteTodo(todo.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Todo deleted")),
    );
  }
}
