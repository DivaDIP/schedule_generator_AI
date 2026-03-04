import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_generator_ai/models/task.dart';

class GeminiService {
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent";
  final String apiKey;
  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "" {
    if (apiKey.isEmpty) {
      throw ArgumentError("API key is missing");
    }
  }
  Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks);
    final prompt = _buildPrompt(tasks);
    try {
      final response = await http.post(Uri.parse("$_baseUrl?key=$apiKey"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "contents": [
              {
                "role": "user",
                "parts": [
                  {"text": prompt}
                ]
              }
            ]
          }));
      return _handleResponse(response);
    } catch (e) {
      throw ArgumentError("Failed to generate schedule: $e");
    }
  }

  String _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode == 401) {
      throw ArgumentError("Invalid API key or Unauthorized Access");
    } else if (response.statusCode == 429) {
      throw ArgumentError("Rate limit exceeded");
    } else if (response.statusCode == 500) {
      throw ArgumentError("Internal server error");
    } else if (response.statusCode == 503) {
      throw ArgumentError("Service unavailable");
    } else if (response.statusCode == 200) {
      final raw = data["candidates"][0]["content"]["parts"][0]["text"];
      return _sanitizeScheduleOutput(raw.toString());
    } else {
      throw ArgumentError("Unknown error");
    }
  }

  String _buildPrompt(List<Task> tasks) {
    final tasksList = tasks
        .map((task) =>
            "${task.name} (Priority: ${task.priority}, Duration: ${task.duration} minute, Deadline: ${task.deadline})")
        .join("\n");
    return '''
Buat jadwal harian optimal berdasarkan task berikut:
$tasksList

Output HARUS singkat, jelas, dan TANPA markdown.
Aturan output:
1) Maksimal 8 baris.
2) Jangan gunakan **, *, |, #, tabel, atau backtick.
3) Format wajib:
Ringkasan: <1 kalimat>
Jadwal:
HH:mm-HH:mm | <nama task>
HH:mm-HH:mm | <nama task>
Alasan: <1 kalimat pendek>

Gunakan Bahasa Indonesia.
''';
  }

  String _sanitizeScheduleOutput(String text) {
    final noMarkdown = text
        .replaceAll('**', '')
        .replaceAll('`', '')
        .replaceAll('#', '')
        .replaceAll('|', ' | ');

    final lines = noMarkdown
        .split('\n')
        .map((line) => line.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((line) => line.isNotEmpty)
        .where((line) => line != ':' && line != '-' && line != '|')
        .toList();

    return lines.join('\n');
  }

  void _validateTasks(List<Task> tasks) {
    if (tasks.isEmpty) throw ArgumentError("Tasks cannot be empty");
  }
}