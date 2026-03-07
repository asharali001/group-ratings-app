import 'package:uuid/uuid.dart';

enum ChatRole { user, assistant }

class AIReference {
  final String type; // 'group' or 'ratingItem'
  final String id;
  final String name;
  final String? groupId;

  const AIReference({
    required this.type,
    required this.id,
    required this.name,
    this.groupId,
  });

  factory AIReference.fromMap(Map<String, dynamic> map) {
    return AIReference(
      type: map['type'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String?,
    );
  }
}

class ChatMessage {
  final String id;
  final ChatRole role;
  final String text;
  final List<AIReference> references;
  final DateTime timestamp;

  ChatMessage({
    String? id,
    required this.role,
    required this.text,
    this.references = const [],
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();
}
