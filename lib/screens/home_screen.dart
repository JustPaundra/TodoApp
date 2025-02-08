import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/stats_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  int _selectedFilterIndex = 0;

  void _addTodo(String title, DateTime deadline) {
    setState(() {
      _todos.add(Todo(
        id: DateTime.now().toString(),
        title: title,
        deadline: deadline,
        isCompleted: false,
        createdAt: DateTime.now(),
      ));
    });
  }

  void _editTodo(String id, String newTitle, DateTime newDeadline) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(
          title: newTitle,
          deadline: newDeadline,
        );
      }
    });
  }

  void _toggleTodo(String id, bool newValue) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(isCompleted: newValue);
      }
    });
  }

  List<Todo> _getFilteredTodos() {
    if (_selectedFilterIndex == 1) {
      return _todos.where((todo) => todo.isCompleted).toList();
    } else if (_selectedFilterIndex == 2) {
      return _todos.where((todo) => todo.isOverdue).toList();
    }
    return _todos;
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(onAdd: _addTodo),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatsDialog(todos: _todos),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          ToggleButtons(
            isSelected: [
              _selectedFilterIndex == 0,
              _selectedFilterIndex == 1,
              _selectedFilterIndex == 2,
            ],
            onPressed: (index) {
              setState(() => _selectedFilterIndex = index);
            },
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            color: Colors.black,
            fillColor: Colors.blue,
            children: const [
              Padding(padding: EdgeInsets.all(8), child: Text("All")),
              Padding(padding: EdgeInsets.all(8), child: Text("Completed")),
              Padding(padding: EdgeInsets.all(8), child: Text("Overdue")),
            ],
          ),
          Expanded(
            child: ListView(
              children: _getFilteredTodos().map((todo) {
                return TodoItem(
                  todo: todo,
                  onToggle: _toggleTodo,
                  onDelete: (id) => setState(() => _todos.removeWhere((t) => t.id == id)),
                  onEdit: _editTodo,
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
