class Task {
  final String name;
  final String priority;
  final int duration;
  final String deadline;

  Task({required this.name, required this.priority, required this.duration, required this.deadline});

  @override
  // convert int to string, biar sama rata semua tipe datanya
  String toString() {
    return 'Task{name: $name, priority: $priority, duration: $duration, deadline: $deadline}';
  }
}