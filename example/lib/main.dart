import 'package:flutter/material.dart';
import 'package:xl_bot/xl_bot.dart';

void main() {
  // Initialize SalesBotConfig once at app startup
  final config = SalesBotConfig(
    projectId: 'fltai_Lpkt4kpb5o1RcPVe85ZCxgC44hGLlt3n',
    searchApis: [
      SearchApi(name: 'Service provider', searchUrl: 'https://cityprofessionals.connivia.com/api/v1/customer/service/search'),
      SearchApi(name: 'Blood test', searchUrl: 'https://911.connivia.com/api/patient/v2/fetch-all-packages')
    ],
    defaultTimeout: const Duration(seconds: 8),
  );

  // Initialize the config manager globally
  SalesBotConfigManager.initialize(config);

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Sales Bot Example')),
        body: const Center(child: Text('Tap the chat button')),
        floatingActionButton: SalesBotButton(
          icon: const Icon(Icons.support_agent, size: 28),
          useGradient: true,
          size: 64,
          tooltip: 'Get Support',
          uiConfig: ChatUIConfig.light(

          ).copyWith(

            botIcon: const Icon(Icons.support_agent, size: 28),
            onTapDefaultActionButton: (value) {
              // Handle action button tap
              debugPrint('Action button : ${value.toJson()}');
            },
          ),
        ),
      ),
    );
  }
}
