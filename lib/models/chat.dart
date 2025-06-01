import 'chat_content.dart';

class Chat {
  final String title;
  final DateTime createdAt;
  final List<ChatContent> chatContent;

  Chat({
    required this.title,
    required this.createdAt,
    required this.chatContent,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      title: json['title'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      chatContent: (json['chatContent'] as List<dynamic>)
          .map((item) => ChatContent.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'chatContent': chatContent.map((e) => e.toJson()).toList(),
    };
  }
}
