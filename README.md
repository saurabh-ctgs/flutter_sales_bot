<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Xl Bot

A Flutter chat/support/sales bot UI and integration helper. This package provides a lightweight, fully customizable chat UI component with helpers to wire it to search/service APIs for seamless integration.

## Features

- **Floating Chat Button** (`SalesBotButton`) - Customizable floating action button that opens a chat UI
- **Global Configuration** - Easy setup via `SalesBotConfig` and `SalesBotConfigManager`
- **Theme Customization** - Complete UI theming with `ChatUIConfig` (light/dark themes, custom colors, typography, dimensions)


## Table of Contents

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Quick Setup](#quick-setup)
- [Integration Guide](#integration-guide)
- [UI Customization](#ui-customization)
- [Advanced Configuration](#advanced-configuration)
- [Examples](#examples)

## Getting Started

### Prerequisites

- Flutter SDK: `>=1.17.0`
- Dart SDK: `^3.9.2`
- Run `flutter pub get` to fetch dependencies

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_sales_bot: ^0.0.1
```



Then run:

```bash
flutter pub get
```

## Quick Setup

### Step 1: Initialize Configuration (Required)

Initialize the configuration once in your `main()` function **before** calling `runApp()`:

```dart
import 'package:xl_bot/flutter_sales_bot.dart';

void main() {
  final config = SalesBotConfig(
    projectId: 'your_project_id',
    searchApis: [
      SearchApi(
        name: 'Services',
        searchUrl: 'https://api.example.com/services/search',
      ),
      SearchApi(
        name: 'Products',
        searchUrl: 'https://api.example.com/products/search',
      ),
    ],
    defaultTimeout: const Duration(seconds: 8),
    topKeywordCount: 5,
  );

  SalesBotConfigManager.initialize(config);
  runApp(const MyApp());
}
```

### Step 2: Add the Chat Button

Add the `SalesBotButton` to your scaffold:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My App')),
        body: const Center(child: Text('Welcome')),
        floatingActionButton: SalesBotButton(
          icon: const Icon(Icons.support_agent, size: 28),
          tooltip: 'Open Chat',
        ),
      ),
    );
  }
}
```

## Integration Guide

### SalesBotConfig

The `SalesBotConfig` class manages all configuration for the chat bot.

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `projectId` | `String` | Yes | Unique identifier for your project |
| `searchApis` | `List<SearchApi>` | Yes | List of API endpoints (minimum 1) |
| `defaultTimeout` | `Duration` | No | Timeout for API requests (default: 8s) |
| `topKeywordCount` | `int` | No | Max keywords to extract (default: 5) |
| `onBeforeSearch` | `BeforeSearchCallback` | No | Callback before search is performed |
| `onResult` | `OnResultCallback` | No | Callback when search results arrive |

#### Example with Callbacks

```dart
final config = SalesBotConfig(
  projectId: 'my_project',
  searchApis: [
    SearchApi(
      name: 'Hospital Search',
      searchUrl: 'https://api.example.com/hospitals',
    ),
  ],
  defaultTimeout: const Duration(seconds: 10),
  topKeywordCount: 3,
  onBeforeSearch: (query, keywords) {
    print('Searching for: $query');
    print('Keywords: $keywords');
  },
  onResult: (apiName, result) {
    print('Got results from: $apiName');
    print('Result: $result');
  },
);

SalesBotConfigManager.initialize(config);
```

### SearchApi

Configure search endpoints for your services.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | `String` | Display name for this API |
| `searchUrl` | `String` | Base URL for searches |
| `searchParamsKey` | `List<String>` | URL parameter keys (optional) |

#### Example

```dart
SearchApi(
  name: 'Product Search',
  searchUrl: 'https://api.example.com/products/search',
  searchParamsKey: ['category', 'filter'],
)
```

## UI Customization

### Using Themes

#### Light Theme (Default)

```dart
SalesBotButton(
  uiConfig: ChatUIConfig.light(),
  icon: const Icon(Icons.chat),
),
```

#### Dark Theme

```dart
SalesBotButton(
  uiConfig: ChatUIConfig.dark(),
  icon: const Icon(Icons.chat),
),
```

### Complete Customization with copyWith

Customize all aspects of the UI using `copyWith()`:

```dart
floatingActionButton: SalesBotButton(
  uiConfig: ChatUIConfig.light().copyWith(
    // Colors
    primaryColor: Color(0xFF6366F1),
    secondaryColor: Color(0xFF8B5CF6),
    backgroundColor: Color(0xFFF8F9FA),
    
    // Message styling
    userMessageColor: Color(0xFF6366F1),
    botMessageColor: Colors.white,
    userTextColor: Colors.white,
    botTextColor: Color(0xFF212529),
    
    // Input field
    inputBackgroundColor: Color(0xFFF1F3F5),
    inputTextColor: Color(0xFF212529),
    sendButtonColor: Color(0xFF6366F1),
    
    // App bar
    appBarBackgroundColor: Color(0xFF6366F1),
    appBarTextColor: Colors.white,
    
    // Dimensions
    messageBorderRadius: 16.0,
    inputBorderRadius: 24.0,
    serviceCardBorderRadius: 12.0,
    
    // Animations
    fadeInDuration: Duration(milliseconds: 300),
    slideInDuration: Duration(milliseconds: 400),
    
    // Gradients
    useGradientForUserMessages: true,
    useGradientForBackground: true,
    useGradientForAppBar: true,
    useGradientForSendButton: true,
    
    // Typography
    appBarTitleStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    messageTextStyle: TextStyle(fontSize: 16),
    inputTextStyle: TextStyle(fontSize: 16),
    
    // Icons
    sendIcon: Icons.send_rounded,
    botIcon: Icon(Icons.support_agent),
    userIcon: Icon(Icons.person),
    
    // Callbacks
    onTapDefaultActionButton: (value) {
      print('Action tapped: ${value.toJson()}');
    },
  ),
),
```

### Advanced UI Customization

#### Custom Button Styling

```dart
SalesBotButton(
  // Button appearance
  icon: const Icon(Icons.support_agent, size: 28),
  backgroundColor: const Color(0xFF6366F1),
  foregroundColor: Colors.white,
  size: 64,
  elevation: 8,
  
  // Gradient effect
  useGradient: true,
  
  // Position
  margin: const EdgeInsets.all(16),
  
  // Behavior
  tooltip: 'Get Support',
  onPressed: () {
    // Custom navigation or action
  },
  
  // UI Config
  uiConfig: ChatUIConfig.light(),
)
```

#### Custom Message Bubble

```dart
final config = ChatUIConfig.light().copyWith(
  messageBubbleBuilder: (context, message, controller, config) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isUserMessage 
          ? config.userMessageColor 
          : config.botMessageColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: message.isUserMessage 
            ? config.userTextColor 
            : config.botTextColor,
        ),
      ),
    );
  },
);
```

#### Custom Service Card

```dart
final config = ChatUIConfig.light().copyWith(
  serviceCardBuilder: (context, service, config, buttons) {
    return Card(
      child: Column(
        children: [
          Text(service.title),
          Text('\$${service.price}'),
          if (buttons != null) ...buttons,
        ],
      ),
    );
  },
);
```

### ChatUIConfig Properties Reference

#### Color Customization

```dart
ChatUIConfig.light().copyWith(
  // Primary colors
  primaryColor: Color(0xFF6366F1),           // Main brand color
  secondaryColor: Color(0xFF8B5CF6),         // Accent color
  
  // Background
  backgroundColor: Color(0xFFF8F9FA),        // Chat background
  surfaceColor: Colors.white,                // Surface elements
  
  // Message bubbles
  userMessageColor: Color(0xFF6366F1),       // User message background
  botMessageColor: Colors.white,             // Bot message background
  userTextColor: Colors.white,               // User message text
  botTextColor: Color(0xFF212529),           // Bot message text
  
  // Input field
  inputBackgroundColor: Color(0xFFF1F3F5),
  inputTextColor: Color(0xFF212529),
  inputHintColor: Color(0xFF868E96),
  sendButtonColor: Color(0xFF6366F1),
  
  // App bar
  appBarBackgroundColor: Color(0xFF6366F1),
  appBarTextColor: Colors.white,
  appBarIconColor: Colors.white,
  
  // Service cards
  serviceCardBackgroundColor: Colors.white,
  serviceCardTextColor: Color(0xFF212529),
  servicePriceColor: Color(0xFF6366F1),
)
```

#### Typography Customization

```dart
ChatUIConfig.light().copyWith(
  appBarTitleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  messageTextStyle: TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
  ),
  inputTextStyle: TextStyle(
    fontSize: 16,
  ),
  timestampStyle: TextStyle(
    fontSize: 12,
    color: Colors.grey,
  ),
  serviceCardTitleStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
)
```

#### Dimensions & Spacing

```dart
ChatUIConfig.light().copyWith(
  // Border radius
  messageBorderRadius: 16.0,
  inputBorderRadius: 24.0,
  serviceCardBorderRadius: 12.0,
  
  // Padding
  messagePadding: 12.0,
  inputPadding: 16.0,
  
  // Margins
  messageMargin: EdgeInsets.only(bottom: 12),
  inputMargin: EdgeInsets.all(16),
  serviceCardMargin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  
  // Max width
  messageBubbleMaxWidth: 0.75,  // 75% of screen width
)
```

#### Animations

```dart
ChatUIConfig.light().copyWith(
  fadeInDuration: Duration(milliseconds: 300),
  slideInDuration: Duration(milliseconds: 400),
  typingIndicatorDuration: Duration(milliseconds: 600),
)
```

#### Shadow & Visual Effects

```dart
ChatUIConfig.light().copyWith(
  messageShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ],
  appBarShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
  inputShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
    ),
  ],
  useGradientForUserMessages: true,
  useGradientForBackground: true,
  useGradientForAppBar: true,
  useGradientForSendButton: true,
)
```

## Advanced Configuration

### Action Buttons

Add custom action buttons to handle user interactions:

```dart
SalesBotButton(
  actionButtons: [
    ActionButton(
      label: 'View Details',
      onPressed: (product) {
        // Handle action
      },
    ),
    ActionButton(
      label: 'Book Now',
      onPressed: (product) {
        // Handle booking
      },
    ),
  ],
  uiConfig: ChatUIConfig.light(),
)
```

### Error Handling

Implement error handling with callbacks:

```dart
final config = SalesBotConfig(
  projectId: 'my_project',
  searchApis: [
    SearchApi(
      name: 'Service Search',
      searchUrl: 'https://api.example.com/search',
    ),
  ],
  onResult: (apiName, result) {
    // Check for errors in result
    if (result.containsKey('error')) {
      print('Error from $apiName: ${result['error']}');
    }
  },
);
```



## Troubleshooting

### "SalesBotConfig not initialized" Error

**Problem**: You see `Exception: SalesBotConfig not initialized`

**Solution**: Make sure you call `SalesBotConfigManager.initialize(config)` in `main()` before `runApp()`.

### Chat Button Not Appearing

**Problem**: The floating action button doesn't show

**Solution**: 
- Ensure `floatingActionButton` is not null in your Scaffold
- Check that the widget tree is properly built
- Verify that the context is correct

### API Requests Timing Out

**Problem**: Search results take too long or timeout

**Solution**: 
- Increase `defaultTimeout` in `SalesBotConfig`
- Check your API endpoint URLs
- Verify network connectivity
- Check the `onResult` callback for errors

### UI Not Customizing

**Problem**: Your `ChatUIConfig` changes aren't appearing

**Solution**:
- Make sure you're using `copyWith()` instead of creating a new config
- Verify color values are valid
- Check that the UI Config Manager has the config initialized

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or feature requests, please open an issue on the repository.

