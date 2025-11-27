// // lib/features/chat/presentation/widgets/message_bubble.dart
// import 'package:flutter/material.dart';
// import 'package:xl_bot/src/features/chat/presentation/controllers/chat_controller.dart';
// import 'package:intl/intl.dart';
// import '../../domain/entities/message_entity.dart';
// import '../theme/chat_ui_config.dart';
// import '../theme/chat_ui_config_manager.dart';
//
// class MessageBubble extends StatelessWidget {
//   final MessageEntity message;
//   final ChatController chatController;
//   final ChatUIConfig? uiConfig;
//
//   const MessageBubble({
//     super.key,
//     required this.message,
//     this.uiConfig, required this.chatController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final config = uiConfig ?? ChatUIConfigManager.instance.config;
//     final isUser = message.type == MessageType.user;
//
//     // If a custom builder is provided, use it (consumer responsible for layout)
//     if (config.messageBubbleBuilder != null) {
//       return config.messageBubbleBuilder!(context, message, chatController, config);
//     }
//
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: config.messageMargin,
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * config.messageBubbleMaxWidth,
//         ),
//         child: Column(
//           crossAxisAlignment:
//           isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: config.messagePadding + 4,
//                 vertical: config.messagePadding,
//               ),
//               decoration: BoxDecoration(
//                 gradient: isUser && config.useGradientForUserMessages
//                     ? config.userMessageGradient
//                     : null,
//                 color: isUser && !config.useGradientForUserMessages
//                     ? config.userMessageColor
//                     : !isUser
//                     ? config.botMessageColor
//                     : null,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(config.messageBorderRadius),
//                   topRight: Radius.circular(config.messageBorderRadius),
//                   bottomLeft: Radius.circular(
//                     isUser ? config.messageBorderRadius : 4,
//                   ),
//                   bottomRight: Radius.circular(
//                     isUser ? 4 : config.messageBorderRadius,
//                   ),
//                 ),
//                 boxShadow: config.messageShadow,
//               ),
//               child: Text(
//                 message.content,
//                 style: config.messageTextStyle ??
//                     Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: isUser ? config.userTextColor : config.botTextColor,
//                     ),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 DateFormat('HH:mm').format(message.timestamp),
//                 style: config.timestampStyle ??
//                     Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context)
//                           .colorScheme
//                           .onSurface
//                           .withValues(alpha: 0.5),
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// lib/features/chat/presentation/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import 'package:xl_bot/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message_entity.dart';
import '../theme/chat_ui_config.dart';
import '../theme/chat_ui_config_manager.dart';

class MessageBubble extends StatefulWidget {
  final MessageEntity message;
  final ChatController chatController;
  final ChatUIConfig? uiConfig;
  final bool showAnimation;
  final bool showAvatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.chatController,
    this.uiConfig,
    this.showAnimation = true,
    this.showAvatar = true,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.message.type == MessageType.user ? 0.3 : -0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.showAnimation) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.uiConfig ?? ChatUIConfigManager.instance.config;
    final isUser = widget.message.type == MessageType.user;

    // If a custom builder is provided, use it
    if (config.messageBubbleBuilder != null) {
      return config.messageBubbleBuilder!(
        context,
        widget.message,
        widget.chatController,
        config,
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: config.messageMargin,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isUser && widget.showAvatar) ...[
                    _buildAvatar(config, isUser),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: _buildMessageContent(context, config, isUser),
                  ),
                  if (isUser && widget.showAvatar) ...[
                    const SizedBox(width: 8),
                    _buildAvatar(config, isUser),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatUIConfig config, bool isUser) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUser
            ? config.userMessageGradient
            : LinearGradient(
          colors: [
            config.botMessageColor,
            config.botMessageColor.withValues(alpha: 0.8),
          ],
        ),

      ),
      child: Center(
        child: isUser?config.userIcon:config.botIcon
      ),
    );
  }

  Widget _buildMessageContent(
      BuildContext context, ChatUIConfig config, bool isUser) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * config.messageBubbleMaxWidth,
      ),
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: config.messagePadding + 4,
              vertical: config.messagePadding,
            ),
            decoration: BoxDecoration(
              gradient: isUser && config.useGradientForUserMessages
                  ? config.userMessageGradient
                  : null,
              color: isUser && !config.useGradientForUserMessages
                  ? config.userMessageColor
                  : !isUser
                  ? config.botMessageColor
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(config.messageBorderRadius),
                topRight: Radius.circular(config.messageBorderRadius),
                bottomLeft: Radius.circular(
                  isUser ? config.messageBorderRadius : 4,
                ),
                bottomRight: Radius.circular(
                  isUser ? 4 : config.messageBorderRadius,
                ),
              ),
              boxShadow:  config.messageShadow,
            ),
            child: Column(
              crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.content,
                  style: config.messageTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isUser
                            ? config.userTextColor
                            : config.botTextColor,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(widget.message.timestamp),
                  style: config.timestampStyle ??
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}

