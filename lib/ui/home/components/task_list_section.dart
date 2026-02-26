import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class TaskListSection extends StatefulWidget {
  final Function(Task) onAddTask;

  const TaskListSection({super.key, required this.onAddTask});

  @override
  State<TaskListSection> createState() => _TaskListSectionState();
}

class _TaskListSectionState extends State<TaskListSection> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}