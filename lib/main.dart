import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'gen_model.dart';

const String _apiKey = String.fromEnvironment('API_KEY');

void main() async {
  final modelInitializer = ModelInitializer(apiKey: _apiKey);
  final model = await modelInitializer.initializeModel();

  runApp(MyApp(model: model));
}

class MyApp extends StatelessWidget {
  final GenerativeModel model;

  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(model: model),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final GenerativeModel model;

  const MyHomePage({Key? key, required this.model}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ChatSession _chatSession;
  late final TextEditingController _textController;
  String _receivedMessage = "";

  @override
  void initState() {
    super.initState();
    _chatSession = widget.model.startChat();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final response =
        await _chatSession.sendMessage(Content.text(_textController.text));
    final receivedMessage = response.text ?? "No response";
    print("Received message: $receivedMessage");
    setState(() {
      _receivedMessage = receivedMessage;
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Received message will appear here:',
            ),
            Text(
              _receivedMessage,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
