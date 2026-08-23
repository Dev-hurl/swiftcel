import 'package:flutter/material.dart';

enum MessageSender { me, them }

class ChatMessage {
  final MessageSender sender;
  final String text;
  final String time;
  final bool isRead;
  final String? mapImagePath;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    this.isRead = false,
    this.mapImagePath,
  });
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  // TODO: replace with real stream from ChatProvider
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: MessageSender.them,
      text:
          "Hello! I've picked up your parcel and I'm currently at the South Expressway. Traffic is moving well.",
      time: '10:42 AM',
    ),
    ChatMessage(
      sender: MessageSender.them,
      text: 'ETA is approximately 12 minutes.',
      time: '10:43 AM',
      mapImagePath: 'assets/images/google_map.png',
    ),
    ChatMessage(
      sender: MessageSender.me,
      text:
          "That's great, thank you Marcus! I'll be downstairs at the main lobby to meet you.",
      time: '10:45 AM',
      isRead: true,
    ),
    ChatMessage(
      sender: MessageSender.me,
      text: 'Should I bring any documentation for the pickup?',
      time: '10:45 AM',
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    // TODO: call ChatProvider.sendMessage(widget.chatId, _messageController.text)
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceBright,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.secondary,
              child: Text(
                'MC',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.surfaceBright,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marcus Chen',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'ONLINE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.call_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              // TODO: initiate call
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ..._messages.map((m) => _MessageBubble(message: m)),
                SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(width: 4),
                    Text(
                      '•••',
                      style: TextStyle(
                        color: colorScheme.secondary,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Marcus is typing...',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFFCE4E4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        suffixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: colorScheme.secondary,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: colorScheme.surfaceBright,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final isMe = message.sender == MessageSender.me;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe
                    ? colorScheme.secondary
                    : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(isMe ? 14 : 2),
                  bottomRight: Radius.circular(isMe ? 2 : 14),
                ),
              ),
              child: Text(
                message.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: isMe
                      ? colorScheme.surfaceBright
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (message.mapImagePath != null) ...[
              SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  message.mapImagePath!,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isMe && message.isRead) ...[
                  SizedBox(width: 4),
                  Icon(Icons.done_all, size: 13, color: Colors.green),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
