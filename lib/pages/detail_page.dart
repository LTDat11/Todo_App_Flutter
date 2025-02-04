import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key, required this.taskName, required this.taskCompleted});

  final String taskName;
  final bool taskCompleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$taskName'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Status Of Task',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              taskCompleted ? 'Completed' : 'Not Completed',
              style: TextStyle(
                fontSize: 18,
                color: taskCompleted ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
