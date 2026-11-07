import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class HRSectionScreen extends StatefulWidget {
  const HRSectionScreen({super.key});

  @override
  State<HRSectionScreen> createState() => _HRSectionScreenState();
}

class _HRSectionScreenState extends State<HRSectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _sickLeavesTaken = 2;
  int _casualLeavesTaken = 3;
  int _unpaidLeavesTaken = 0;
  final int _totalSickLeaves = 10;
  final int _totalCasualLeaves = 10;
  final int _totalUnpaidLeaves = 0;

  List<Map<String, dynamic>> _leaveApplications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _leaveApplications = [
      {
        'id': 1,
        'leaveType': 'SICK',
        'reason': 'Fever and viral infection',
        'startDate': DateTime(2026, 1, 3),
        'endDate': DateTime(2026, 1, 4),
        'status': 'APPROVED',
        'deductedAs': 'SICK',
      },
      {
        'id': 2,
        'leaveType': 'CASUAL',
        'reason': 'Family ceremonial function',
        'startDate': DateTime(2026, 1, 10),
        'endDate': DateTime(2026, 1, 11),
        'status': 'PENDING',
        'deductedAs': '',
      },
      {
        'id': 3,
        'leaveType': 'SICK',
        'reason': 'Routine dental consultation',
        'startDate': DateTime(2025, 12, 28),
        'endDate': DateTime(2025, 12, 29),
        'status': 'REJECTED',
        'deductedAs': 'UNPAID',
      },
    ];
  }

  Future<void> _refreshLeaves() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showApplyLeaveModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplyLeaveModal(
        onApplied: (newLeave) {
          setState(() {
            _leaveApplications.insert(0, newLeave);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: NMTheme.bg,
      drawer: const TeacherAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'HR Portal',
              isRoot: false,
              onLeadingTap: () => Get.back(),
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshLeaves,
                color: NMTheme.primaryPurple,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTeacherProfileCard(),
                      const SizedBox(height: 22),
                      const Text(
                        'Leave Balances',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: NMTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLeaveBalanceRow(),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Application History',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: NMTheme.textDark,
                            ),
                          ),
                          Text(
                            '${_leaveApplications.length} Requests',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: NMTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._leaveApplications.map((app) => _buildLeaveStatusCard(app)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
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
          onPressed: _showApplyLeaveModal,
          label: const Text('Apply for Leave', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          backgroundColor: NMTheme.primaryPurple,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildTeacherProfileCard() {
    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NMTheme.surface,
              boxShadow: NMTheme.cardShadows,
            ),
            child: const Icon(Icons.person_outline_rounded, color: NMTheme.primaryPurple, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prof. Aditya Mishra',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Senior Mathematics Faculty',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: NMTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: NMTheme.accentTeal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'EMP ID: TCH-202401',
                    style: TextStyle(
                      color: NMTheme.accentTeal,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceRow() {
    return Row(
      children: [
        _buildLeaveTile('Sick Leave', _sickLeavesTaken, _totalSickLeaves, const Color(0xFFE53935)),
        const SizedBox(width: 10),
        _buildLeaveTile('Casual Leave', _casualLeavesTaken, _totalCasualLeaves, NMTheme.primaryPurple),
        const SizedBox(width: 10),
        _buildLeaveTile('Unpaid Leave', _unpaidLeavesTaken, _totalUnpaidLeaves, NMTheme.accentOcean),
      ],
    );
  }

  Widget _buildLeaveTile(String title, int taken, int total, Color accentColor) {
    final available = total > 0 ? (total - taken) : 0;

    return Expanded(
      child: NMCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: NMTheme.surface,
                boxShadow: NMTheme.cardShadows,
                border: Border.all(color: accentColor.withOpacity(0.4), width: 2.5),
              ),
              alignment: Alignment.center,
              child: Text(
                total > 0 ? '$available' : '$taken',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: NMTheme.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              total > 0 ? 'of $total left' : 'days taken',
              style: const TextStyle(
                fontSize: 10.5,
                color: NMTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveStatusCard(Map<String, dynamic> app) {
    Color statusColor;
    String status = app['status'];
    if (status == 'APPROVED') {
      statusColor = NMTheme.accentTeal;
    } else if (status == 'REJECTED') {
      statusColor = const Color(0xFFE53935);
    } else {
      statusColor = const Color(0xFFFB8C00);
    }

    String leaveType = app['leaveType'];
    String displayLeaveType = leaveType == 'SICK'
        ? 'Sick Leave'
        : leaveType == 'CASUAL'
            ? 'Casual Leave'
            : 'Unpaid Leave';

    DateTime startDate = app['startDate'];
    DateTime endDate = app['endDate'];
    final formatter = DateFormat('MMM dd, yyyy');
    String dateRange = '${formatter.format(startDate)} – ${formatter.format(endDate)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayLeaveType,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    color: NMTheme.textDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 12, color: NMTheme.textSecondary),
                const SizedBox(width: 5),
                Text(
                  dateRange,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: NMTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            NMInsetContainer(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Reason: ${app['reason']}',
                  style: const TextStyle(color: NMTheme.textDark, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplyLeaveModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplied;
  const ApplyLeaveModal({super.key, required this.onApplied});

  @override
  State<ApplyLeaveModal> createState() => _ApplyLeaveModalState();
}

class _ApplyLeaveModalState extends State<ApplyLeaveModal> {
  String _selectedLeaveType = 'CASUAL';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: NMTheme.primaryPurple,
              onPrimary: Colors.white,
              onSurface: NMTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startController.text = DateFormat('MMM dd, yyyy').format(picked);
          if (_endDate == null || _endDate!.isBefore(picked)) {
            _endDate = picked;
            _endController.text = _startController.text;
          }
        } else {
          _endDate = picked;
          _endController.text = DateFormat('MMM dd, yyyy').format(picked);
        }
      });
    }
  }

  void _submit() {
    if (_startDate == null || _endDate == null || _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Color(0xFFE53935)),
      );
      return;
    }

    final newLeave = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'leaveType': _selectedLeaveType,
      'reason': _reasonController.text.trim(),
      'startDate': _startDate!,
      'endDate': _endDate!,
      'status': 'PENDING',
      'deductedAs': '',
    };

    widget.onApplied(newLeave);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Leave request submitted successfully!'),
        backgroundColor: NMTheme.accentTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NMTheme.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Apply for Leave',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: NMTheme.textDark),
              ),
              NMIconButton(
                icon: Icons.close_rounded,
                size: 32,
                iconSize: 18,
                iconColor: NMTheme.textSecondary,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Leave Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
          const SizedBox(height: 6),
          NMCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            borderRadius: BorderRadius.circular(14),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLeaveType,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
                style: const TextStyle(fontWeight: FontWeight.w700, color: NMTheme.textDark, fontSize: 14),
                items: const [
                  DropdownMenuItem(value: 'CASUAL', child: Text('Casual Leave')),
                  DropdownMenuItem(value: 'SICK', child: Text('Sick Leave')),
                  DropdownMenuItem(value: 'UNPAID', child: Text('Unpaid Leave')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLeaveType = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
                    const SizedBox(height: 6),
                    NMCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        controller: _startController,
                        readOnly: true,
                        onTap: () => _pickDate(true),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: NMTheme.textDark),
                        decoration: const InputDecoration(
                          hintText: 'Select date',
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.calendar_today_rounded, size: 16, color: NMTheme.primaryPurple),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
                    const SizedBox(height: 6),
                    NMCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        controller: _endController,
                        readOnly: true,
                        onTap: () => _pickDate(false),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: NMTheme.textDark),
                        decoration: const InputDecoration(
                          hintText: 'Select date',
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.calendar_today_rounded, size: 16, color: NMTheme.primaryPurple),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Reason', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
          const SizedBox(height: 6),
          NMCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            borderRadius: BorderRadius.circular(14),
            child: TextField(
              controller: _reasonController,
              maxLines: 2,
              style: const TextStyle(fontSize: 13.5, color: NMTheme.textDark),
              decoration: const InputDecoration(
                hintText: 'State reason for leave request...',
                hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                onTap: _submit,
                borderRadius: BorderRadius.circular(16),
                child: const Center(
                  child: Text(
                    'Submit Leave Application',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
