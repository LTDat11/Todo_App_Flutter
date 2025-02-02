import 'package:flutter/material.dart';

import 'widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List toDoList = [
    ['Learn Flutter', true],
    ['Learn Firebase', true],
    ['Learn Backend', false],
    ['Buy Code', false]
  ];

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1]; //toggle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'TODO APP',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: toDoList.isEmpty
          ? const Center(
              child: Text('Empty'),
            )
          : ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                return TodoList(
                  onChanged: (value) => checkBoxChanged(index),
                  taskCompleted: toDoList[index][1],
                  taskName: toDoList[index][0],
                );
              },
            ),
    );
  }
}
