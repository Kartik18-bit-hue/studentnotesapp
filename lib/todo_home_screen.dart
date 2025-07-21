// ... your imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/services/database_services.dart';
import 'package:sqlite_flutter_crud/JsonModels/todo_model.dart';
import 'package:sqlite_flutter_crud/pages/create_task.dart';
import 'package:sqlite_flutter_crud/task.dart';
import 'package:sqlite_flutter_crud/tasks.dart';
import 'package:sqlite_flutter_crud/widgets/completed_widget.dart';
import 'package:sqlite_flutter_crud/widgets/pending_widget.dart';


class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseServices _databaseServices = DatabaseServices();
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    uid = user?.uid ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: StreamBuilder<List<TodoModel>>(
            stream: _databaseServices.allTodos,
            builder: (context, snapshot) {
              int pendingCount = 0;
              int completedCount = 0;

              if (snapshot.hasData) {
                final todos = snapshot.data!;
                pendingCount = todos.where((todo) => !todo.completed).length;
                completedCount = todos.where((todo) => todo.completed).length;
              }

              return TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Pending"),
                        const SizedBox(width: 6),
                        Chip(
                          label: Text(
                            "$pendingCount",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Completed"),
                        const SizedBox(width: 6),
                        Chip(
                          label: Text(
                            "$completedCount",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingWidget(),
          CompletedWidget(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
      
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateTaskPage()),
          );
        },
        tooltip: "Increment",
        
        child: const Icon(Icons.add),

      ),
    );
  }
}
