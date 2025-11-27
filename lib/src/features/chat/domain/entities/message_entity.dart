import 'package:xl_bot/src/features/chat/data/models/bot_response_model.dart';

import '../../data/models/service_model.dart';

enum MessageType { user, bot, service }

class MessageEntity {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<dynamic>? services;
  final bool isTyping;
  final String? searchQuery; // Store the search query for pagination
  final Extra? categoryData; // Store extracted category and items
  final dynamic selectedService; // Store selected service when action is clicked
  final FunctionCall? functionCall; // Store function call from API
  final Map<String, dynamic>? rawContent; // Store raw content for conversation history

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.services,
    this.isTyping = false,
    this.searchQuery,
    this.categoryData,
    this.selectedService,
    this.functionCall,
    this.rawContent,
  });
}