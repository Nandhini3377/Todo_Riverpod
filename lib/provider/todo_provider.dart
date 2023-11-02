import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_poc/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';



//Instance of providers

final TodoPro = ChangeNotifierProvider<TodoProvider>((ref) => TodoProvider());

class TodoProvider extends ChangeNotifier {
  List<Todo> _todoItems = [];

  //List<Todo> get todoItem => _todoItems;

  UnmodifiableListView<Todo> get todoItem => UnmodifiableListView(_todoItems);
  
  void addItem(Todo todo) {
    _todoItems.add(Todo(
        id: todo.id, title: todo.title, date: todo.date, completed: false));

    notifyListeners();
  }

  void editTask(Todo updateTodo) {
    //int upid=_todoItems.indexOf(updateTodo);
    print(updateTodo.title);
    int index = _todoItems.indexWhere((todo) => todo.id == updateTodo.id);
    if (index != -1) {
      _todoItems[index] = Todo(
          id: updateTodo.id, title: updateTodo.title, date: updateTodo.date);
      print(_todoItems[index].title);
    }
    notifyListeners();
  }

  void toggleTask(Todo task) {
    final taskIndex = _todoItems.indexOf(task);
    _todoItems[taskIndex].toggleCompleted();
    notifyListeners();
  }

  void deleteItem(Todo tod) {
    _todoItems.removeWhere((item) => tod.title == item.title);
    print(_todoItems.length);
    notifyListeners();
  }
}
