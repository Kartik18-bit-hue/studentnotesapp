
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqlite_flutter_crud/task.dart'; // updated Task model
import 'package:sqlite_flutter_crud/todo_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks extends StatelessWidget {
  final Function(Task)? onTaskTap; // Defined on TaskTap
  final user = FirebaseAuth.instance.currentUser;

  Tasks({Key? key, this.onTaskTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: FirebaseFirestore.instance
          .collection("todos")
          .where("uid", isEqualTo: user?.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Task.fromFirestore(doc.data(), doc.id))
              .toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No tasks yet"));
        }

        final tasks = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: tasks.length + 1, // +1 for the "Add Task" tile
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index == tasks.length) {
                return _buildAddTask(context);
              } else {
                return _buildTask(context, tasks[index]);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildAddTask(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const TodoHomeScreen()));
      },
     
    );
  }

  Widget _buildTask(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TodoHomeScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: task.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(task.icon, color: Colors.white, size: 35),
            const SizedBox(height: 30),
            Text(task.title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 20),
            Text(task.description,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
