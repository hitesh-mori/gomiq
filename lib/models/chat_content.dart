
class ChatContent {
  final String id;
  final String chatId;
  final String query;
  final String response;
  final DateTime timestamp;
  final String context;

  ChatContent({
    required this.id,
    required this.chatId,
    required this.query,
    required this.response,
    required this.timestamp,
    required this.context,
  });

  factory ChatContent.fromJson(Map<String, dynamic> json) {
    return ChatContent(
      id: json['_id']['\$oid'],
      chatId: json['chat_id'],
      query: json['query'],
      response: json['response'],
      timestamp: DateTime.parse(json['timestamp']['\$date']),
      context: json['context'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': {'\$oid': id},
      'chat_id': chatId,
      'query': query,
      'response': response,
      'timestamp': {'\$date': timestamp.toIso8601String()},
      'context': context,
    };
  }
}
