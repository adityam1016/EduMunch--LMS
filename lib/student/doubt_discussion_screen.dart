import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'app_drawer.dart';

class DoubtDiscussionScreen extends StatefulWidget {
  final Map<String, dynamic> doubt;

  const DoubtDiscussionScreen({
    Key? key,
    required this.doubt,
  }) : super(key: key);

  @override
  State<DoubtDiscussionScreen> createState() => _DoubtDiscussionScreenState();
}

class _DoubtDiscussionScreenState extends State<DoubtDiscussionScreen> {
  late List<Map<String, dynamic>> messages;
  TextEditingController messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool showAttachmentOptions = false;
  List<Map<String, String>> selectedImages = [];
  bool isRecordingVoice = false;
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  String? _currentlyPlayingAudio;
  bool _isPlaying = false;


  @override
  void initState() {
    super.initState();
    messages = List<Map<String, dynamic>>.from(widget.doubt['messages'] ?? []);
  }

  @override
  void dispose() {
    messageController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          selectedImages.add({
            'name': image.name,
            'path': image.path,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured'),
            duration: Duration(milliseconds: 800),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          selectedImages.add({
            'name': image.name,
            'path': image.path,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected'),
            duration: Duration(milliseconds: 800),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _sendMessage() {
    if (messageController.text.isEmpty && selectedImages.isEmpty) {
      return;
    }

    setState(() {
      // Add text message if not empty
      if (messageController.text.isNotEmpty) {
        messages.add({
          'sender': 'You',
          'text': messageController.text,
          'time': 'Just now',
          'isStudent': true,
          'type': 'text',
        });
      }

      // Add image messages
      for (var image in selectedImages) {
        messages.add({
          'sender': 'You',
          'text': 'Image',
          'time': 'Just now',
          'isStudent': true,
          'type': 'image',
          'imagePath': image['path'],
        });
      }

      messageController.clear();
      selectedImages.clear();
      showAttachmentOptions = false;
    });

    // Simulate faculty reply after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          messages.add({
            'sender': widget.doubt['faculty'],
            'text': 'Thanks for sharing! Let me review and get back to you.',
            'time': 'Just now',
            'isStudent': false,
            'type': 'text',
          });
        });
      }
    });
  }

  void _startVoiceRecording() async {
    if (isRecordingVoice) {
      // Stop recording
      await _stopRecording();
    } else {
      // Start recording
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        
        setState(() {
          isRecordingVoice = true;
          _recordingDuration = 0;
        });

        // Start timer
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordingDuration++;
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission required'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      
      if (path != null) {
        setState(() {
          messages.add({
            'sender': 'You',
            'text': 'Voice Message',
            'time': 'Just now',
            'isStudent': true,
            'type': 'voice',
            'duration': _formatDuration(_recordingDuration),
            'voicePath': path,
          });
          isRecordingVoice = false;
          _recordingDuration = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice message sent'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        // Simulate faculty reply
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              messages.add({
                'sender': widget.doubt['faculty'],
                'text': 'I received your voice message!',
                'time': 'Just now',
                'isStudent': false,
                'type': 'text',
              });
            });
          }
        });
      }
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() {
        isRecordingVoice = false;
        _recordingDuration = 0;
      });
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _playVoiceMessage(String path) async {
    try {
      if (_isPlaying && _currentlyPlayingAudio == path) {
        // Stop if already playing this audio
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentlyPlayingAudio = null;
        });
      } else {
        // Stop any currently playing audio
        await _audioPlayer.stop();
        
        // Play the selected audio
        await _audioPlayer.play(DeviceFileSource(path));
        setState(() {
          _isPlaying = true;
          _currentlyPlayingAudio = path;
        });

        // Listen for completion
        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _currentlyPlayingAudio = null;
            });
          }
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to play audio: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cancelRecording() async {
    await _audioRecorder.stop();
    _recordingTimer?.cancel();
    setState(() {
      isRecordingVoice = false;
      _recordingDuration = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF075E54),
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          leadingWidth: 56,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 18,
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doubt['faculty'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.doubt['subject'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'clear') {
                  setState(() {
                    messages.clear();
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'clear', child: Text('Clear Chat')),
              ],
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFECE5DD),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isStudent = message['isStudent'] as bool;
                  final messageType = message['type'] as String? ?? 'text';

                  return Align(
                    alignment: isStudent ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: isStudent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          // Message Content
                          if (messageType == 'text')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isStudent ? const Color(0xFFDCF8C6) : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: isStudent ? const Radius.circular(12) : const Radius.circular(0),
                                  bottomRight: isStudent ? const Radius.circular(0) : const Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              child: Text(
                                message['text'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          else if (messageType == 'image')
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(message['imagePath']),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          else if (messageType == 'voice')
                            GestureDetector(
                              onTap: () {
                                if (message['voicePath'] != null) {
                                  _playVoiceMessage(message['voicePath']);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isStudent ? const Color(0xFFDCF8C6) : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: isStudent ? const Radius.circular(12) : const Radius.circular(0),
                                    bottomRight: isStudent ? const Radius.circular(0) : const Radius.circular(12),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      (_isPlaying && _currentlyPlayingAudio == message['voicePath'])
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: isStudent ? Colors.white : const Color(0xFF7C3AED),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.mic,
                                      color: isStudent ? Colors.white70 : Colors.grey[600],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      message['duration'] ?? '0:15',
                                      style: TextStyle(
                                        color: isStudent ? Colors.white : Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Time
                          const SizedBox(height: 4),
                          Text(
                            message['time'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Selected Images Preview
            if (selectedImages.isNotEmpty)
              Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[400],
                                size: 30,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            // Input Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                children: [
                  // Attachment Options (Show/Hide)
                  if (showAttachmentOptions)
                    Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Camera Button
                          GestureDetector(
                            onTap: _pickFromCamera,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: const Color(0xFF7C3AED),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Camera',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Gallery Button
                          GestureDetector(
                            onTap: _pickFromGallery,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    color: const Color(0xFF7C3AED),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Voice Message Button
                          GestureDetector(
                            onTap: _startVoiceRecording,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isRecordingVoice
                                        ? Colors.red.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    isRecordingVoice ? Icons.stop_circle : Icons.mic,
                                    color: isRecordingVoice ? Colors.red : Colors.orange,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isRecordingVoice ? 'Recording' : 'Voice',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isRecordingVoice ? Colors.red : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Message Input Row
                  Row(
                    children: [
                      // Attachment Toggle Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAttachmentOptions = !showAttachmentOptions;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            showAttachmentOptions ? Icons.close : Icons.attach_file,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Message Input Field
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          minLines: 1,
                          enabled: !isRecordingVoice,
                          decoration: InputDecoration(
                            hintText: isRecordingVoice 
                                ? 'Recording... ${_formatDuration(_recordingDuration)}' 
                                : 'Type a message...',
                            hintStyle: TextStyle(
                              color: isRecordingVoice ? Colors.red : Colors.grey[400],
                              fontWeight: isRecordingVoice ? FontWeight.w600 : FontWeight.normal,
                            ),
                            filled: true,
                            fillColor: Colors.white,
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
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Microphone Button (when not recording and text is empty)
                      if (!isRecordingVoice && messageController.text.isEmpty)
                        GestureDetector(
                          onTap: _startVoiceRecording,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 2),
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                        ),

                      // Cancel Recording Button
                      if (isRecordingVoice)
                        GestureDetector(
                          onTap: _cancelRecording,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.black87,
                              size: 20,
                            ),
                          ),
                        ),

                      if (isRecordingVoice)
                        const SizedBox(width: 8),

                      // Send/Stop Button
                      GestureDetector(
                        onTap: isRecordingVoice ? _stopRecording : _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isRecordingVoice ? Colors.red : const Color(0xFF075E54),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRecordingVoice ? Icons.stop : Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
