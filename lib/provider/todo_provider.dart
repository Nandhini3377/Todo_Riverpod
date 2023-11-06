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
  
  UnmodifiableListView<Todo> get todoItem => UnmodifiableListView(_todoItems);
  
  //load todo
  Future<void> loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('todoList');

   try {
      if (jsonList != null) {
        _todoItems =
            jsonList.map((json) => Todo.fromJson(jsonDecode(json))).toList();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    print("loaded");
    print(todoItem.length);
  

  }


// Add a ToDo item
  Future<void> addTodo(Todo todoo) async {
    var todo = Todo(id:todoo.id , title: todoo.title, date: todoo.date,completed: todoo.completed);
    _todoItems = List.from(_todoItems)..add(todo);
    await saveTodoList(_todoItems);
    notifyListeners();
  }

  //Save todo
  Future<void> saveTodoList(List<Todo> todoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // print(todoList.length);
    List<String> jsonList =
        todoList.map((todo) => jsonEncode(todo)).toList();
        
    await prefs.setStringList('todoList', jsonList);
  }
  
  //Edit todo
  Future<void> editTask(Todo updateTodo) async {
    //int upid=_todoItems.indexOf(updateTodo);
    print(updateTodo.title);
    int index = _todoItems.indexWhere((todo) => todo.id == updateTodo.id);
    if (index != -1) {
      _todoItems[index] = Todo(
          id: updateTodo.id, title: updateTodo.title, date: updateTodo.date);
      print(_todoItems[index].title);
      await saveTodoList(_todoItems);
    }
    notifyListeners();
  }

  Future<void> toggleTask(Todo task) async{
    final taskIndex = _todoItems.indexOf(task);
    _todoItems[taskIndex].toggleCompleted();
    await saveTodoList(_todoItems);
    notifyListeners();
  }


Future<void> deleteItem(String index) async {
   // _todoItems.removeAt(index);
     _todoItems.removeWhere((item) => index.toString() == item.id);
    await saveTodoList(_todoItems);
    notifyListeners();
  }
}
