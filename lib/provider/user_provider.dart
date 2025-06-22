import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:gomiq/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {

  AppUser? user;

  void notify() {
    notifyListeners();
  }

  Future initUser(String uid) async {

    String url = 'https://chatbot-task-mfcu.onrender.com/api/user?user_id=$uid';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = AppUser.fromJson(data['user']);
        log("✅ User initialized: ${user!.userName}");
      } else {
        log("❌ Failed to fetch user: ${response.statusCode}");
      }
    } catch (e) {
      log("Error during init User : $e");
    }

    notifyListeners();
    log("#initUser complete");
  }
}
