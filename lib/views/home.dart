import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_poc/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_poc/provider/todo_provider.dart';
import 'package:uuid/uuid.dart';

//*RIVERPOD EXAMPLE*

class Home extends ConsumerStatefulWidget {
  Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _title = TextEditingController();
 
  @override
  void dispose() {
    _title.clear();
    super.dispose();
  }

   String id = Uuid().v4(); // Generate a random UUID 
  
  void _generateNewUuid() { 
    setState(() { 
      id = Uuid().v4(); // Generate a new random UUID 
    }); 
  } 
  displayDialog({bool isEdit = false, Todo? todoo}) {
    
   _generateNewUuid();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a todo'),
          content: TextField(
            controller: _title,
            decoration: const InputDecoration(hintText: 'Type your todo'),
            autofocus: true,
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (isEdit == true) {
                  ref.read(TodoPro.notifier).editTask(Todo(
                      id: todoo!.id, title: _title.text, date: todoo.date));
                  Navigator.of(context).pop();
                  _title.clear();
                } else {
                  ref.read(TodoPro).addItem(
                      Todo(id: id, title: _title.text, date: DateTime.now()));
                  //ref.read(TodoPro).savedata();
                  Navigator.of(context).pop();
                  _title.clear();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void editTodo(Todo todo) {
  //  print(todo.id);
    _title.text = todo.title;
    displayDialog(isEdit: true, todoo: todo);
  }

  @override
  Widget build(BuildContext context) {
    final riverpodPro = ref.watch(TodoPro);

    return Scaffold(
      appBar: AppBar(
        title: Text("TODO APP USING RIVERPOD"),
      ),
      body: ListView.builder(
        itemCount: riverpodPro.todoItem.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              editTodo(riverpodPro.todoItem[index]);
            },
            leading: Checkbox(
              value: riverpodPro.todoItem[index].completed,
              onChanged: ((_) =>
                  ref.read(TodoPro).toggleTask(riverpodPro.todoItem[index])),
            ),
            title: riverpodPro.todoItem[index].completed
                ? Text(
                    riverpodPro.todoItem[index].title,
                    style: TextStyle(decoration: TextDecoration.lineThrough),
                  )
                : Text(riverpodPro.todoItem[index].title),
            subtitle: Text(
                DateFormat.yMEd().format(riverpodPro.todoItem[index].date)),
            trailing: IconButton(
                onPressed: () {
                  ref
                      .read(TodoPro.notifier)
                      .deleteItem(riverpodPro.todoItem[index]);
                },
                icon: const Icon(Icons.delete)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            displayDialog();
          },
          child: Icon(Icons.add)),
    );
  }
}
