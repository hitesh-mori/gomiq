import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:gomiq/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {

  AppUser? user;
  bool isLoggedIN = false;
  String? currUserId ;

  void notify() {
    notifyListeners();
  }

  Future isLogged()async{

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    isLoggedIN = userId!=null ;

    if(userId!=null) currUserId = userId ;

  }

  Future initUser() async {

    isLogged() ;

    print("id : $currUserId") ;

    String url = 'https://chatbot-task-mfcu.onrender.com/api/user?user_id=$currUserId';

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


  Future<void> logout() async {
    user = null;
    isLoggedIN = false;
    currUserId  = null ;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    notifyListeners();
    log("👋 User logged out");
  }


}
