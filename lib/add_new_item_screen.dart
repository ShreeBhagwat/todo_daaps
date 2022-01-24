import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_trial_dapp/helper/constant.dart';
import 'dart:math' as math;

import 'package:todo_trial_dapp/helper/todo_controller.dart';
import 'package:todo_trial_dapp/modles/todo.dart';

class AddNewItemScreen extends StatefulWidget {
  AddNewItemScreen({Key? key}) : super(key: key);

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  TextEditingController todoTextController = TextEditingController();
  TodoController todoController = TodoController();

  List<String> categories = ['Fun', 'Home', 'Office', 'Shopping', 'team'];
  String selectedCategory = 'Fun';
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    todoController = Provider.of<TodoController>(context);

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () {
                      addTodo();
                    },
                  )
                ],
              ),
              Container(
                width: width - 20,
                child: TextField(
                  maxLines: 3,
                  cursorColor: Colors.black,
                  controller: todoTextController,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'TODO',
                    hintStyle: TextStyle(
                        fontSize: 30,
                        color: kBackgroundColour,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                'Categories',
                style: TextStyle(
                    color: kBackgroundColour,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: width,
                height: 70,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 100,
                              height: 50,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categories[index],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  selectedCategoryIndex == index
                                      ? Container(
                                          width: 40,
                                          height: 2,
                                          color: Colors.black,
                                        )
                                      : Container()
                                ],
                              ))),
                        ),
                        onTap: () {
                          selectedCategory = categories[index];
                          selectedCategoryIndex = index;
                          setState(() {});
                        },
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  DateFormat("MMMM  dd | hh:mm aa").format(DateTime.now()),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTodo() async {
    print('Adding Todo');
    if (todoTextController.text != "") {
      Todo todo = Todo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        category: selectedCategory,
        title: todoTextController.text,
        created: DateTime.now(),
      );

      await todoController.addTodo(todo);
      todoTextController.text = '';
      setState(() {});
    } else {}
  }
}
