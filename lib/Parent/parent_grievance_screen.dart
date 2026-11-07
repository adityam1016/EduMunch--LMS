import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'parent_grievance_chat_screen.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentGrievanceScreen extends StatefulWidget {
  const ParentGrievanceScreen({super.key});

  @override
  State<ParentGrievanceScreen> createState() => _ParentGrievanceScreenState();
}

class _ParentGrievanceScreenState extends State<ParentGrievanceScreen> {
  bool _showRaiseForm = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Academic';
  final List<String> _categories = [
    'Academic',
    'Transport',
    'Facilities',
    'Bullying',
    'Health & Safety',
    'Administrative',
    'Other',
  ];

  bool _isSubmitting = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> grievances = [
    {
      'id': '1',
      'title': 'Faculty Feedback - Maths Doubt Support',
      'description': 'Student needs extra assistance in quadratic equations and calculus basics.',
      'status': 'Pending',
      'date': '2026-01-05',
      'category': 'Academic',
      'lastMessage': 'Head of Department is reviewing your request.',
      'unreadCount': 2,
    },
    {
      'id': '2',
      'title': 'Bus Route #4 Timing Delay',
      'description': 'Evening drop-off bus consistently arrives 25 minutes late.',
      'status': 'In Progress',
      'date': '2026-01-03',
      'category': 'Transport',
      'lastMessage': 'Route supervisor has been dispatched to coordinate.',
      'unreadCount': 0,
    },
    {
      'id': '3',
      'title': 'Canteen Meal Hygiene',
      'description': 'Request to enhance water filter sterilization in canteen area.',
      'status': 'Resolved',
      'date': '2025-12-28',
      'category': 'Facilities',
      'lastMessage': 'New UV filtration unit installed and inspected.',
      'unreadCount': 0,
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'In Progress', 'Resolved'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (_) {}
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: NMTheme.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: NMTheme.primaryPurple),
                  title: const Text('Take a Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: NMTheme.primaryPurple),
                  title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitGrievance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      grievances.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': 'Pending',
        'date': 'Today',
        'category': _selectedCategory,
        'lastMessage': 'Ticket submitted. Review in progress.',
        'unreadCount': 0,
      });
      _isSubmitting = false;
      _showRaiseForm = false;
    });

    _titleController.clear();
    _descriptionController.clear();
    _selectedImage = null;

    Get.snackbar(
      'Grievance Raised',
      'Your ticket has been logged and assigned to admin support',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NMTheme.accentTeal,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      borderRadius: 14,
    );
  }

  List<Map<String, dynamic>> get _filteredGrievances {
    if (_selectedFilter == 'All') return grievances;
    return grievances.where((g) => g['status'] == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFFB8C00);
      case 'In Progress':
        return NMTheme.primaryPurple;
      case 'Resolved':
        return NMTheme.accentTeal;
      default:
        return NMTheme.textSecondary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school_outlined;
      case 'Transport':
        return Icons.directions_bus_outlined;
      case 'Facilities':
        return Icons.business_outlined;
      default:
        return Icons.report_problem_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Grievance',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            _buildFilterTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                child: Column(
                  children: [
                    if (_showRaiseForm) ...[
                      _buildRaiseGrievanceForm(),
                      const SizedBox(height: 20),
                    ],
                    ..._filteredGrievances.map((g) => _buildGrievanceCard(g)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_showRaiseForm
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: NMTheme.primaryPurple.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => setState(() => _showRaiseForm = true),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text('Raise Grievance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: NMTheme.primaryPurple,
                elevation: 0,
              ),
            )
          : null,
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? NMTheme.primaryPurple : NMTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: NMTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : NMTheme.textDark,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRaiseGrievanceForm() {
    return NMCard(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Grievance Ticket',
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: NMTheme.textDark),
                ),
                NMIconButton(
                  icon: Icons.close_rounded,
                  size: 32,
                  iconSize: 18,
                  iconColor: NMTheme.textSecondary,
                  onTap: () => setState(() => _showRaiseForm = false),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
            const SizedBox(height: 6),
            NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              borderRadius: BorderRadius.circular(14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
                  style: const TextStyle(fontWeight: FontWeight.w700, color: NMTheme.textDark, fontSize: 13.5),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Subject', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
            const SizedBox(height: 6),
            NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              borderRadius: BorderRadius.circular(14),
              child: TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 13.5, color: NMTheme.textDark, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Brief title of the issue...',
                  hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                  border: InputBorder.none,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 12),
            const Text('Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
            const SizedBox(height: 6),
            NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              borderRadius: BorderRadius.circular(14),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13.5, color: NMTheme.textDark),
                decoration: const InputDecoration(
                  hintText: 'Explain the issue in detail...',
                  hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                  border: InputBorder.none,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.attach_file_rounded, size: 18),
                    label: Text(_selectedImage == null ? 'Attach Photo' : 'Photo Attached'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: NMTheme.primaryPurple,
                      side: BorderSide(color: NMTheme.primaryPurple.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: NMTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: NMTheme.primaryPurple.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isSubmitting ? null : _submitGrievance,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: _isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            'Submit Ticket',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrievanceCard(Map<String, dynamic> g) {
    final statusColor = _getStatusColor(g['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Get.to(() => ParentGrievanceChatScreen(
                  grievanceId: g['id'],
                  grievanceTitle: g['title'],
                  grievanceStatus: g['status'],
                ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: NMTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_getCategoryIcon(g['category']), color: NMTheme.primaryPurple, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: NMTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${g['category']} • ${g['date']}',
                          style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      g['status'],
                      style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              NMInsetContainer(
                padding: const EdgeInsets.all(10),
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    g['description'],
                    style: const TextStyle(color: NMTheme.textDark, fontSize: 12.5, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: NMTheme.primaryPurple),
                      const SizedBox(width: 5),
                      Text(
                        g['lastMessage'] ?? 'Open discussion',
                        style: const TextStyle(color: NMTheme.primaryPurple, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: NMTheme.primaryPurple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
