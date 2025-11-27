class BotResponseModel {
  final bool success;
  final String message;
  final String? error;
  final ResponseData? data;

  BotResponseModel({
    required this.success,
    required this.message,
    this.error,
    this.data,
  });

  factory BotResponseModel.fromJson(Map<String, dynamic> json) {
    return BotResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      error: json['error'],
      data: json['data'] != null
          ? ResponseData.fromJson(json['data'])
          : null,
    );
  }
}

class ResponseData {
  final ContentData? content;
  final Extra? extra;
  final ModelData? modelData;
  final Usage? usage;

  ResponseData({
    this.content,
    this.extra,
    this.modelData,
    this.usage,
  });

  factory ResponseData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ResponseData();

    return ResponseData(
      content: json['content'] != null
          ? ContentData.fromJson(json['content'])
          : null,
      extra: json['extra'] != null
          ? Extra.fromJson(json['extra'])
          : null,
      modelData: json['model_data'] != null
          ? ModelData.fromJson(json['model_data'])
          : null,
      usage: json['usage'] != null
          ? Usage.fromJson(json['usage'])
          : null,
    );
  }
}

class ContentData {
  final List<Part> parts;
  final String role;

  ContentData({
    required this.parts,
    required this.role,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      parts: (json['parts'] as List<dynamic>? ?? [])
          .map((p) => Part.fromJson(p))
          .toList(),
      role: json['role'] ?? 'model',
    );
  }

  String get text => parts.isNotEmpty ? parts.first.text : '';
}

class Part {
  final String text;

  Part({required this.text});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(text: json['text'] ?? '');
  }
}

class Extra {
  final FunctionCall? functionCall;

  Extra({this.functionCall});

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      functionCall: json['functionCall'] != null
          ? FunctionCall.fromJson(json['functionCall'])
          : null,
    );
  }
}

class FunctionCall {
  final String name;
  final Map<String, dynamic> args;

  FunctionCall({
    required this.name,
    required this.args,
  });

  factory FunctionCall.fromJson(Map<String, dynamic>? json) {
    return FunctionCall(
      name: json?['name'] ?? '',
      args: (json?['args'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ModelData {
  final String? model;
  final String? platform;

  ModelData({
    this.model,
    this.platform,
  });

  factory ModelData.fromJson(Map<String, dynamic>? json) {
    return ModelData(
      model: json?['model'] as String?,
      platform: json?['platform'] as String?,
    );
  }
}

class Usage {
  final int promptTokens;
  final int responseTokens;
  final int totalTokens;

  Usage({
    this.promptTokens = 0,
    this.responseTokens = 0,
    this.totalTokens = 0,
  });

  factory Usage.fromJson(Map<String, dynamic>? json) {
    return Usage(
      promptTokens: json?['promptTokens'] ?? 0,
      responseTokens: json?['responseTokens'] ?? 0,
      totalTokens: json?['totalTokens'] ?? 0,
    );
  }
}

class CategoryData {
  final String category;
  final List<String> items;

  CategoryData({
    required this.category,
    required this.items,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      category: json['category'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'items': items,
    };
  }
}




