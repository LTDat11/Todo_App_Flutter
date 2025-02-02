import 'package:flutter/material.dart';

import 'widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
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

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  void addNewTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Add a new todo items',
                      filled: true,
                      fillColor: const Color(0xffF1F3F5)),
                ),
              ),
            ),
            FloatingActionButton(
              tooltip: "Add",
              elevation: 0,
              backgroundColor: Colors.black,
              onPressed: addNewTask,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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
                  deleteFunction: (context) => deleteTask(index),
                  onChanged: (value) => checkBoxChanged(index),
                  taskCompleted: toDoList[index][1],
                  taskName: toDoList[index][0],
                );
              },
            ),
    );
  }
}
