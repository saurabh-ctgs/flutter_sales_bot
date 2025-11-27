import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final SendMessageUseCase sendMessageUseCase;
  final ChatRepository chatRepository;

  ChatController({
    required this.sendMessageUseCase,
    required this.chatRepository,
  });

  final messages = <MessageEntity>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingCategory = false.obs; // For category item selection
  final services = <dynamic>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Pagination tracking
  final Map<String, int> _paginationState = {}; // messageId -> currentOffset

  @override
  void onInit() {
    super.onInit();
    _initChat();
  }

  Future<void> _initChat() async {
    isLoading.value = true;
    try {
      // Add welcome message
      messages.add(MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content:
        'Hello! 👋 I\'m your personal service assistant. How can I help you today?',
        type: MessageType.bot,
        timestamp: DateTime.now(),
      ));
    } catch (e,st) {
      developer.log('Error$e', stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    final userMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
      rawContent: {
        'parts': [{'text': text}],
        'role': 'user',
      },
    );
    messages.add(userMessage);

    messageController.clear();
    _scrollToBottom();

    // Add typing indicator
    messages.add(MessageEntity(
      id: 'typing',
      content: '',
      type: MessageType.bot,
      timestamp: DateTime.now(),
      isTyping: true,
    ));

    try {
      // Build conversation history from previous messages
      final conversationHistory = _buildConversationHistory();

      final response = await sendMessageUseCase(text, services, conversationHistory: conversationHistory);

      // Remove typing indicator
      messages.removeWhere((m) => m.id == 'typing');

      // Initialize pagination tracking for this message
      if (response.searchQuery != null) {
        _paginationState[response.id] = 1; // Start at offset 1
      }

      // Handle function call if present
      if (response.functionCall != null) {
        messages.add(MessageEntity(
          id: 'typing',
          content: '',
          type: MessageType.bot,
          timestamp: DateTime.now(),
          isTyping: true,
        ));
        developer.log('Function call detected: ${response.functionCall!.name}', name: 'ChatController');
        await _handleFunctionCall(response);
        messages.removeWhere((m) => m.id == 'typing');
      } else {
        // Add bot response only if no function call
        messages.add(response);
      }

      _scrollToBottom();
    } catch (e) {
      messages.removeWhere((m) => m.id == 'typing');
      developer.log('❌ Error sending message: $e', name: 'ChatController');

      // ✅ EXTRACT ERROR MESSAGE
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }

      // ✅ DISPLAY ERROR AS BOT MESSAGE IN CHAT
      messages.add(MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '❌ Error: $errorMessage',
        type: MessageType.bot,
        timestamp: DateTime.now(),
      ));

      _scrollToBottom();
    }
  }

  /// Build conversation history from previous messages for API request
  List<Map<String, dynamic>> _buildConversationHistory() {
    final history = <Map<String, dynamic>>[];

    for (var message in messages) {
      // Skip typing indicators and welcome message
      if (message.isTyping || message.id == 'typing') continue;

      if (message.type == MessageType.user) {
        history.add({
          'parts': [{'text': message.content}],
          'role': 'user',
        });
      } else if (message.type == MessageType.bot && message.rawContent != null) {
        // Use rawContent if available for accurate history
        history.add(message.rawContent!);
      } else if (message.type == MessageType.bot && message.content.isNotEmpty) {
        // Fallback: construct from content
        history.add({
          'parts': [{'text': message.content}],
          'role': 'model',
        });
      }
    }

    developer.log('Built conversation history with ${history.length} messages', name: 'ChatController');
    return history;
  }

  /// Handle function call from API response
  Future<void> _handleFunctionCall(MessageEntity responseData) async {
    try {
      developer.log('Handling function call: ${responseData.functionCall!.name}', name: 'ChatController');

      if (responseData.functionCall!.name == 'search') {
        // Extract search parameters
        final args = responseData.functionCall!.args;
        final query = args['query']?.toString() ?? '';
        final age = args['age']?.toString() ?? '';
        final gender = args['gender']?.toString() ?? '';

        developer.log('Search params - query: $query, age: $age, gender: $gender', name: 'ChatController');

        // Perform the search
        if (query.isNotEmpty) {
          final searchResults = await chatRepository.loadMoreServices(
            query,
            limit: 5,
            offset: 1,
          );

          // Add bot response with search results
          final response = MessageEntity(
            id: responseData.id,
            content: searchResults.isNotEmpty ?responseData.content.isNotEmpty?responseData.content:'Ok, I found some result for you':'We are sorry, We could not find any results for your search.',
            type: MessageType.bot,
            timestamp: DateTime.now(),
            services: searchResults,
            searchQuery: query,
          );

          messages.add(response);
          _paginationState[responseData.id] = 1;

          developer.log('Added ${searchResults.length} search results', name: 'ChatController');
        }
      }

      // _scrollToBottom();
    } catch (e) {
      developer.log('❌ Error handling function call: $e', name: 'ChatController');

      // ✅ DISPLAY FUNCTION ERROR IN CHAT
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }

      messages.add(MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '❌ Error executing search: $errorMessage',
        type: MessageType.bot,
        timestamp: DateTime.now(),
      ));

      _scrollToBottom();
    }
  }



  /// Load more services for a specific message
  Future<void> loadMoreServices(String messageId) async {
    if (isLoadingMore.value) return;

    // Find the message
    final messageIndex = messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = messages[messageIndex];
    if (message.searchQuery == null || message.searchQuery!.isEmpty) return;

    isLoadingMore.value = true;
    try {
      final currentOffset = _paginationState[messageId] ?? 1;
      final nextOffset = currentOffset + 5; // Next page (increment by 5)

      developer.log('Loading more services: messageId=$messageId, offset=$nextOffset', name: 'ChatController');

      final moreServices = await chatRepository.loadMoreServices(
        message.searchQuery!,
        limit: 5,
        offset: nextOffset,
      );

      if (moreServices.isNotEmpty) {
        // Update pagination state
        _paginationState[messageId] = nextOffset;

        // Add new services to the message
        final updatedServices = [
          ...(message.services ?? []),
          ...moreServices,
        ];

        // Update the message with new services
        messages[messageIndex] = MessageEntity(
          id: message.id,
          content: message.content,
          type: message.type,
          timestamp: message.timestamp,
          services: updatedServices,
          searchQuery: message.searchQuery,
          categoryData: message.categoryData,
        );

        // Trigger UI update
        messages.refresh();

        developer.log('Added ${moreServices.length} more services. Total: ${updatedServices.length}', name: 'ChatController');
      } else {
        developer.log( 'No More Services, No additional services available.', name: 'ChatController');

      }
    } catch (e) {
      developer.log('❌ Error loading more services: $e', name: 'ChatController');

      // ✅ DISPLAY PAGINATION ERROR IN CHAT
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }

      messages.add(MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '❌ Could not load more services: $errorMessage',
        type: MessageType.bot,
        timestamp: DateTime.now(),
      ));

      _scrollToBottom();
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}