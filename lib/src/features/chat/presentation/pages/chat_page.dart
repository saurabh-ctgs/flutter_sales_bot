// lib/features/chat/presentation/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:xl_bot/src/features/chat/data/datasources/service_datasource.dart';
import 'package:xl_bot/src/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../xl_bot.dart';
import '../../data/datasources/gemini_datasource.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/service_card.dart';
import '../widgets/chat_input.dart';
import '../widgets/typing_indicator.dart';
import '../theme/chat_ui_config_manager.dart';

class ChatPage extends StatefulWidget {
  final ChatUIConfig? uiConfig;
  final List<ActionButton>? actionButtons;

  const ChatPage({super.key, this.uiConfig, this.actionButtons});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatController? controller;
  late ChatUIConfig uiConfig;

  @override
  void initState() {
    super.initState();

    // Initialize UI Config
    if (widget.uiConfig != null) {
      uiConfig = widget.uiConfig!;
      ChatUIConfigManager.instance.initialize(widget.uiConfig!);
    } else {
      // Auto-detect brightness if no config provided
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      uiConfig = brightness == Brightness.dark
          ? ChatUIConfig.dark()
          : ChatUIConfig.light();
      ChatUIConfigManager.instance.initialize(uiConfig);
    }

    // Get config from the global manager
    final config = SalesBotConfigManager.instance.config;

    controller = Get.put(
      ChatController(
        sendMessageUseCase: Get.put(
          SendMessageUseCase(
            ChatRepositoryImpl(
              geminiDataSource: GeminiDataSourceImpl(),
              serviceDataSource: ServiceDataSourceImpl(config: config),
            ),
          ),
        ),
        chatRepository: ChatRepositoryImpl(
          geminiDataSource: GeminiDataSourceImpl(),
          serviceDataSource: ServiceDataSourceImpl(config: config),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = uiConfig;

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: config.useGradientForBackground
              ? config.backgroundGradient
              : null,
          color: config.useGradientForBackground ? null : config.backgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar: allow custom builder
              if (config.appBarBuilder != null)
                config.appBarBuilder!(context, config)
              else
                _buildAppBar(context),

              Expanded(
                child: Obx(() {
                  if (controller!.isLoading.value && controller!.messages.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: config.primaryColor,
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller!.scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller!.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller!.messages[index];

                      if (message.isTyping) {
                        return TypingIndicator(uiConfig: uiConfig)
                            .animate()
                            .fadeIn(duration: config.fadeInDuration);
                      }

                      return Column(
                        children: [
                          MessageBubble(
                            message: message,
                            uiConfig: uiConfig,
                            chatController: controller!,
                          )
                              .animate()
                              .fadeIn(duration: config.fadeInDuration)
                              .slideY(begin: 0.2, end: 0),

                          if (message.services != null && message.services!.isNotEmpty) ...[
                            SizedBox(
                              height: 450,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: message.services!.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, serviceIndex) {
                                  final service = message.services![serviceIndex];

                                  final widgetCard = config.serviceCardBuilder != null
                                      ? config.serviceCardBuilder!(
                                    context,
                                    service,
                                    config,
                                    widget.actionButtons,
                                  )
                                      : ServiceCard(
                                    service: service,
                                    uiConfig: uiConfig,
                                    actionButtons: widget.actionButtons,
                                  );

                                  return SizedBox(
                                    width: 280, // card width in the carousel, tweak as needed

                                    child: widgetCard
                                        .animate()
                                        .fadeIn(duration: config.slideInDuration, delay: 200.ms)
                                        .slideX(begin: 0.2, end: 0),
                                  );
                                },
                              ),
                            ),

                            // Load More button under the carousel
                            _buildLoadMoreButton(context, message),
                          ],


                        ],
                      );
                    },
                  );
                }),
              ),

              // Chat input: allow custom builder
              if (config.inputBuilder != null)
                config.inputBuilder!(context, controller!, config)
              else
                ChatInput(
                  controller: controller!,
                  // uiConfig: uiConfig,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Load More Services Button
  Widget _buildLoadMoreButton(BuildContext context, dynamic message) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller!.isLoadingMore.value
                ? null
                : () => controller!.loadMoreServices(message.id),
            icon: controller!.isLoadingMore.value
                ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  uiConfig.userTextColor,
                ),
              ),
            )
                : const Icon(Icons.expand_more),
            label: Text(
              controller!.isLoadingMore.value
                  ? 'Loading...'
                  : 'Load More Services',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: uiConfig.secondaryColor,
              foregroundColor: uiConfig.userTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  uiConfig.serviceCardBorderRadius,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: uiConfig.appBarBackgroundColor,
        boxShadow: uiConfig.appBarShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: uiConfig.useGradientForAppBar
                  ? uiConfig.appBarIconGradient
                  : null,
              color: uiConfig.useGradientForAppBar
                  ? null
                  : uiConfig.appBarIconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: uiConfig.botIcon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Service Assistant',
                  style: uiConfig.appBarTitleStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: uiConfig.appBarTextColor,
                      ),
                ),
                Text(
                  'Online • Ready to help',
                  style: uiConfig.appBarSubtitleStyle ??
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: uiConfig.statusTextColor,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              uiConfig.menuIcon,
              color: uiConfig.appBarIconColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0);
  }
}