import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schedule_generator_ai/models/task.dart';

// Jembatan antar penghubung client dan server
class GeminiService {
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";
  final String apiKey;

  // untuk memastikan API Key valid.
  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "Please input your API KEY" {
    if (apiKey.isEmpty) {
      throw ArgumentError("API KEY is missing");
    }
  }
  
  Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks);
    final prompt = _buildPrompt(tasks);
    try {
      // akan muncul di debug console
      print("Prompt: \n$prompt");
      // menambahkan request timeout message untuk menghindari kalau API nya tidak merespon.
      // timeout => supaya proses tidak terlalu lama
      final response = await http
          .post(Uri.parse("$_baseUrl?key=$apiKey"), 
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
          })
          ).timeout(Duration(seconds: 20));
          return _handleResponse(response);

      // sebuah code yg letak nya setelah await itu hasil yg akan di generate setelah proses asinkronus selesai.

    } catch (e) {
      throw ArgumentError("Failed to Generate Schedule: $e");
    }
  }

  String _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode == 401) {
      throw ArgumentError("Invalid API Key or Unauthorized Access");
    } else if (response.statusCode == 429) {
      throw ArgumentError("Rate Limit Excedeed");
    } else if (response.statusCode == 500) {
      throw ArgumentError("Internal Server Error");
    } else if (response.statusCode == 503) {
      throw ArgumentError("Service Unavailable");
    } else if (response.statusCode == 200) {
      return data["candidates"][0]["content"]["parts"][0]["text"]; // respon yang akan diberikan sesuai kondisi
    } else {
      throw ArgumentError("Unknown Error"); // untuk error yang diluar kondisi yg sdh diberikan
    }
  }

  String _buildPrompt(List<Task> tasks) {
    final tasksList = tasks.map((task) => "${task.name} (Priority: ${task.priority}, Duration: ${task.duration}, Deadline: ${task.deadline})").join("\n");
    return "Buatkan jadwal harian yang optimal berdasarkan task berikut:\n$tasksList";
  }

  void _validateTasks(List<Task> tasks) {
    // untuk mengetahui kalau kodenya ke trigger karna sebuah perubahan library atau sesuatu.
    if (tasks.isEmpty) throw ArgumentError("Tasks cannot be empty. PLease insert ur prompt"); 
  }
}