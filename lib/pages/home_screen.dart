import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/pages/calculator.dart';
import 'package:sqlite_flutter_crud/pages/create_note.dart';
import 'package:sqlite_flutter_crud/pages/health.dart';
import 'package:sqlite_flutter_crud/todo_home_screen.dart';
import 'package:sqlite_flutter_crud/side_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToPage(BuildContext context, String title) {
    Widget page;
    switch (title) {
      case 'Tasks':
        page = const TodoHomeScreen();
        break;
      case 'Notes':
        page = const CreateNotePage();
        break;
      case 'Health':
        page = const HealthPage();
        break;
      case 'Calculator':
        page = const GpaCgpaInstantCalculator();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Page not implemented")),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const Drawer(child: SideMenu()),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Tasks',
                    color: Colors.blueAccent,
                    icon: Icons.check_circle,
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Notes',
                    color: Colors.orangeAccent,
                    icon: Icons.note_alt,
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Health',
                    color: Colors.green,
                    icon: Icons.favorite,
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Calculator',
                    color: Colors.red,
                    icon: Icons.calculate_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, title),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme,
      title: const Text(
        'Welcome',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      // No theme toggle button here
    );
  }
}
