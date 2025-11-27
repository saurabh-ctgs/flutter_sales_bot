import '../entities/message_entity.dart';
import '../../data/models/service_model.dart';

abstract class ChatRepository {
  Future<MessageEntity> sendMessage(String message, List<dynamic> services, {List<Map<String, dynamic>>? conversationHistory});
  Future<List<ProductItemModel>> loadMoreServices(String query, {int limit = 5, int offset = 1});
}
