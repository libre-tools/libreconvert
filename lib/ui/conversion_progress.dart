import 'package:flutter/material.dart';
import 'package:libreconvert/models/conversion_task.dart';

class ConversionProgress extends StatelessWidget {
  final List<ConversionTask> tasks;

  const ConversionProgress({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Constrain height to prevent overflow
      child: Column(
        children: [
          const Text(
            'Conversion Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(55, 65, 81, 1),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.filePath.split('/').last),
                  subtitle: Text('Status: ${task.status}'),
                  trailing: task.status == 'Completed'
                      ? const Icon(Icons.check, color: Colors.green)
                      : task.status == 'Failed'
                      ? const Icon(Icons.error, color: Colors.red)
                      : const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
