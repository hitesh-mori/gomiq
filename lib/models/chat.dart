import 'chat_content.dart';

class Chat {
  final String title;
  final String chatId;
  final DateTime createdAt;
  final List<ChatContent> chatContent;

  Chat({
    required this.title,
    required this.createdAt,
    required this.chatId,
    required this.chatContent,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      title: json['title'],
      chatId: json['chat_id'],
      createdAt: DateTime.parse(json['time_created']['\$date']),
      chatContent: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'chatId': chatId,
      'createdAt': createdAt.toIso8601String(),
      'chatContent': chatContent.map((e) => e.toJson()).toList(),
    };
  }
}
