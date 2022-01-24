import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_trial_dapp/helper/todo_controller.dart';
import 'package:todo_trial_dapp/home_screen.dart';

void main(){
  runApp(TodoDapp());
}

class TodoDapp extends StatelessWidget {
  const TodoDapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoController(),
      child: const MaterialApp(
        title: 'Todo Daap',
        debugShowCheckedModeBanner: false,
        home: HomeScreen()
      ),
    );
  }
}
