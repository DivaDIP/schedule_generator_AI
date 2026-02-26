import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';
import 'package:schedule_generator_ai/services/gemini_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final List<Task> tasks = []; // untuk menamupung input task dari user
  String scheduleResult = ''; // untuk menampung task hasil generate schedule dr gemini
  final GeminiService geminiService = GeminiService();

  Future<void> _generateSchedule() async {
    setState(() => isLoading = true);
    try {
      String schedule = await geminiService.generateSchedule(tasks);
      setState(() => scheduleResult = schedule );
    } catch (e) {
      setState(() => scheduleResult = e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Generator'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHeader(),
          // letakkan component add task card disini
          // letakkan component task list disini
          _buildGenerateButton()
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plan Your Day Faster",
                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700
                 )
                ),
                Text(
                  "Add tasks and generate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              ],
            ),
          ),
          Chip(label: Text('${tasks.length} tasks'))
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return FilledButton.icon(
      onPressed: (isLoading || tasks.isEmpty) ? null : _generateSchedule,
      icon: isLoading
          ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
          : Icon(Icons.auto_awesome_rounded),
      label: Text(isLoading ? 'Generating...' : 'Generate Schedule'),
    );
  }
}

