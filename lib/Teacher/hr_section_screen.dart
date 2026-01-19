import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';

class HRSectionScreen extends StatefulWidget {
  const HRSectionScreen({super.key});

  @override
  State<HRSectionScreen> createState() => _HRSectionScreenState();
}

class _HRSectionScreenState extends State<HRSectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State
  int _sickLeavesTaken = 0;
  int _casualLeavesTaken = 0;
  int _unpaidLeavesTaken = 0;
  final int _totalSickLeaves = 10;
  final int _totalCasualLeaves = 10;
  final int _totalUnpaidLeaves = 0;

  List<Map<String, dynamic>> _leaveApplications = [];
  bool _isLoading = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Sample leave applications
    _leaveApplications = [
      {
        'id': 1,
        'leaveType': 'SICK',
        'reason': 'Fever and cold',
        'startDate': DateTime(2026, 1, 3),
        'endDate': DateTime(2026, 1, 4),
        'status': 'APPROVED',
        'deductedAs': 'SICK',
      },
      {
        'id': 2,
        'leaveType': 'CASUAL',
        'reason': 'Family function',
        'startDate': DateTime(2026, 1, 10),
        'endDate': DateTime(2026, 1, 11),
        'status': 'PENDING',
        'deductedAs': '',
      },
      {
        'id': 3,
        'leaveType': 'SICK',
        'reason': 'Medical checkup',
        'startDate': DateTime(2025, 12, 28),
        'endDate': DateTime(2025, 12, 29),
        'status': 'REJECTED',
        'deductedAs': 'UNPAID',
      },
    ];
    
    _calculateLeaveBalance();
  }

  void _calculateLeaveBalance() {
    int sickTaken = 0;
    int casualTaken = 0;
    int unpaidTaken = 0;

    for (var leave in _leaveApplications) {
      String status = (leave['status'] as String).toUpperCase();
      String deductedAs = (leave['deductedAs'] as String).toUpperCase();
      String leaveType = (leave['leaveType'] as String).toUpperCase();

      if (status == 'PENDING') {
        switch (leaveType) {
          case 'SICK':
            sickTaken += 1;
            break;
          case 'CASUAL':
            casualTaken += 1;
            break;
          case 'UNPAID':
            unpaidTaken += 1;
            break;
        }
      } else if (status == 'APPROVED') {
        switch (deductedAs) {
          case 'SICK':
            sickTaken += 1;
            break;
          case 'CASUAL':
            casualTaken += 1;
            break;
          case 'UNPAID':
            unpaidTaken += 1;
            break;
          default:
            switch (leaveType) {
              case 'SICK':
                sickTaken += 1;
                break;
              case 'CASUAL':
                casualTaken += 1;
                break;
              case 'UNPAID':
                unpaidTaken += 1;
                break;
            }
        }
      } else if (status == 'REJECTED') {
        if (deductedAs == 'UNPAID') {
          unpaidTaken += 1;
        }
      }
    }
    
    setState(() {
      _sickLeavesTaken = sickTaken;
      _casualLeavesTaken = casualTaken;
      _unpaidLeavesTaken = unpaidTaken;
    });
  }

  Future<void> _refreshLeaves() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    _calculateLeaveBalance();
    setState(() => _isLoading = false);
  }

  void _showApplyLeaveModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ApplyLeaveModal(
            onApplied: (leaveData) {
              setState(() {
                _leaveApplications.add({
                  'id': _leaveApplications.length + 1,
                  'leaveType': leaveData['leaveType'],
                  'reason': leaveData['reason'],
                  'startDate': leaveData['startDate'],
                  'endDate': leaveData['endDate'],
                  'status': 'PENDING',
                  'deductedAs': '',
                });
              });
              _calculateLeaveBalance();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Leave application submitted successfully!'),
                  backgroundColor: Colors.green));
            });
      },
    );
  }

  void _showLeaveDetailsDialog(Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => LeaveDetailsDialog(
        application: application,
        onDelete: () async {
          Navigator.of(context).pop();
          await _deleteLeaveApplication(application['id']);
        },
      ),
    );
  }

  Future<void> _deleteLeaveApplication(int leaveId) async {
    Map<String, dynamic>? leaveToDelete;
    try {
      leaveToDelete =
          _leaveApplications.firstWhere((leave) => leave['id'] == leaveId);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not find leave to delete.'),
            backgroundColor: Colors.orange));
      }
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final leaveEndDate = leaveToDelete['endDate'] as DateTime;
    final leaveEndDateOnly = DateTime(leaveEndDate.year, leaveEndDate.month, leaveEndDate.day);
    final bool isPastLeave = leaveEndDateOnly.isBefore(today);

    final bool isUnpaid = (leaveToDelete['deductedAs'] as String).toUpperCase() == 'UNPAID';
    final bool isPending = leaveToDelete['status'] == 'PENDING';

    final bool canDelete = !isPastLeave && (isPending || isUnpaid);

    if (!canDelete) {
      String reason = isPastLeave
          ? "Cannot delete past leave applications."
          : "Cannot delete this leave. Only PENDING or UNPAID leaves can be deleted.";
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(reason), backgroundColor: Colors.orange));
      }
      return;
    }

    bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                  'Are you sure you want to delete this leave application? This action cannot be undone.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red))),
              ],
            ));
    if (confirm != true) return;

    setState(() => _isDeleting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _leaveApplications.removeWhere((leave) => leave['id'] == leaveId);
      _isDeleting = false;
    });
    
    _calculateLeaveBalance();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Leave application deleted successfully.'),
          backgroundColor: Colors.green));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF0F4F8),
      drawer: const TeacherAppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Get.back(),
        ),
        title: const Text('HR Portal',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: (_isLoading || _isDeleting) ? null : _refreshLeaves,
            tooltip: 'Refresh Leave Data',
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshLeaves,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeacherInfoCard(),
                  const SizedBox(height: 24),
                  const Text('Leave Balance Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildLeaveBalance(),
                  const SizedBox(height: 24),
                  const Text('Leave Application Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildLeaveStatusSection(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                  child: Card(
                      elevation: 4,
                      child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Deleting leave...')
                              ])))),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showApplyLeaveModal,
        label: const Text('Apply for Leave'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildLeaveStatusSection() {
    if (_leaveApplications.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text('No leave applications submitted yet.',
                  style: TextStyle(color: Colors.grey))));
    }
    return _buildLeaveStatusList();
  }

  Widget _buildTeacherInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Prof. Rahul Tiwari',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('ID: 123456', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text('Mathematics Teacher',
                    style: TextStyle(color: const Color(0xFF6D28D9))),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveBalance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: _buildLeaveIndicator(
                'Sick Leave', _sickLeavesTaken, _totalSickLeaves, Colors.red)),
        Flexible(
            child: _buildLeaveIndicator('Casual Leave', _casualLeavesTaken,
                _totalCasualLeaves, const Color(0xFF7C3AED))),
        Flexible(
            child: _buildLeaveIndicator('Unpaid Leave', _unpaidLeavesTaken,
                _totalUnpaidLeaves, const Color(0xFF7C3AED))),
      ],
    );
  }

  Widget _buildLeaveIndicator(String label, int value, int total, Color color) {
    String availableText = total > 0 ? 'Available: ${total - value}' : '';
    String displayText;

    Widget indicatorWidget;

    if (total > 0) {
      displayText = '$value/$total';
      indicatorWidget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3), width: 7),
        ),
        child: Center(
            child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        )),
      );
    } else {
      displayText = '$value';
      indicatorWidget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3), width: 7),
        ),
        child: Center(
            child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        )),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 80, width: 80, child: indicatorWidget),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        if (total > 0)
          Text(availableText,
              style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        if (total <= 0) const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildLeaveStatusList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _leaveApplications.length,
      itemBuilder: (context, index) {
        final application = _leaveApplications[index];
        return _buildLeaveStatusCard(application);
      },
    );
  }

  Widget _buildLeaveStatusCard(Map<String, dynamic> application) {
    Color statusColor;
    String status = application['status'];
    String displayStatus = status == 'REJECTED' ? 'Declined' : status == 'APPROVED' ? 'Approved' : 'Pending';
    
    switch (status) {
      case 'APPROVED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }
    
    String leaveType = application['leaveType'];
    String displayLeaveType = leaveType == 'SICK' ? 'Sick Leave' : leaveType == 'CASUAL' ? 'Casual Leave' : 'Unpaid Leave';
    
    DateTime startDate = application['startDate'];
    DateTime endDate = application['endDate'];
    final formatter = DateFormat('MMM dd, yyyy');
    String dateRange = '${formatter.format(startDate)} - ${formatter.format(endDate)}';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showLeaveDetailsDialog(application),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text(displayLeaveType,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
              '$dateRange\nReason: ${application['reason']}',
              style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(displayStatus,
                style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          isThreeLine: true,
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
  String? _selectedLeaveTypeApiValue;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final now = DateTime.now();
    final initialPickerDate =
        isStartDate ? (_startDate ?? now) : (_endDate ?? _startDate ?? now);
    final firstAllowedDate = isStartDate
        ? DateTime(now.year, now.month, now.day)
        : _startDate ?? DateTime(now.year, now.month, now.day);
    final lastAllowedDate = DateTime(now.year + 1, now.month, now.day);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialPickerDate.isBefore(firstAllowedDate)
            ? firstAllowedDate
            : initialPickerDate,
        firstDate: firstAllowedDate,
        lastDate: lastAllowedDate);
    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('MMM dd, yyyy').format(picked);
        if (isStartDate) {
          _startDate = picked;
          _startController.text = formattedDate;
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = null;
            _endController.text = '';
          } else if (_endDate == null) {
            _endDate = _startDate;
            _endController.text = formattedDate;
          }
        } else {
          if (_startDate != null && picked.isBefore(_startDate!)) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('End date cannot be before start date.'),
                  backgroundColor: Colors.orange));
            }
            return;
          }
          _endDate = picked;
          _endController.text = formattedDate;
        }
      });
    }
  }

  Future<void> _submitLeaveApplication() async {
    if (_selectedLeaveTypeApiValue == null ||
        _startDate == null ||
        _endDate == null ||
        _reasonController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please fill all fields.');
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      setState(() => _errorMessage = 'End date cannot be before start date.');
      return;
    }
    
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      widget.onApplied({
        'leaveType': _selectedLeaveTypeApiValue!,
        'reason': _reasonController.text.trim(),
        'startDate': _startDate!,
        'endDate': _endDate!,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
            color: Color(0xFFF0F4F8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Apply for Leave',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isSubmitting ? null : () => Navigator.pop(context))
              ]),
              const SizedBox(height: 20),
              _buildDropdown('Leave Type', 'Select Leave Type', {
                'Sick Leave': 'SICK',
                'Casual Leave': 'CASUAL',
                'Unpaid Leave': 'UNPAID'
              }),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: _buildDatePicker('From', _startController,
                        () => _selectDate(context, true))),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildDatePicker('To', _endController,
                        () => _selectDate(context, false))),
              ]),
              const SizedBox(height: 16),
              _buildReasonField(),
              if (_errorMessage != null)
                Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center)),
              const SizedBox(height: 24),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitLeaveApplication,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        disabledBackgroundColor: Colors.grey.shade400),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Apply Leave',
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                  )),
            ])),
      ),
    );
  }

  Widget _buildDropdown(String label, String hint, Map<String, String> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1))
            ]),
        child: DropdownButtonFormField<String>(
          value: _selectedLeaveTypeApiValue,
          hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
          items: items.entries
              .map((entry) => DropdownMenuItem<String>(
                  value: entry.value, child: Text(entry.key)))
              .toList(),
          onChanged: (newValue) =>
              setState(() => _selectedLeaveTypeApiValue = newValue),
          decoration: const InputDecoration(border: InputBorder.none),
          isExpanded: true,
        ),
      ),
    ]);
  }

  Widget _buildDatePicker(
      String label, TextEditingController controller, VoidCallback onTap) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
              hintText: 'Select Date',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: const Color(0xFF7C3AED))),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 12))),
    ]);
  }

  Widget _buildReasonField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Reason', style: TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      TextField(
          controller: _reasonController,
          maxLines: 4,
          decoration: InputDecoration(
              hintText: 'Please provide a reason for your leave',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: const Color(0xFF7C3AED))),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 12))),
    ]);
  }
}

class LeaveDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> application;
  final VoidCallback onDelete;

  const LeaveDetailsDialog(
      {super.key, required this.application, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    String status = application['status'];
    Color statusColor;
    String displayStatus = status == 'REJECTED' ? 'Declined' : status == 'APPROVED' ? 'Approved' : 'Pending';
    
    switch (status) {
      case 'APPROVED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final leaveEndDate = application['endDate'] as DateTime;
    final leaveEndDateOnly = DateTime(leaveEndDate.year, leaveEndDate.month, leaveEndDate.day);
    final bool isPastLeave = leaveEndDateOnly.isBefore(today);

    final bool isUnpaid = (application['deductedAs'] as String).toUpperCase() == 'UNPAID';
    final bool isPending = status == 'PENDING';

    final bool canDelete = !isPastLeave && (isPending || isUnpaid);

    String deductedAsText;
    if (status.toUpperCase() == 'PENDING') {
      deductedAsText = (application['leaveType'] as String).toUpperCase();
    } else {
      deductedAsText = (application['deductedAs'] as String).isNotEmpty 
          ? application['deductedAs'] as String 
          : 'N/A';
    }
    
    String leaveType = application['leaveType'];
    String displayLeaveType = leaveType == 'SICK' ? 'Sick Leave' : leaveType == 'CASUAL' ? 'Casual Leave' : 'Unpaid Leave';
    
    DateTime startDate = application['startDate'];
    DateTime endDate = application['endDate'];
    final formatter = DateFormat('MMM dd, yyyy');
    String dateRange = '${formatter.format(startDate)} - ${formatter.format(endDate)}';
    
    int duration = endDate.difference(startDate).inDays + 1;

    return AlertDialog(
      title: Text(displayLeaveType),
      content: SingleChildScrollView(
        child: ListBody(children: <Widget>[
          _buildDetailRow('Status:', displayStatus, statusColor),
          const SizedBox(height: 10),
          _buildDetailRow('Dates:', dateRange),
          const SizedBox(height: 10),
          _buildDetailRow('Reason:', application['reason']),
          const SizedBox(height: 10),
          _buildDetailRow('Deducted As:', deductedAsText),
          const SizedBox(height: 10),
          _buildDetailRow('Duration:', '$duration day(s)'),
        ]),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop()),
        if (canDelete)
          TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: onDelete),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
      const SizedBox(width: 8),
      Expanded(
          child: Text(value,
              style: TextStyle(color: valueColor ?? Colors.black87))),
    ]);
  }
}
