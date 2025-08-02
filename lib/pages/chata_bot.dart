import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // Paste your Hugging Face API key here:
  final String huggingFaceApiKey = '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';

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"user": message});
    });

    _controller.clear();

    final response = await _getBotReply(message);

    setState(() {
      _messages.add({"bot": response});
    });
  }

  Future<String> _getBotReply(String userMessage) async {
    const url =
        'https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $huggingFaceApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"inputs": userMessage}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null &&
          data is List &&
          data.isNotEmpty &&
          data[0]['generated_text'] != null) {
        return data[0]['generated_text'].toString().trim();
      } else {
        return 'Bot could not understand.';
      }
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Bot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final entry = _messages[index];
                final isUser = entry.containsKey("user");
                final message = isUser ? entry["user"]! : entry["bot"]!;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
