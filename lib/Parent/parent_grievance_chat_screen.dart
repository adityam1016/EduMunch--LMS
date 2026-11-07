import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentGrievanceChatScreen extends StatefulWidget {
  final String grievanceId;
  final String grievanceTitle;
  final String grievanceStatus;

  const ParentGrievanceChatScreen({
    super.key,
    required this.grievanceId,
    required this.grievanceTitle,
    required this.grievanceStatus,
  });

  @override
  State<ParentGrievanceChatScreen> createState() =>
      _ParentGrievanceChatScreenState();
}

class _ParentGrievanceChatScreenState extends State<ParentGrievanceChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'message': 'Math teacher is not responding to student queries properly during revision lectures.',
      'sender': 'parent',
      'timestamp': '10:30 AM',
      'senderName': 'Manoj Sharma',
    },
    {
      'id': '2',
      'message':
          'Thank you for bringing this to our attention. We have flagged this with Academic Operations and the subject coordinator.',
      'sender': 'admin',
      'timestamp': '11:15 AM',
      'senderName': 'Admin Office',
    },
    {
      'id': '3',
      'message': 'When can we expect an update or extra doubt slot?',
      'sender': 'parent',
      'timestamp': '02:20 PM',
      'senderName': 'Manoj Sharma',
    },
    {
      'id': '4',
      'message':
          'We have scheduled a dedicated extra doubt lecture for 11th JEE Maths tomorrow at 4 PM. Prof. Aditya will be conducting it.',
      'sender': 'admin',
      'timestamp': '04:45 PM',
      'senderName': 'Admin Office',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'message': _messageController.text.trim(),
        'sender': 'parent',
        'timestamp': 'Just now',
        'senderName': 'Manoj Sharma',
      });
    });

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: widget.grievanceTitle,
              isRoot: false,
              onLeadingTap: () => Get.back(),
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(messages[index]);
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final bool isParent = msg['sender'] == 'parent';
    final width = MediaQuery.of(context).size.width * 0.74;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isParent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isParent) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: NMTheme.surface,
                shape: BoxShape.circle,
                boxShadow: NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.admin_panel_settings_rounded, color: NMTheme.primaryPurple, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(maxWidth: width),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isParent ? null : NMTheme.cardBg,
              gradient: isParent ? NMTheme.primaryGradient : null,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isParent ? 16 : 4),
                bottomRight: Radius.circular(isParent ? 4 : 16),
              ),
              boxShadow: isParent
                  ? [
                      BoxShadow(
                        color: NMTheme.primaryPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : NMTheme.cardShadows,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg['message'],
                  style: TextStyle(
                    color: isParent ? Colors.white : NMTheme.textDark,
                    fontSize: 13.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  msg['timestamp'],
                  style: TextStyle(
                    color: isParent ? Colors.white70 : NMTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              borderRadius: BorderRadius.circular(24),
              child: TextField(
                controller: _messageController,
                onSubmitted: (_) => _sendMessage(),
                style: const TextStyle(fontSize: 14, color: NMTheme.textDark),
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: NMTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: NMTheme.primaryPurple.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _sendMessage,
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
