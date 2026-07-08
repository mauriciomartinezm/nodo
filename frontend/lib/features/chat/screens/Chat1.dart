import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/core/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isMe: true, time: _getCurrentTime()));
      _controller.clear();
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message(
          text: _generateAutoReply(text),
          isMe: false,
          time: _getCurrentTime(),
        ));
      });
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'p.m.' : 'a.m.';
    return '$hour:$minute $period';
  }

  String _generateAutoReply(String userMessage) {
    return "Gracias por tu mensaje: \"$userMessage\". Pronto te responderé.";
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Enviar imagen'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Enviar ubicación'),
                onTap: () {
                  Navigator.pop(context);
                  _sendLocation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _messages.add(Message(
          text: '[Imagen adjunta: ${pickedFile.path.split('/').last}]',
          isMe: true,
          time: _getCurrentTime(),
        ));
      });
    }
  }

  void _sendLocation() {
    setState(() {
      _messages.add(Message(
        text: '📍 Ubicación enviada: Parque Central, Ciudad XYZ',
        isMe: true,
        time: _getCurrentTime(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: const BackButton(color: Colors.white),
        title: Row(
          children: [
            const CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(11.0),
                child: Image(
                  image: AssetImage('assets/icons/iconNodoBlue.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MLP KEHIBER', style: AppTypography.subtitle.copyWith(color: Colors.white)),
                Text('Joder la vida', style: AppTypography.label.copyWith(color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: msg.isMe ? const Color(0xFF004D99) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(color: msg.isMe ? Colors.white : Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.time,
                          style: AppTypography.caption.copyWith(
                            color: msg.isMe ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                  onPressed: _showAttachmentOptions,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Mensaje',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
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

class Message {
  final String text;
  final bool isMe;
  final String time;

  Message({required this.text, required this.isMe, required this.time});
}
