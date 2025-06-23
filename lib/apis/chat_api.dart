import 'package:gomiq/models/chat.dart';
import 'package:gomiq/models/chat_content.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ChatApi{


  // fetch chats
  static Future<List<Chat>> fetchChatsWithContent(String userId) async {

    final List<Chat> chats = [];

    try {
      // Step 1: Fetch chats
      final chatsUrl = Uri.parse('https://chatbot-task-mfcu.onrender.com/api/get_chats?user_id=$userId');
      final chatResponse = await http.get(chatsUrl);

      if (chatResponse.statusCode == 200) {
        final jsonData = jsonDecode(chatResponse.body);
        final chatListRaw = jsonDecode(jsonData['chats']);

        for (var chatJson in chatListRaw) {
          // Step 2: Convert to Chat object
          final chat = Chat.fromJson(chatJson);

          // print(chat.chatId) ;
          // print(chat.title) ;
          // print(chat.createdAt) ;

          // Step 3: Fetch chat content
          final contentUrl = Uri.parse(
            'https://chatbot-task-mfcu.onrender.com/api/get_conversation?chat_id=${chat.chatId}&user_id=$userId',
          );

          final contentResponse = await http.get(contentUrl);

          if (contentResponse.statusCode == 200) {

            final body = contentResponse.body;

            try {
              final decoded = jsonDecode(body);

              List<ChatContent> contentList = [];

              if (decoded is List) {
                contentList =
                    decoded.map<ChatContent>((e) => ChatContent.fromJson(e)).toList();
              }

              chats.add(Chat(
                title: chat.title,
                chatId: chat.chatId,
                createdAt: chat.createdAt,
                chatContent: contentList,
              ));

            } catch (e) {
              print('❌ Failed to decode chat content for ${chat.chatId}: $e');
            }
          } else {
            print("Failed to fetch content for chat: ${chat.chatId}");
          }
        }
      } else {
        print("Failed to fetch chats: ${chatResponse.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }

    return chats;
  }


  // create new chat
  static Future<bool> createChat({required String userId, required String title,}) async {
    try {
      final url = Uri.parse(
        'https://chatbot-task-mfcu.onrender.com/api/create_chat?user_id=$userId&title=$title',
      );

      final response = await http.post(url);

      if (response.statusCode == 200) {
        print('✅ Chat created successfully');
        return true;
      } else {
        print('❌ Failed to create chat: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ Error creating chat: $e');
    }

    return false;
  }


  // message
  static Future<bool> sendPrompt({required String prompt, required String userId, required String chatId,}) async {
    final url = Uri.parse('https://chatbot-task-mfcu.onrender.com/api/chat');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'user_id': userId,
          'chat_id': chatId,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Prompt sent successfully!");
        return true;
      } else {
        print("❌ Failed to send prompt: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ Error sending prompt: $e");
    }

    return false;
  }



}