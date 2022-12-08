import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  Todo({
    this.timeToExecute = "",
    this.todo = "",
    this.completed = false,
    required this.createdAt,
    this.nurseId = "",
    this.residentId = "",
    this.todoId = "",
  });

  String timeToExecute;
  String todo;
  bool completed;
  DateTime createdAt;
  String nurseId;
  String residentId;
  String todoId;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        timeToExecute: json["timeToExecute"],
        todo: json["todo"],
        completed: json["completed"],
        createdAt: DateTime.parse(json["createdAt"]),
        nurseId: json["nurseID"],
        residentId: json["residentId"],
        todoId: json["todoId"],
      );

  Map<String, dynamic> toJson() => {
        "timeToExecute": timeToExecute,
        "todo": todo,
        "createdAt": createdAt.toIso8601String(),
        "nurseID": nurseId,
        "completed": completed,
        "residentId": residentId,
        "todoId": todoId,
      };
}
