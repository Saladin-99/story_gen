import 'package:google_generative_ai/google_generative_ai.dart';

class ModelInitializer {
  final String apiKey;

  ModelInitializer({required this.apiKey});

  Future<GenerativeModel> initializeModel() async {
    final model = GenerativeModel(model: 'gemini-1.0-pro-001', apiKey: apiKey);
    return model;
  }
}
