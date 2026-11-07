import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class TeacherDoubtDiscussionScreen extends StatefulWidget {
  final Map<String, dynamic> doubt;

  const TeacherDoubtDiscussionScreen({
    super.key,
    required this.doubt,
  });

  @override
  State<TeacherDoubtDiscussionScreen> createState() =>
      _TeacherDoubtDiscussionScreenState();
}

class _TeacherDoubtDiscussionScreenState
    extends State<TeacherDoubtDiscussionScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  bool _isUploading = false;
  bool _isRecording = false;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _recordingTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeSampleData() {
    _messages = [
      {
        'id': 1,
        'senderId': 'student_123',
        'senderName': widget.doubt['studentName'],
        'senderInitials': widget.doubt['studentInitials'],
        'text': widget.doubt['question'],
        'timestamp': widget.doubt['timestamp'],
        'isTeacher': false,
        'type': 'text',
      },
      {
        'id': 2,
        'senderId': 'teacher_456',
        'senderName': 'Prof. Aditya Mishra',
        'senderInitials': 'AM',
        'text': 'I understand your query. Let us solve this step by step using the discriminant formula.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'isTeacher': true,
        'type': 'text',
      },
    ];
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) {
      if (mounted && !_isLoading && !_isSending && !_isUploading) {
        // silent refresh
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isSending) return;

    final messageText = text.trim();
    _textController.clear();
    setState(() => _isSending = true);

    await Future.delayed(const Duration(milliseconds: 300));

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'senderId': 'teacher_me',
      'senderName': 'Prof. Aditya Mishra',
      'senderInitials': 'AM',
      'text': messageText,
      'timestamp': DateTime.now(),
      'isTeacher': true,
      'type': 'text',
    };

    if (mounted) {
      setState(() {
        _messages.add(newMessage);
        _isSending = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
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

  Future<void> _handleImagePicker(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        _uploadAndSendImage(imageFile);
      }
    } catch (_) {}
  }

  Future<void> _uploadAndSendImage(File imageFile) async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'senderId': 'teacher_me',
          'senderName': 'Prof. Aditya Mishra',
          'senderInitials': 'AM',
          'imageFile': imageFile,
          'timestamp': DateTime.now(),
          'isTeacher': true,
          'type': 'image',
        });
        _isUploading = false;
      });
      _scrollToBottom();
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: NMTheme.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: NMTheme.primaryPurple),
                title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePicker(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: NMTheme.primaryPurple),
                title: const Text('Take a Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePicker(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String filePath =
            '${appDocDir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _recordingDuration = 0;
        });

        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration++;
          });
        });
      }
    } catch (_) {}
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'senderId': 'teacher_me',
          'senderName': 'Prof. Aditya Mishra',
          'senderInitials': 'AM',
          'voicePath': path,
          'voiceDuration': _recordingDuration,
          'timestamp': DateTime.now(),
          'isTeacher': true,
          'type': 'voice',
        });
      });
      _scrollToBottom();
    }
  }

  Future<void> _playVoiceNote(String path) async {
    try {
      await _audioPlayer.play(DeviceFileSource(path));
    } catch (_) {}
  }

  void _markAsResolved() {
    setState(() {
      widget.doubt['status'] = 'Resolved';
      widget.doubt['isResolved'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Doubt marked as resolved!'),
        backgroundColor: NMTheme.accentTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isResolved = widget.doubt['isResolved'] ?? false;

    return Scaffold(
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: widget.doubt['studentName'],
              isRoot: false,
              onLeadingTap: () => Get.back(),
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            _buildDoubtHeaderCard(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),
            if (_isSending || _isUploading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: NMTheme.primaryPurple)),
                    SizedBox(width: 8),
                    Text('Sending response...', style: TextStyle(color: NMTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            _buildBottomBar(isResolved),
          ],
        ),
      ),
    );
  }

  Widget _buildDoubtHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: NMCard(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NMTheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: NMTheme.cardShadows,
              ),
              child: const Icon(Icons.help_outline_rounded, color: NMTheme.primaryPurple, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.doubt['subject']} • ${widget.doubt['topic']}',
                        style: const TextStyle(
                          color: NMTheme.primaryPurple,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (widget.doubt['status'] == 'Resolved' ? NMTheme.accentTeal : const Color(0xFFFB8C00)).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.doubt['status'],
                          style: TextStyle(
                            color: widget.doubt['status'] == 'Resolved' ? NMTheme.accentTeal : const Color(0xFFFB8C00),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.doubt['question'],
                    style: const TextStyle(color: NMTheme.textDark, fontSize: 12, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final isTeacher = message['isTeacher'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isTeacher ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isTeacher) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: NMTheme.surface,
                shape: BoxShape.circle,
                boxShadow: NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: Text(
                message['senderInitials'] ?? 'ST',
                style: const TextStyle(color: NMTheme.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          _buildMessageBubble(message, isTeacher),
          if (isTeacher) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isTeacher) {
    final width = MediaQuery.of(context).size.width * 0.72;

    return Container(
      constraints: BoxConstraints(maxWidth: width),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTeacher ? null : NMTheme.cardBg,
        gradient: isTeacher ? NMTheme.primaryGradient : null,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isTeacher ? 16 : 4),
          bottomRight: Radius.circular(isTeacher ? 4 : 16),
        ),
        boxShadow: isTeacher
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
          if (message['type'] == 'image' && message['imageFile'] != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(message['imageFile'], fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
          ],
          if (message['type'] == 'voice' && message['voicePath'] != null) ...[
            _buildVoicePlayer(message['voicePath'], message['voiceDuration'], isTeacher),
            const SizedBox(height: 6),
          ],
          if (message['text'] != null)
            Text(
              message['text'],
              style: TextStyle(
                color: isTeacher ? Colors.white : NMTheme.textDark,
                fontSize: 13.5,
                height: 1.35,
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message['timestamp']),
                style: TextStyle(
                  color: isTeacher ? Colors.white70 : NMTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
              if (isTeacher) ...[
                const SizedBox(width: 4),
                const Icon(Icons.done_all_rounded, size: 14, color: Colors.white70),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoicePlayer(String? path, int? duration, bool isTeacher) {
    return GestureDetector(
      onTap: () {
        if (path != null) _playVoiceNote(path);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_circle_filled_rounded,
            color: isTeacher ? Colors.white : NMTheme.primaryPurple,
            size: 32,
          ),
          const SizedBox(width: 8),
          Text(
            duration != null ? _formatDuration(duration) : '0:00',
            style: TextStyle(
              fontSize: 12,
              color: isTeacher ? Colors.white : NMTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isResolved) {
    final bool isDisabled = _isSending || _isUploading || _isRecording || isResolved;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isResolved && !_isRecording)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: _markAsResolved,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: NMTheme.accentTeal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: NMTheme.accentTeal.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_rounded, color: NMTheme.accentTeal, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Mark Doubt as Resolved',
                        style: TextStyle(
                          color: NMTheme.accentTeal,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: NMCard(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  borderRadius: BorderRadius.circular(24),
                  child: Row(
                    children: [
                      NMIconButton(
                        icon: Icons.attach_file_rounded,
                        size: 32,
                        iconSize: 18,
                        iconColor: NMTheme.textSecondary,
                        onTap: isDisabled ? () {} : _showImageOptions,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          onSubmitted: isDisabled ? null : _handleSubmitted,
                          onChanged: (value) => setState(() {}),
                          enabled: !isDisabled,
                          style: const TextStyle(fontSize: 14, color: NMTheme.textDark),
                          decoration: InputDecoration(
                            hintText: isResolved ? 'Doubt resolved' : 'Write reply...',
                            hintStyle: const TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      NMIconButton(
                        icon: Icons.camera_alt_outlined,
                        size: 32,
                        iconSize: 18,
                        iconColor: NMTheme.textSecondary,
                        onTap: isDisabled ? () {} : () => _handleImagePicker(ImageSource.camera),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                    onTap: isDisabled && !_isRecording
                        ? null
                        : () {
                            if (_textController.text.trim().isNotEmpty) {
                              _handleSubmitted(_textController.text);
                            } else if (_isRecording) {
                              _stopRecording();
                            } else {
                              _startRecording();
                            }
                          },
                    child: Icon(
                      _textController.text.trim().isNotEmpty
                          ? Icons.send_rounded
                          : (_isRecording ? Icons.stop_rounded : Icons.mic_rounded),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
