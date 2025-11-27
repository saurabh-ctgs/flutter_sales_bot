import 'dart:convert';
import 'dart:developer' as developer;
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/gemini_datasource.dart';
import '../datasources/service_datasource.dart';
import '../models/bot_response_model.dart';
import '../models/service_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GeminiDataSource geminiDataSource;
  final ServiceDataSource serviceDataSource;

  ChatRepositoryImpl({
    required this.geminiDataSource,
    required this.serviceDataSource,
  });

  @override
  Future<MessageEntity> sendMessage(String message,
      List<dynamic> services, {List<Map<String, dynamic>>? conversationHistory}) async {
    try {
      developer.log('➡️ sendMessage called', name: 'ChatRepository');

      // 1️⃣ Send user message to Gemini with conversation history
      developer.log('Sending to Gemini: $message', name: 'ChatRepository');
      final res = await geminiDataSource.sendMessage(message, conversationHistory: conversationHistory);
      developer.log('From Gemini: $res', name: 'ChatRepository');

      final responseJson = jsonDecode(res);

      // ✅ CHECK IF API RETURNED AN ERROR
      if (!responseJson['success'] ?? false) {
        final errorMessage = responseJson['message'] ?? 'Unknown error occurred';
        throw Exception(errorMessage);
      }

      final geminiResponse = BotResponseModel.fromJson(responseJson);

      // Extract message and function call from response
      final responseData = geminiResponse.data;
      final botData = responseData;

      String messageContent = '';
      FunctionCall? functionCall;
      Extra? extra;
      Map<String, dynamic>? rawContent;

      // Handle case where there's a text response
      if (botData?.content != null) {
        messageContent = botData!.content!.text;
        // Store raw content for conversation history
        rawContent = {
          'parts': botData.content!.parts.map((p) => {'text': p.text}).toList(),
          'role': botData.content!.role,
        };
      }

      // Handle function call
      if (botData?.extra?.functionCall != null) {
        functionCall = botData!.extra!.functionCall;
        developer.log('Function call detected: ${functionCall!.name} with args: ${functionCall.args}',
            name: 'ChatRepository');
      }

      // Extract extra data
      extra = botData?.extra;

      return MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: messageContent,
        type: MessageType.bot,
        timestamp: DateTime.now(),
        categoryData: extra,
        functionCall: functionCall,
        rawContent: rawContent,
      );
    } catch (e, st) {
      developer.log('❌ sendMessage failed: $e', name: 'ChatRepository',
          error: e,
          stackTrace: st);
      rethrow; // ✅ RETHROW TO LET CONTROLLER HANDLE
    }
  }

  /// Load more services with pagination
  Future<List<ProductItemModel>> loadMoreServices(String query,
      {int limit = 5, int offset = 1}) async {
    try {
      developer.log(
          'Loading more services for: $query, limit: $limit, offset: $offset',
          name: 'ChatRepository');
      final results = await serviceDataSource.searchServices(
          query, limit: limit, offset: offset);
      developer.log(
          'Loaded ${results.length} more services', name: 'ChatRepository');
      return results;
    } catch (e, st) {
      developer.log('Error loading more services: $e', name: 'ChatRepository',
          error: e,
          stackTrace: st);
      throw Exception('Failed to load more services: $e');
    }
  }

/// 🔍 Extract category data from JSON block if available


/// 🔍 Robust extractor: supports exact markers, markers with surrounding whitespace,
/// and fallback to any JSON containing product_or_service.
}
