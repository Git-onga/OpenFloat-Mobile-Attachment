import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class ChatPage extends StatefulWidget {
  final String workerName;
  final String workerProfession;
  final String? workerImageUrl;

  const ChatPage({
    super.key,
    required this.workerName,
    this.workerProfession = '',
    this.workerImageUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
  }

  void _loadMockMessages() {
    final now = DateTime.now();
    _messages.addAll([
      _ChatMessage(
        text: 'Hello! I just arrived at the site. I\'ll start with the initial assessment.',
        isMe: false,
        time: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      _ChatMessage(
        text: 'Great, thank you! Let me know if you need anything.',
        isMe: true,
        time: now.subtract(const Duration(hours: 2, minutes: 28)),
      ),
      _ChatMessage(
        text: 'The main issue is the burst pipe under the kitchen sink. I\'ll need to replace about 2 feet of piping.',
        isMe: false,
        time: now.subtract(const Duration(hours: 2, minutes: 15)),
      ),
      _ChatMessage(
        text: 'Is the water supply turned off? I can show you the shut-off valve if needed.',
        isMe: true,
        time: now.subtract(const Duration(hours: 2, minutes: 10)),
      ),
      _ChatMessage(
        text: 'Yes, I\'ve already shut it off. I have all the replacement parts with me. Should take about 1-2 hours.',
        isMe: false,
        time: now.subtract(const Duration(hours: 2)),
      ),
      _ChatMessage(
        text: 'Perfect. I\'ll be in the living room if you need me.',
        isMe: true,
        time: now.subtract(const Duration(hours: 1, minutes: 58)),
      ),
      _ChatMessage(
        text: 'Quick update: the pipe is replaced and I\'m sealing the joints now. Running ahead of schedule!',
        isMe: false,
        time: now.subtract(const Duration(hours: 1, minutes: 20)),
      ),
      _ChatMessage(
        text: 'Awesome news! Thank you for the update.',
        isMe: true,
        time: now.subtract(const Duration(hours: 1, minutes: 18)),
      ),
      _ChatMessage(
        text: 'All done! I\'ve tested the water pressure and everything is working perfectly. No more leaks. I\'ll clean up and send you the final report.',
        isMe: false,
        time: now.subtract(const Duration(minutes: 30)),
      ),
      _ChatMessage(
        text: 'Thank you so much! Excellent work. I\'ll leave a review.',
        isMe: true,
        time: now.subtract(const Duration(minutes: 28)),
      ),
    ]);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
        title: Row(
          children: [
            // Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.inputFill,
                border: Border.all(
                  color: AppColors.navy.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.person, color: AppColors.navy, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workerName,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                if (widget.workerProfession.isNotEmpty)
                  Text(
                    widget.workerProfession,
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.primaryDark, size: 22),
            onPressed: () {
              // TODO: Initiate call
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.navy,
                      width: 1,
                    ),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.navy,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppColors.textOnPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');
    return '$hour:$min $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            // Avatar for other person
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navy.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.navy,
                size: 16,
              ),
            ),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppColors.navy
                    : AppColors.inputFill,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: message.isMe
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.time),
                    style: GoogleFonts.nunito(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: message.isMe
                          ? AppColors.textOnPrimary.withValues(alpha: 0.6)
                          : AppColors.textSecondary,
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
