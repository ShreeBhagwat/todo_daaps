import 'dart:convert';

import 'package:provider/provider.dart';

class Todo {
  final String id;
  final String title;
  final String category;
  final DateTime created;

  Todo(
      {required this.id,
      required this.title,
      required this.category,
      required this.created});

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        category = json['category'],
        created = json['created'];

  Map<String, dynamic> toJson() => {
        "id": this.id,
        'title': this.title,
        'category': this.category,
        "created": this.created.toIso8601String(),
      };
}

List<Todo> todo = [
  Todo(id: "1", title: "Get Milk", category: 'Home', created: DateTime.now()),
  Todo(
      id: "2",
      title: 'Drink Water',
      category: 'Health',
      created: DateTime.now()),
  Todo(
      id: "3",
      title: 'Watch Spiderman',
      category: 'Fun',
      created: DateTime.now()),
];
