import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/stats_dialog.dart';

enum TodoSort { createdDesc, createdAsc, deadlineAsc, deadlineDesc }
enum TodoFilter { all, active, completed, overdue }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  TodoSort _currentSort = TodoSort.createdDesc;
  TodoFilter _currentFilter = TodoFilter.all;

  List<Todo> get _filteredAndSortedTodos {
    List<Todo> filteredTodos = [..._todos];

    // Apply filter
    switch (_currentFilter) {
      case TodoFilter.active:
        filteredTodos = filteredTodos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.completed:
        filteredTodos = filteredTodos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.overdue:
        filteredTodos = filteredTodos.where((todo) => todo.isOverdue).toList();
        break;
      default:
        break;
    }

    // Apply sort
    switch (_currentSort) {
      case TodoSort.createdDesc:
        filteredTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TodoSort.createdAsc:
        filteredTodos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TodoSort.deadlineAsc:
        filteredTodos.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case TodoSort.deadlineDesc:
        filteredTodos.sort((a, b) => b.deadline.compareTo(a.deadline));
        break;
    }

    return filteredTodos;
  }

  void _addTodo(String title, DateTime deadline) {
    setState(() {
      _todos.add(Todo(
        id: DateTime.now().toString(),
        title: title,
        isCompleted: false,
        createdAt: DateTime.now(),
        deadline: deadline,
      ));
    });
  }

  void _toggleTodo(String id) {
    setState(() {
      final todoIndex = _todos.indexWhere((todo) => todo.id == id);
      _todos[todoIndex].isCompleted = !_todos[todoIndex].isCompleted;
      _todos[todoIndex].completedAt = _todos[todoIndex].isCompleted ? DateTime.now() : null;
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _showStats() {
    showDialog(
      context: context,
      builder: (context) => StatsDialog(todos: _todos),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: _showStats,
          ),
          PopupMenuButton<TodoSort>(
            icon: const Icon(Icons.sort_outlined),
            onSelected: (TodoSort sort) {
              setState(() {
                _currentSort = sort;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TodoSort.createdDesc,
                child: Text('Newest First'),
              ),
              const PopupMenuItem(
                value: TodoSort.createdAsc,
                child: Text('Oldest First'),
              ),
              const PopupMenuItem(
                value: TodoSort.deadlineAsc,
                child: Text('Deadline: Nearest'),
              ),
              const PopupMenuItem(
                value: TodoSort.deadlineDesc,
                child: Text('Deadline: Farthest'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(TodoFilter.all, 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip(TodoFilter.active, 'Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip(TodoFilter.completed, 'Completed'),
                  const SizedBox(width: 8),
                  _buildFilterChip(TodoFilter.overdue, 'Overdue'),
                ],
              ),
            ),
          ),
          Expanded(
            child: _filteredAndSortedTodos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredAndSortedTodos.length,
              itemBuilder: (context, index) {
                return TodoItem(
                  todo: _filteredAndSortedTodos[index],
                  onToggle: _toggleTodo,
                  onDelete: _deleteTodo,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _addTodo),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildFilterChip(TodoFilter filter, String label) {
    return FilterChip(
      label: Text(label),
      selected: _currentFilter == filter,
      onSelected: (selected) {
        setState(() {
          _currentFilter = filter;
        });
      },
      showCheckmark: false,
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: _currentFilter == filter
            ? Theme.of(context).colorScheme.primary
            : Colors.black87,
        fontWeight: _currentFilter == filter ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}