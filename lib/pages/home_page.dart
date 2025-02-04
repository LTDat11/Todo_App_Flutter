import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/pages/detail_page.dart';
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
  bool isLoading = true;

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

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      if (encodedData != null) {
        toDoList = List.from(jsonDecode(encodedData));
      }
      isLoading = false;
    });
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
      Navigator.pop(context);
    });
    _saveToDoList();
  }

  void _closeSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void addNewTask() {
    var snackBar = SnackBar(
      content: const Text('Fill task please!'),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'Close',
        backgroundColor: Colors.white,
        textColor: Colors.black,
        disabledTextColor: Colors.white,
        onPressed: _closeSnackBar,
      ),
    );
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    _saveToDoList();
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancle"),
            ),
            ElevatedButton(
              onPressed: () => deleteTask(index),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : toDoList.isEmpty
              ? const Center(
                  child: Text('Empty'),
                )
              : ListView.builder(
                  itemCount: toDoList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailPage(
                        //       taskCompleted: toDoList[index][1],
                        //       taskName: toDoList[index][0],
                        //     ),
                        //   ),
                        // );

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DetailPage(
                              taskCompleted: toDoList[index][1],
                              taskName: toDoList[index][0],
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );

                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, secondaryAnimation) =>
                        //             DetailPage(
                        //       taskCompleted: toDoList[index][1],
                        //       taskName: toDoList[index][0],
                        //     ),
                        //     transitionsBuilder: (context, animation,
                        //         secondaryAnimation, child) {
                        //       return ScaleTransition(
                        //         scale: animation,
                        //         child: child,
                        //       );
                        //     },
                        //   ),
                        // );

                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, secondaryAnimation) =>
                        //             DetailPage(
                        //       taskCompleted: toDoList[index][1],
                        //       taskName: toDoList[index][0],
                        //     ),
                        //     transitionsBuilder: (context, animation,
                        //         secondaryAnimation, child) {
                        //       const begin = Offset(0.0, -1.0);
                        //       const end = Offset.zero;
                        //       const curve = Curves.easeInOut;

                        //       var tween = Tween(begin: begin, end: end)
                        //           .chain(CurveTween(curve: curve));

                        //       return SlideTransition(
                        //         position: animation.drive(tween),
                        //         child: child,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      child: TodoList(
                        deleteFunction: (context) =>
                            _showDialog(context, index),
                        onChanged: (value) => checkBoxChanged(index),
                        taskCompleted: toDoList[index][1],
                        taskName: toDoList[index][0],
                      ),
                    );
                  },
                ),
    );
  }
}
