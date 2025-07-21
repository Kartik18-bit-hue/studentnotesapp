import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/services/database_services.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseServices _databaseServices = DatabaseServices();

  DateTime? _selectedDueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDueDate == null
                          ? "No due date selected"
                          : "Due: ${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}",
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: const Text("Select Date"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitTask,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    DateTime today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _submitTask() async {
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();

    if (title.isEmpty || desc.isEmpty || _selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select a due date")),
      );
      return;
    }

    // Add task with title, description, and due date
    await _databaseServices.addTodoTaskWithDueDate(title, desc, _selectedDueDate!);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task created and added to Pending")),
    );
  }
}
