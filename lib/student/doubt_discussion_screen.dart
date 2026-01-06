import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  bool showAttachmentOptions = false;
  List<Map<String, String>> selectedImages = [];
  bool isRecordingVoice = false;

  @override
  void initState() {
    super.initState();
    messages = List<Map<String, dynamic>>.from(widget.doubt['messages'] ?? []);
  }

  @override
  void dispose() {
    messageController.dispose();
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

  void _startVoiceRecording() {
    setState(() {
      isRecordingVoice = !isRecordingVoice;
    });

    if (isRecordingVoice) {
      // Simulate 3 second voice recording
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && isRecordingVoice) {
          setState(() {
            messages.add({
              'sender': 'You',
              'text': 'Voice Message',
              'time': 'Just now',
              'isStudent': true,
              'type': 'voice',
              'duration': '0:15',
            });
            isRecordingVoice = false;
            showAttachmentOptions = false;
          });

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF42A5F5)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discussion',
                style: TextStyle(
                  color: Color(0xFF42A5F5),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.doubt['faculty'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: Column(
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
                                color: isStudent ? const Color(0xFF42A5F5) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
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
                                style: TextStyle(
                                  color: isStudent ? Colors.white : Colors.black87,
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isStudent ? const Color(0xFF42A5F5) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
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
                                    Icons.play_arrow,
                                    color: isStudent ? Colors.white : Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
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
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
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
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
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
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.purple,
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
                            color: showAttachmentOptions
                                ? const Color(0xFF42A5F5).withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            showAttachmentOptions ? Icons.close : Icons.add,
                            color: showAttachmentOptions
                                ? const Color(0xFF42A5F5)
                                : Colors.grey[600],
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
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(color: Color(0xFF42A5F5)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Send Button
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF42A5F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
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
    );
  }
}
