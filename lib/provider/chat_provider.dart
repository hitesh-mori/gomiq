import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:gomiq/apis/chat_api.dart';
import 'package:gomiq/models/chat.dart';
import 'package:gomiq/models/user.dart';
import 'package:gomiq/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {


  List<Chat> allChats  = [] ;



  void notify() {
    notifyListeners();
  }


   Future<void> fetchChatsProvider(BuildContext context)async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    allChats.clear() ;

    allChats = await ChatApi.fetchChatsWithContent(userProvider.currUserId ?? "");

    notify() ;

  }

}
