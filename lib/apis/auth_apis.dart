
import 'dart:convert';
import 'package:http/http.dart' as http;


class AuthApis{



  // sign up
  static Future<Map<String, dynamic>> signUp(String username, String emailId, String password) async {

    const String url = 'https://chatbot-task-mfcu.onrender.com/api/signup';

    final Map<String, String> payload = {
      'username': username,
      'email_id': emailId,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed with status code: ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // log in
  static Future<Map<String, dynamic>> signIn(String emailId, String password) async {

    const String url = 'https://chatbot-task-mfcu.onrender.com/api/login';

    final Map<String, String> payload = {
      'email_id': emailId,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed with status code: ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }


}