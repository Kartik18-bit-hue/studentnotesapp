import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sqlite_flutter_crud/pages/create_note.dart';
import 'package:sqlite_flutter_crud/Views/noteslistpage.dart';
import 'package:sqlite_flutter_crud/todo_home_screen.dart';

class _NavigationItem {
  final String title;
  final IconData icon;
  final Widget destination;

  const _NavigationItem(this.title, this.icon, this.destination);
}

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  /// Drawer Items
  static const List<_NavigationItem> _listItems = [
    _NavigationItem("Create Note", IconlyBold.editSquare, CreateNotePage()),
    _NavigationItem("Task Management", IconlyBold.bookmark, TodoHomeScreen()),
     _NavigationItem("Notes List", IconlyBold.notification, NotesListPage()),

  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _listItems.length,
          itemBuilder: (context, index) {
            final item = _listItems[index];
            return _buildDrawerItem(context, item);
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, _NavigationItem item) {
    return Card(
      color: Colors.grey[100],
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(item.icon, color: Colors.grey[700]),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        onTap: () {
          Navigator.of(context).pop(); // Close the drawer
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => item.destination),
          );
        },
      ),
    );
  }
}
