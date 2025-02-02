import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List toDoList = [];

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Future<void> _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodeData = jsonEncode(toDoList);
    await prefs.setString('todo_list', encodeData);
  }

  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('todo_list');
    if (encodedData != null) {
      setState(() {
        toDoList = List.from(jsonDecode(encodedData));
      });
    }
  }

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1]; //toggle
    });
    _saveToDoList();
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    _saveToDoList();
  }

  void addNewTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    _saveToDoList();
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
