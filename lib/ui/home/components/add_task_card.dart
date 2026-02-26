import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class AddTaskCard extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskCard({super.key, required this.onAddTask});

  @override
  State<AddTaskCard> createState() => _AddTaskCardState();
}

class _AddTaskCardState extends State<AddTaskCard> {
  final taskController = TextEditingController();
  final durationController = TextEditingController();
  final deadlineController = TextEditingController();
  String? priority;


  @override
  void dispose() {
    taskController.dispose();
    durationController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void _submit() {
    if (taskController.text.isNotEmpty && durationController.text.isNotEmpty && deadlineController.text.isNotEmpty && priority != null) {
      widget.onAddTask(Task(
        name: taskController.text,
        priority: priority!,
        duration: int.tryParse(durationController.text) ?? 5,
        deadline: deadlineController.text
      ));

      taskController.clear();
      durationController.clear();
      deadlineController.clear();
      setState(() => priority = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.playlist_add_check_circle_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  "Add Task",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            SizedBox(height: 12),
            // TASK FIELD
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.task_alt_rounded
                )
              ),
              textInputAction: TextInputAction.next, // untuk action text inputnya yang akan berpindah secara otomatis
            ),
            SizedBox(height: 12),
            // DURATION FIELD
            TextField(
              controller: durationController,
              decoration: InputDecoration(
                labelText: 'Duration (minute)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.timer_outlined
                )
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next, 
            ),
            // DEADLINE FIELD
            SizedBox(height: 12),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: 'Deadline',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.event_outlined
                )
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 12),
            // DROPDOWN FIELD
            DropdownButtonFormField<String>(
              initialValue: priority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag_outlined)
              ),
              items: const ['High', 'Medium', 'Low']
                  .map((values) => DropdownMenuItem(value: values, child: Text(values)))
                  .toList(),
                onChanged: (value) => setState(() => priority = value),
            ),
            SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(Icons.add_rounded),
              label: Text('Add Task'),
            )
          ],
        ),
      ),
    );
  }
}