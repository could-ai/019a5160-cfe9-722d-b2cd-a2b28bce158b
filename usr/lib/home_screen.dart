import 'package:flutter/material.dart';
import 'package:couldai_user_app/chat_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  String _currentRole = 'General Assistant';
  final List<String> _roles = [
    'General Assistant',
    'Flutter Expert',
    'Storyteller',
    'Sarcastic Bot'
  ];

  @override
  void initState() {
    super.initState();
    _resetChat();
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _messages.add({
        "sender": "ai",
        "text": _getInitialMessageForRole(_currentRole),
      });
    });
  }

  String _getInitialMessageForRole(String role) {
    switch (role) {
      case 'Flutter Expert':
        return "Hello! I'm your Flutter Expert. Ask me anything about widgets, state management, or Dart!";
      case 'Storyteller':
        return "Greetings! I am the Storyteller. What kind of tale shall we weave today?";
      case 'Sarcastic Bot':
        return "Oh, great. Another human to bother me. What do you want?";
      case 'General Assistant':
      default:
        return "Hello! How can I help you today?";
    }
  }

  String _getAIResponseForRole(String role, String userMessage) {
    switch (role) {
      case 'Flutter Expert':
        return "From a Flutter Expert's perspective regarding '${userMessage.toLowerCase()}', you should probably check the official documentation. But in short, it's all about widgets.";
      case 'Storyteller':
        return "That's an interesting start! So, '${userMessage.toLowerCase()}'... Once upon a time, in a land far, far away...";
      case 'Sarcastic Bot':
        return "Did you really just say '${userMessage.toLowerCase()}'? Wow. I'm... impressed by your originality. *rolls eyes*";
      case 'General Assistant':
      default:
        return "That's a great question! While I'm just a placeholder, I'll do my best to help with that.";
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add({
          "sender": "user",
          "text": userMessage,
        });
        // Simulate AI response
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _messages.add({
              "sender": "ai",
              "text": _getAIResponseForRole(_currentRole, userMessage),
            });
          });
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Super App'),
        centerTitle: true,
        actions: [
          DropdownButton<String>(
            value: _currentRole,
            icon: const Icon(Icons.person, color: Colors.white),
            dropdownColor: const Color(0xFF1A1A1A),
            underline: Container(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _currentRole = newValue;
                  _resetChat();
                });
              }
            },
            items: _roles.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message['text']!,
                  isMe: message['sender'] == 'user',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
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
