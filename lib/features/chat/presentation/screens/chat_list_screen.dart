import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';

enum ChatCounterpart { sender, rider, support }

enum ChatFilter { all, senders, riders, support }

class ChatPreview {
  final String name;
  final String initials;
  final Color avatarColor;
  final ChatCounterpart counterpart;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isRead;
  final bool isPinned;
  final bool isOnline;
  final IconData? trailingIcon;

  const ChatPreview({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.counterpart,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isRead = false,
    this.isPinned = false,
    this.isOnline = false,
    this.trailingIcon,
  });
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatFilter _selected = ChatFilter.all;

  // TODO: replace with real data from ChatProvider / Firestore stream
  final List<ChatPreview> _chats = const [
    ChatPreview(
      name: 'Marcus Chen (Sender)',
      initials: 'MC',
      avatarColor: Color(0xFFD32F2F),
      counterpart: ChatCounterpart.sender,
      lastMessage: 'The shipment is ready fo...',
      time: '12:45 PM',
      unreadCount: 2,
      isPinned: true,
      isOnline: true,
    ),
    ChatPreview(
      name: 'Sarah Jenkins (Rider)',
      initials: 'SJ',
      avatarColor: Color(0xFF43A047),
      counterpart: ChatCounterpart.rider,
      lastMessage: "I've just arrived at the dro...",
      time: '11:30 AM',
      isRead: true,
    ),
    ChatPreview(
      name: 'SwiftCel Support Bot',
      initials: '',
      avatarColor: Color(0xFFD32F2F),
      counterpart: ChatCounterpart.support,
      lastMessage: 'Your weekly earnings rep...',
      time: '09:15 AM',
      trailingIcon: Icons.chevron_right,
    ),
    ChatPreview(
      name: 'David Wilson (Sender)',
      initials: 'DW',
      avatarColor: Color(0xFF1565C0),
      counterpart: ChatCounterpart.sender,
      lastMessage: 'Thanks for the quick turna...',
      time: 'Yesterday',
      trailingIcon: Icons.chevron_right,
    ),
    ChatPreview(
      name: 'Big T Logistics',
      initials: 'BT',
      avatarColor: Color(0xFF6D4C41),
      counterpart: ChatCounterpart.support,
      lastMessage: 'Sent a photo: Gate code i...',
      time: 'June 14',
      trailingIcon: Icons.image_outlined,
    ),
  ];

  List<ChatPreview> get _filteredChats {
    switch (_selected) {
      case ChatFilter.all:
        return _chats;
      case ChatFilter.senders:
        return _chats
            .where((c) => c.counterpart == ChatCounterpart.sender)
            .toList();
      case ChatFilter.riders:
        return _chats
            .where((c) => c.counterpart == ChatCounterpart.rider)
            .toList();
      case ChatFilter.support:
        return _chats
            .where((c) => c.counterpart == ChatCounterpart.support)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: textheme.headlineMedium),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _selected == ChatFilter.all,
                      onTap: () => setState(() => _selected = ChatFilter.all),
                    ),
                    SizedBox(width: 8),
                    _FilterChip(
                      label: 'Senders',
                      isSelected: _selected == ChatFilter.senders,
                      onTap: () =>
                          setState(() => _selected = ChatFilter.senders),
                    ),
                    SizedBox(width: 8),
                    _FilterChip(
                      label: 'Riders',
                      isSelected: _selected == ChatFilter.riders,
                      onTap: () =>
                          setState(() => _selected = ChatFilter.riders),
                    ),
                    SizedBox(width: 8),
                    _FilterChip(
                      label: 'Support',
                      isSelected: _selected == ChatFilter.support,
                      onTap: () =>
                          setState(() => _selected = ChatFilter.support),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: _filteredChats.length,
                  itemBuilder: (context, index) => _ChatTile(
                    chat: _filteredChats[index],
                    onTap: () {
                      // TODO: Navigator.push to '/chat/:chatId' with real chatId
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFD32F2F),
              onPressed: () {
                // TODO: open compose/new chat
              },
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangeSecondary : AppColors.greyBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.surfaceVariant,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(color: colorScheme.surface),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatPreview chat;
  final VoidCallback onTap;

  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: chat.isPinned
              ? const Border(
                  left: BorderSide(color: AppColors.orangePrimary, width: 4),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: chat.avatarColor,
                  child: chat.counterpart == ChatCounterpart.support
                      ? const Icon(
                          Icons.headset_mic,
                          color: Colors.white,
                          size: 18,
                        )
                      : Text(
                          chat.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                if (chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: chat.unreadCount > 0
                        ? const Color(0xFFD32F2F)
                        : Colors.black45,
                  ),
                ),
                const SizedBox(height: 6),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD32F2F),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  )
                else if (chat.isRead)
                  const Icon(Icons.done_all, size: 16, color: Colors.green)
                else if (chat.trailingIcon != null)
                  Icon(chat.trailingIcon, size: 16, color: Colors.black38),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
