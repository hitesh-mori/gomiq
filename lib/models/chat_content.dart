
class ChatContent {
  final String toId;
  final String fromId;
  final String question;
  final String answer;

  ChatContent({
    required this.toId,
    required this.fromId,
    required this.question,
    required this.answer,
  });

  factory ChatContent.fromJson(Map<String, dynamic> json) {
    return ChatContent(
      toId: json['to_id'],
      fromId: json['from_id'],
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to_id': toId,
      'from_id': fromId,
      'question': question,
      'answer': answer,
    };
  }
}
