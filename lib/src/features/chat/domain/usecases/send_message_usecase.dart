import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<MessageEntity> call(String message, List<dynamic> services, {List<Map<String, dynamic>>? conversationHistory}) {
    return repository.sendMessage(message, services, conversationHistory: conversationHistory);
  }
}
