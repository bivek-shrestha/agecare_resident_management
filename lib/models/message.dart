class ChatMessage {
  final String text;
  final String time;
  final bool isMine;

  const ChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
  });
}

class ChatThread {
  final String id;
  final String staffName;
  final String role;
  final String preview;
  final String time;
  final bool unread;
  final List<ChatMessage> initialMessages;

  const ChatThread({
    required this.id,
    required this.staffName,
    required this.role,
    required this.preview,
    required this.time,
    required this.unread,
    required this.initialMessages,
  });
}
