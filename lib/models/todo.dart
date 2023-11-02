

class Todo {
  int id;
  String title;
  DateTime date;
  bool completed;
  Todo({required this.id, required this.title, required this.date,this.completed=false});

  void toggleCompleted(){
    completed=!completed;
  }

  // factory Todo.fromJson(Map<String, dynamic> json) {
  //   return Todo(title: json['title'],id: json['id'],date: json['date'],completed: json['completed']);
  // }

  // Map<String,dynamic> toJson() {
  //   return {
  //     'id':id,
  //     'title': title,
  //     'date':date,
  //     'completed' : completed 
  //   };
  // }
}
