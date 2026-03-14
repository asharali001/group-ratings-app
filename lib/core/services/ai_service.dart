import 'package:cloud_functions/cloud_functions.dart';

import '../models/chat_message.dart';
import '../services/auth_service.dart';

class AiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<({String answer, List<AIReference> references})> queryAI(
    String question,
  ) async {
    final callable = _functions.httpsCallable('queryAI');
    final payload = <String, dynamic>{'question': question};
    final authService = AuthService.to;
    if (authService.isMirroring && authService.mirroredUserId != null) {
      payload['mirrorUserId'] = authService.mirroredUserId;
    }
    final result = await callable.call(payload);
    final data = result.data as Map<String, dynamic>;
    final answer = data['answer'] as String;
    final rawRefs = data['references'] as List<dynamic>? ?? [];
    final references = rawRefs
        .map((r) => AIReference.fromMap(Map<String, dynamic>.from(r as Map)))
        .toList();

    return (answer: answer, references: references);
  }
}
