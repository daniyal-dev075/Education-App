import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  bool isLoading = true;
  final String userId; // Current user UID
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  StreamSubscription? _taskSubscription;

  TaskViewModel({required this.userId}) {
    _listenTasks(); // start listening to tasks for this user
  }

  // ----------------------
  // Real-time Firestore Listener
  // ----------------------
  void _listenTasks() {
    _taskSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      _tasks
        ..clear()
        ..addAll(snapshot.docs.map((doc) => Task.fromMap(doc.data())));
      isLoading = false;
      notifyListeners();
    }, onError: (_) {
      isLoading = false;
      notifyListeners();
    });
  }


  // ----------------------
  // Task CRUD Operations
  // ----------------------
  Future<void> addTask(String title) async {
    if (title.isEmpty) return;

    final newTask = Task(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(newTask.id)
        .set(newTask.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> toggleCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final isCompleted = !_tasks[taskIndex].isCompleted;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': isCompleted});
    }
  }

  Future<void> updateTaskDetails(String taskId, String newDetails) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({'details': newDetails});
  }

  // ----------------------
  // Dispose subscription
  // ----------------------
  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}
