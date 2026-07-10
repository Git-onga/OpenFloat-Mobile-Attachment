import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/chat/presentation/pages/chat_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square, color: AppColors.navy, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _conversations.length,
        separatorBuilder: (_, _) => const Divider(
          color: AppColors.border,
          height: 1,
          indent: 64,
        ),
        itemBuilder: (context, index) {
          final convo = _conversations[index];
          return _ConversationTile(
            conversation: convo,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    workerName: convo.name,
                    workerProfession: convo.profession,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Conversation {
  final String name;
  final String profession;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  const _Conversation({
    required this.name,
    required this.profession,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

final List<_Conversation> _conversations = [
  _Conversation(
    name: 'Muriuki James',
    profession: 'Plumber',
    lastMessage: 'All done! Tested the pressure and everything is working. I\'ll send the report.',
    time: '30 min',
    unreadCount: 2,
    isOnline: true,
  ),
  _Conversation(
    name: 'Wanjiku Njeri',
    profession: 'Painter',
    lastMessage: 'I\'ll bring the colour samples tomorrow morning for you to choose.',
    time: '1 hour',
    unreadCount: 0,
    isOnline: true,
  ),
  _Conversation(
    name: 'Otieno Kip',
    profession: 'Electrician',
    lastMessage: 'Yes, confirmed for July 12th. I\'ll be there at 8am.',
    time: '3 hours',
    unreadCount: 1,
    isOnline: false,
  ),
  _Conversation(
    name: 'Kamau Mwangi',
    profession: 'Landscaper',
    lastMessage: 'I\'ve sourced the Bermuda grass. It looks great!',
    time: 'Yesterday',
    unreadCount: 0,
    isOnline: false,
  ),
  _Conversation(
    name: 'Akinyi Chebet',
    profession: 'Cleaner',
    lastMessage: 'Thank you for the 5-star review! Happy to help anytime.',
    time: 'Yesterday',
    unreadCount: 0,
    isOnline: false,
  ),
  _Conversation(
    name: 'Njuguna Peter',
    profession: 'Carpenter',
    lastMessage: 'The custom bookshelf design is ready. I\'ve sent it to your email.',
    time: '2 days ago',
    unreadCount: 0,
    isOnline: true,
  ),
  _Conversation(
    name: 'Faith Mueni',
    profession: 'Interior Designer',
    lastMessage: 'Let me know which colour palette you prefer and I\'ll start.',
    time: '3 days ago',
    unreadCount: 0,
    isOnline: false,
  ),
  _Conversation(
    name: 'Support Team',
    profession: 'KaziConnect',
    lastMessage: 'Your issue has been resolved. Is there anything else we can help with?',
    time: '1 week ago',
    unreadCount: 0,
    isOnline: false,
  ),
];

class _ConversationTile extends StatelessWidget {
  final _Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: conversation.isOnline
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.inputFill,
                    border: Border.all(
                      color: AppColors.navy.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      conversation.name[0].toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // Conversation info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conversation.time,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: conversation.unreadCount > 0
                              ? AppColors.navy
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: conversation.unreadCount > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
