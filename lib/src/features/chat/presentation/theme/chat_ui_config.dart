// lib/features/chat/presentation/theme/chat_ui_config.dart
import 'package:flutter/material.dart';
import '../../data/models/service_model.dart';
import '../../domain/entities/message_entity.dart';
import '../controllers/chat_controller.dart';
import '../../../../model/action_button.dart';

// Builder typedefs
typedef MessageBubbleBuilder = Widget Function(BuildContext context, MessageEntity message, ChatController controller, ChatUIConfig config);
typedef ServiceCardBuilder = Widget Function(BuildContext context, ProductItemModel service, ChatUIConfig config, List<ActionButton>? actionButtons);
typedef ChatAppBarBuilder = Widget Function(BuildContext context, ChatUIConfig config);
typedef ChatInputBuilder = Widget Function(BuildContext context, ChatController controller, ChatUIConfig config);

/// Complete UI configuration for the chat interface
class ChatUIConfig {
  // Colors
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;

  // Message Bubble Colors
  final Color userMessageColor;
  final Color botMessageColor;
  final Color userTextColor;
  final Color botTextColor;

  // Input Field Colors
  final Color inputBackgroundColor;
  final Color inputTextColor;
  final Color inputHintColor;
  final Color sendButtonColor;

  // App Bar Colors
  final Color appBarBackgroundColor;
  final Color appBarTextColor;
  final Color appBarIconColor;
  final Color statusTextColor;

  // Service Card Colors
  final Color serviceCardBackgroundColor;
  final Color serviceCardTextColor;
  final Color servicePriceColor;

  // Typography
  final TextStyle? appBarTitleStyle;
  final TextStyle? appBarSubtitleStyle;
  final TextStyle? messageTextStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? timestampStyle;
  final TextStyle? serviceCardTitleStyle;

  // Dimensions
  final double messageBorderRadius;
  final double inputBorderRadius;
  final double serviceCardBorderRadius;
  final double messagePadding;
  final double inputPadding;

  // Shadows
  final List<BoxShadow> messageShadow;
  final List<BoxShadow> appBarShadow;
  final List<BoxShadow> inputShadow;

  // Animations
  final Duration fadeInDuration;
  final Duration slideInDuration;
  final Duration typingIndicatorDuration;

  // Gradients
  final bool useGradientForUserMessages;
  final bool useGradientForBackground;
  final bool useGradientForAppBar;
  final bool useGradientForSendButton;

  // Icons
  final IconData sendIcon;
  final IconData attachIcon;
  final IconData menuIcon;
  final Widget botIcon;
  final Widget userIcon;

  // Spacing
  final double messageBubbleMaxWidth; // as percentage (0.75 = 75%)
  final EdgeInsets messageMargin;
  final EdgeInsets inputMargin;
  final EdgeInsets serviceCardMargin;
  final void Function(ProductItemModel service)? onTapDefaultActionButton;

  // Optional builders for overriding default UI
  final MessageBubbleBuilder? messageBubbleBuilder;
  final ServiceCardBuilder? serviceCardBuilder;
  final ChatAppBarBuilder? appBarBuilder;
  final ChatInputBuilder? inputBuilder;

  const ChatUIConfig({
    // Colors
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,

    // Message Bubble Colors
    required this.userMessageColor,
    required this.botMessageColor,
    required this.userTextColor,
    required this.botTextColor,

    // Input Field Colors
    required this.inputBackgroundColor,
    required this.inputTextColor,
    required this.inputHintColor,
    required this.sendButtonColor,

    // App Bar Colors
    required this.appBarBackgroundColor,
    required this.appBarTextColor,
    required this.appBarIconColor,
    required this.statusTextColor,

    // Service Card Colors
    required this.serviceCardBackgroundColor,
    required this.serviceCardTextColor,
    required this.servicePriceColor,

    // Typography
    this.appBarTitleStyle,
    this.appBarSubtitleStyle,
    this.messageTextStyle,
    this.inputTextStyle,
    this.timestampStyle,
    this.serviceCardTitleStyle,

    // Dimensions
    this.messageBorderRadius = 16.0,
    this.inputBorderRadius = 24.0,
    this.serviceCardBorderRadius = 12.0,
    this.messagePadding = 12.0,
    this.inputPadding = 16.0,

    // Shadows
    required this.messageShadow,
    required this.appBarShadow,
    required this.inputShadow,

    // Animations
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.slideInDuration = const Duration(milliseconds: 400),
    this.typingIndicatorDuration = const Duration(milliseconds: 600),

    // Gradients
    this.useGradientForUserMessages = true,
    this.useGradientForBackground = true,
    this.useGradientForAppBar = true,
    this.useGradientForSendButton = true,

    // Icons
    this.sendIcon = Icons.send_rounded,
    this.attachIcon = Icons.attach_file,
    this.menuIcon = Icons.more_vert,
    this.botIcon =const Icon(Icons.support_agent,) ,
    this.userIcon =const Icon(Icons.person,) ,

    // Spacing
    this.messageBubbleMaxWidth = 0.75,
    this.messageMargin = const EdgeInsets.only(bottom: 12),
    this.inputMargin = const EdgeInsets.all(16),
    this.serviceCardMargin = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

    //
    this.onTapDefaultActionButton,
    this.messageBubbleBuilder,
    this.serviceCardBuilder,
    this.appBarBuilder,
    this.inputBuilder,
  });

  /// Light theme configuration
  factory ChatUIConfig.light() {
    const primaryColor = Color(0xFF6366F1); // Indigo
    const secondaryColor = Color(0xFF8B5CF6); // Purple

    return ChatUIConfig(
      // Colors
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: const Color(0xFFF8F9FA),
      surfaceColor: Colors.white,

      // Message Bubble Colors
      userMessageColor: primaryColor,
      botMessageColor: Colors.white,
      userTextColor: Colors.white,
      botTextColor: const Color(0xFF212529),

      // Input Field Colors
      inputBackgroundColor: const Color(0xFFF1F3F5),
      inputTextColor: const Color(0xFF212529),
      inputHintColor: const Color(0xFF868E96),
      sendButtonColor: primaryColor,

      // App Bar Colors
      appBarBackgroundColor: Colors.white,
      appBarTextColor: const Color(0xFF212529),
      appBarIconColor: primaryColor,
      statusTextColor: Colors.green,

      // Service Card Colors
      serviceCardBackgroundColor: Colors.white,
      serviceCardTextColor: const Color(0xFF212529),
      servicePriceColor: primaryColor,

      // Shadows
      messageShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      appBarShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      inputShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  /// Dark theme configuration
  factory ChatUIConfig.dark() {
    const primaryColor = Color(0xFF818CF8); // Light Indigo
    const secondaryColor = Color(0xFFA78BFA); // Light Purple

    return ChatUIConfig(
      // Colors
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: const Color(0xFF0F172A),
      surfaceColor: const Color(0xFF1E293B),

      // Message Bubble Colors
      userMessageColor: primaryColor,
      botMessageColor: const Color(0xFF334155),
      userTextColor: Colors.white,
      botTextColor: const Color(0xFFF1F5F9),

      // Input Field Colors
      inputBackgroundColor: const Color(0xFF334155),
      inputTextColor: Colors.white,
      inputHintColor: const Color(0xFF94A3B8),
      sendButtonColor: primaryColor,

      // App Bar Colors
      appBarBackgroundColor: const Color(0xFF1E293B),
      appBarTextColor: Colors.white,
      appBarIconColor: primaryColor,
      statusTextColor: Colors.greenAccent,

      // Service Card Colors
      serviceCardBackgroundColor: const Color(0xFF1E293B),
      serviceCardTextColor: Colors.white,
      servicePriceColor: primaryColor,

      // Shadows
      messageShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      appBarShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      inputShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  /// Custom theme with your own colors
  factory ChatUIConfig.custom({
    required Color primaryColor,
    required Color secondaryColor,
    bool isDark = false,
  }) {
    final baseConfig = isDark ? ChatUIConfig.dark() : ChatUIConfig.light();

    return ChatUIConfig(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: baseConfig.backgroundColor,
      surfaceColor: baseConfig.surfaceColor,
      userMessageColor: primaryColor,
      botMessageColor: baseConfig.botMessageColor,
      userTextColor: baseConfig.userTextColor,
      botTextColor: baseConfig.botTextColor,
      inputBackgroundColor: baseConfig.inputBackgroundColor,
      inputTextColor: baseConfig.inputTextColor,
      inputHintColor: baseConfig.inputHintColor,
      sendButtonColor: primaryColor,
      appBarBackgroundColor: baseConfig.appBarBackgroundColor,
      appBarTextColor: baseConfig.appBarTextColor,
      appBarIconColor: primaryColor,
      statusTextColor: baseConfig.statusTextColor,
      serviceCardBackgroundColor: baseConfig.serviceCardBackgroundColor,
      serviceCardTextColor: baseConfig.serviceCardTextColor,
      servicePriceColor: primaryColor,
      messageShadow: baseConfig.messageShadow,
      appBarShadow: baseConfig.appBarShadow,
      inputShadow: baseConfig.inputShadow,
    );
  }

  /// Gradient for user messages
  LinearGradient get userMessageGradient => LinearGradient(
    colors: [primaryColor, secondaryColor],
  );

  /// Gradient for background
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryColor.withValues(alpha: 0.05),
      secondaryColor.withValues(alpha: 0.05),
    ],
  );

  /// Gradient for app bar icon
  LinearGradient get appBarIconGradient => LinearGradient(
    colors: [primaryColor, secondaryColor],
  );

  /// Gradient for send button
  LinearGradient get sendButtonGradient => LinearGradient(
    colors: [primaryColor, secondaryColor],
  );

  /// Copy with method for easy customization
  ChatUIConfig copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? userMessageColor,
    Color? botMessageColor,
    Color? userTextColor,
    Color? botTextColor,
    Color? inputBackgroundColor,
    Color? inputTextColor,
    Color? inputHintColor,
    Color? sendButtonColor,
    Color? appBarBackgroundColor,
    Color? appBarTextColor,
    Color? appBarIconColor,
    Color? statusTextColor,
    Color? serviceCardBackgroundColor,
    Color? serviceCardTextColor,
    Color? servicePriceColor,
    TextStyle? appBarTitleStyle,
    TextStyle? appBarSubtitleStyle,
    TextStyle? messageTextStyle,
    TextStyle? inputTextStyle,
    TextStyle? timestampStyle,
    TextStyle? serviceCardTitleStyle,
    double? messageBorderRadius,
    double? inputBorderRadius,
    double? serviceCardBorderRadius,
    double? messagePadding,
    double? inputPadding,
    List<BoxShadow>? messageShadow,
    List<BoxShadow>? appBarShadow,
    List<BoxShadow>? inputShadow,
    Duration? fadeInDuration,
    Duration? slideInDuration,
    Duration? typingIndicatorDuration,
    bool? useGradientForUserMessages,
    bool? useGradientForBackground,
    bool? useGradientForAppBar,
    bool? useGradientForSendButton,
    IconData? sendIcon,
    IconData? attachIcon,
    IconData? menuIcon,
    Widget? botIcon,
    Widget? userIcon,
    double? messageBubbleMaxWidth,
    EdgeInsets? messageMargin,
    EdgeInsets? inputMargin,
    EdgeInsets? serviceCardMargin,
    void Function(ProductItemModel service)? onTapDefaultActionButton,
    MessageBubbleBuilder? messageBubbleBuilder,
    ServiceCardBuilder? serviceCardBuilder,
    ChatAppBarBuilder? appBarBuilder,
    ChatInputBuilder? inputBuilder,
  }) {
    return ChatUIConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      userMessageColor: userMessageColor ?? this.userMessageColor,
      botMessageColor: botMessageColor ?? this.botMessageColor,
      userTextColor: userTextColor ?? this.userTextColor,
      botTextColor: botTextColor ?? this.botTextColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      inputHintColor: inputHintColor ?? this.inputHintColor,
      sendButtonColor: sendButtonColor ?? this.sendButtonColor,
      appBarBackgroundColor: appBarBackgroundColor ?? this.appBarBackgroundColor,
      appBarTextColor: appBarTextColor ?? this.appBarTextColor,
      appBarIconColor: appBarIconColor ?? this.appBarIconColor,
      statusTextColor: statusTextColor ?? this.statusTextColor,
      serviceCardBackgroundColor: serviceCardBackgroundColor ?? this.serviceCardBackgroundColor,
      serviceCardTextColor: serviceCardTextColor ?? this.serviceCardTextColor,
      servicePriceColor: servicePriceColor ?? this.servicePriceColor,
      appBarTitleStyle: appBarTitleStyle ?? this.appBarTitleStyle,
      appBarSubtitleStyle: appBarSubtitleStyle ?? this.appBarSubtitleStyle,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      timestampStyle: timestampStyle ?? this.timestampStyle,
      serviceCardTitleStyle: serviceCardTitleStyle ?? this.serviceCardTitleStyle,
      messageBorderRadius: messageBorderRadius ?? this.messageBorderRadius,
      inputBorderRadius: inputBorderRadius ?? this.inputBorderRadius,
      serviceCardBorderRadius: serviceCardBorderRadius ?? this.serviceCardBorderRadius,
      messagePadding: messagePadding ?? this.messagePadding,
      inputPadding: inputPadding ?? this.inputPadding,
      messageShadow: messageShadow ?? this.messageShadow,
      appBarShadow: appBarShadow ?? this.appBarShadow,
      inputShadow: inputShadow ?? this.inputShadow,
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
      slideInDuration: slideInDuration ?? this.slideInDuration,
      typingIndicatorDuration: typingIndicatorDuration ?? this.typingIndicatorDuration,
      useGradientForUserMessages: useGradientForUserMessages ?? this.useGradientForUserMessages,
      useGradientForBackground: useGradientForBackground ?? this.useGradientForBackground,
      useGradientForAppBar: useGradientForAppBar ?? this.useGradientForAppBar,
      useGradientForSendButton: useGradientForSendButton ?? this.useGradientForSendButton,
      sendIcon: sendIcon ?? this.sendIcon,
      attachIcon: attachIcon ?? this.attachIcon,
      menuIcon: menuIcon ?? this.menuIcon,
      botIcon: botIcon ?? this.botIcon,
      userIcon: userIcon ?? this.userIcon,
      messageBubbleMaxWidth: messageBubbleMaxWidth ?? this.messageBubbleMaxWidth,
      messageMargin: messageMargin ?? this.messageMargin,
      inputMargin: inputMargin ?? this.inputMargin,
      serviceCardMargin: serviceCardMargin ?? this.serviceCardMargin,
      onTapDefaultActionButton: onTapDefaultActionButton ?? this.onTapDefaultActionButton,
      messageBubbleBuilder: messageBubbleBuilder ?? this.messageBubbleBuilder,
      serviceCardBuilder: serviceCardBuilder ?? this.serviceCardBuilder,
      appBarBuilder: appBarBuilder ?? this.appBarBuilder,
      inputBuilder: inputBuilder ?? this.inputBuilder,
    );
  }
}