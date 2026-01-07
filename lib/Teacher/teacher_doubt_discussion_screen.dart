import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

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
  String? _recordingPath;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  // Real-time polling
  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
    _fetchChat();
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
        'senderName': 'Prof. Rahul Tiwari',
        'senderInitials': 'RT',
        'text': 'I understand your doubt. Let me explain this step by step.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'isTeacher': true,
        'type': 'text',
      },
    ];
  }

  Future<void> _fetchChat() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) {
      if (mounted && !_isLoading && !_isSending && !_isUploading) {
        _refreshChat();
      }
    });
  }

  Future<void> _refreshChat() async {
    // Silent refresh
    await Future.delayed(const Duration(milliseconds: 500));
    print('🔄 Chat refreshed');
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isSending) return;

    final messageText = text.trim();
    _textController.clear();

    await _sendMessage(text: messageText);
  }

  Future<void> _sendMessage({
    String? text,
    File? imageFile,
    String? voicePath,
    int? voiceDuration,
  }) async {
    if (_isSending) return;

    setState(() => _isSending = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final newMessage = {
      'id': _messages.length + 1,
      'senderId': 'teacher_456',
      'senderName': 'Prof. Rahul Tiwari',
      'senderInitials': 'RT',
      'text': text,
      'imageFile': imageFile,
      'voicePath': voicePath,
      'voiceDuration': voiceDuration,
      'timestamp': DateTime.now(),
      'isTeacher': true,
      'type': imageFile != null
          ? 'image'
          : voicePath != null
              ? 'voice'
              : 'text',
    };

    setState(() {
      _messages.add(newMessage);
      _isSending = false;
    });

    _scrollToBottom();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _handleImagePicker(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      if (mounted) {
        _showImagePreviewConfirmation(File(pickedFile.path));
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePreviewConfirmation(File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF075E54),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Preview Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(imageFile, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _uploadAndSendImage(imageFile);
                      },
                      icon: const Icon(Icons.send, size: 18),
                      label: const Text('Send'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAndSendImage(File imageFile) async {
    setState(() => _isUploading = true);

    // Simulate upload
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isUploading = false);

    await _sendMessage(imageFile: imageFile);
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF075E54)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _handleImagePicker(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF075E54)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _handleImagePicker(ImageSource.camera);
              },
            ),
          ],
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
          _recordingPath = filePath;
          _recordingDuration = 0;
        });

        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration++;
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text('Recording voice note...'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.black87,
          ),
        );
      }
    } catch (e) {
      print('❌ Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();

      if (path != null && mounted) {
        setState(() => _isRecording = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice note recorded successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );

        await _sendMessage(
          voicePath: path,
          voiceDuration: _recordingDuration,
        );

        setState(() {
          _recordingPath = null;
          _recordingDuration = 0;
        });
      }
    } catch (e) {
      print('❌ Error stopping recording: $e');
      setState(() {
        _isRecording = false;
        _recordingPath = null;
        _recordingDuration = 0;
      });
    }
  }

  Future<void> _playVoiceNote(String path) async {
    try {
      await _audioPlayer.play(DeviceFileSource(path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playing voice note...'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      print('❌ Error playing voice note: $e');
    }
  }

  Future<void> _markAsResolved() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Mark as Resolved'),
        content: const Text(
            'Are you sure you want to mark this doubt as resolved? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
            child: const Text('Mark as Resolved'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doubt marked as resolved!'),
          backgroundColor: Color(0xFF25D366),
        ),
      );

      Get.back(result: true);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF128C7E),
              child: Text(
                widget.doubt['studentInitials'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doubt['studentName'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.doubt['subject'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice call feature coming soon')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'refresh') {
                _fetchChat();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'refresh', child: Text('Refresh')),
            ],
          ),
        ],
        backgroundColor: const Color(0xFF075E54),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildDoubtInfoCard(),
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyWidget()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageItem(_messages[index]);
                          },
                        ),
                ),
                if (_isSending || _isUploading)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFFECE5DD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFF075E54)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isUploading ? 'Uploading image...' : 'Sending...',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                _buildBottomBar(isResolved),
              ],
            ),
    );
  }

  Widget _buildDoubtInfoCard() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCF8C6),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: Color(0xFF075E54), size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Topic: ${widget.doubt['topic']}',
                  style: const TextStyle(
                    color: Color(0xFF075E54),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.doubt['question'],
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the discussion',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final isTeacher = message['isTeacher'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isTeacher ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isTeacher) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF128C7E),
              child: Text(
                message['senderInitials'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          _buildMessageBubble(message, isTeacher),
          if (isTeacher) const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isTeacher) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isTeacher ? const Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isTeacher ? 12 : 2),
          bottomRight: Radius.circular(isTeacher ? 2 : 12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message['type'] == 'image' && message['imageFile'] != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                message['imageFile'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Failed to load image',
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (message['text'] != null) const SizedBox(height: 6),
          ],
          if (message['type'] == 'voice' && message['voicePath'] != null) ...[
            _buildVoicePlayer(
                message['voicePath'], message['voiceDuration'], isTeacher),
            if (message['text'] != null) const SizedBox(height: 6),
          ],
          if (message['text'] != null)
            Text(
              message['text'],
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message['timestamp']),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
              if (isTeacher) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 14,
                  color: Colors.blue[700],
                ),
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
        if (path != null) {
          _playVoiceNote(path);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_filled,
              color: isTeacher ? const Color(0xFF075E54) : Colors.blue[700],
              size: 36,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: List.generate(
                      20,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Container(
                          width: 2,
                          height: (index % 3 + 1) * 6.0,
                          decoration: BoxDecoration(
                            color: isTeacher
                                ? const Color(0xFF075E54)
                                : Colors.blue[700],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  duration != null ? _formatDuration(duration) : '0:00',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isResolved) {
    final bool isDisabled =
        _isSending || _isUploading || _isRecording || isResolved;

    return Container(
      color: const Color(0xFFF0F0F0),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isRecording)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.fiber_manual_record,
                        color: Colors.red[700], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Recording: ${_formatDuration(_recordingDuration)}',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _recordingTimer?.cancel();
                        setState(() {
                          _isRecording = false;
                          _recordingDuration = 0;
                        });
                        _audioRecorder.stop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            if (!isResolved && !_isRecording)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: ElevatedButton.icon(
                  onPressed: _markAsResolved,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark as Resolved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            if (isResolved)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.grey[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'This doubt has been resolved',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          color: Colors.grey[600],
                          onPressed: isDisabled
                              ? null
                              : () {
                                  // Emoji picker placeholder
                                },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: isDisabled ? null : _handleSubmitted,
                            onChanged: (value) => setState(() {}),
                            enabled: !isDisabled,
                            decoration: InputDecoration(
                              hintText: _isRecording
                                  ? "Recording..."
                                  : _isUploading
                                      ? "Uploading..."
                                      : isResolved
                                          ? "Doubt resolved"
                                          : "Type a message",
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          color: Colors.grey[600],
                          onPressed: isDisabled ? null : _showImageOptions,
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          color: Colors.grey[600],
                          onPressed: isDisabled
                              ? null
                              : () => _handleImagePicker(ImageSource.camera),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF075E54),
                  child: IconButton(
                    icon: Icon(
                      _textController.text.trim().isNotEmpty
                          ? Icons.send
                          : (_isRecording ? Icons.stop : Icons.mic),
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: isDisabled && !_isRecording
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
