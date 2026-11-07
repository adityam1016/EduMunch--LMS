import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'create_assignment_template_screen.dart';
import 'teacher_app_drawer.dart';
import '../services/assignment_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class AssignmentsListScreen extends StatefulWidget {
  const AssignmentsListScreen({super.key});

  @override
  State<AssignmentsListScreen> createState() => _AssignmentsListScreenState();
}

class _AssignmentsListScreenState extends State<AssignmentsListScreen> {
  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final live = await AssignmentService.getAssignments();
    if (live.isNotEmpty && mounted) {
      setState(() {
        _assignmentTemplates.clear();
        int idx = 1;
        _assignmentTemplates.addAll(live.map((a) => {
              'id': idx++,
              'title': a.title,
              'subject': a.subject,
              'type': 'Theory',
              'totalMarks': a.totalMarks,
              'description': a.description,
              'createdDate': a.dueDate,
              'assignedTo': ['All Batches'],
            }));
      });
    }
  }

  final List<Map<String, dynamic>> _assignmentTemplates = [
    {
      'id': 1,
      'title': 'Quadratic Equations Practice',
      'subject': 'Mathematics',
      'type': 'Theory',
      'totalMarks': 50,
      'description': 'Solve the given quadratic equations using standard factorization & formula methods.',
      'createdDate': DateTime.now().subtract(const Duration(days: 2)),
      'assignedTo': ['Class 10-A', 'Class 10-B'],
    },
    {
      'id': 2,
      'title': "Newton's Laws MCQ Test",
      'subject': 'Physics',
      'type': 'MCQ',
      'totalMarks': 40,
      'totalQuestions': 20,
      'description': "Multiple choice questions covering Newton's three laws of motion and momentum.",
      'createdDate': DateTime.now().subtract(const Duration(days: 5)),
      'assignedTo': ['Class 11-Science'],
    },
    {
      'id': 3,
      'title': 'Chemical Bonding Assignment',
      'subject': 'Chemistry',
      'type': 'Theory',
      'totalMarks': 30,
      'description': 'Explain ionic and covalent bonding with molecular geometry examples.',
      'createdDate': DateTime.now().subtract(const Duration(days: 7)),
      'assignedTo': [],
    },
  ];

  void _showAssignToBatchDialog(Map<String, dynamic> assignment) {
    final List<String> availableBatches = [
      'Class 10-A',
      'Class 10-B',
      'Class 11-Science',
      'Class 11-Commerce',
      'Class 12-A',
      'Class 12-B',
    ];

    List<String> selectedBatches = List.from(assignment['assignedTo'] ?? []);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: NMTheme.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NMTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: NMTheme.cardShadows,
                    ),
                    child: const Icon(Icons.groups_rounded, color: NMTheme.primaryPurple),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Assign to Batch',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NMInsetContainer(
                      padding: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                              color: NMTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${assignment['subject']} • ${assignment['type']} • ${assignment['totalMarks']} Marks',
                            style: const TextStyle(
                              color: NMTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Target Classes:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...availableBatches.map((batch) {
                      final isSelected = selectedBatches.contains(batch);
                      return CheckboxListTile(
                        title: Text(
                          batch,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: NMTheme.textDark,
                          ),
                        ),
                        value: isSelected,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: NMTheme.primaryPurple,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            if (value == true) {
                              selectedBatches.add(batch);
                            } else {
                              selectedBatches.remove(batch);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: selectedBatches.isEmpty
                      ? null
                      : () {
                          setState(() {
                            assignment['assignedTo'] = selectedBatches;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Assignment assigned to ${selectedBatches.length} batch(es)'),
                              backgroundColor: NMTheme.accentTeal,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NMTheme.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Assign', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAssignment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NMTheme.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Assignment?', style: TextStyle(fontWeight: FontWeight.bold, color: NMTheme.textDark)),
        content: const Text('This action cannot be undone and will unassign from all batches.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _assignmentTemplates.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Assignment deleted'),
                  backgroundColor: const Color(0xFFE53935),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const TeacherAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Assignments',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: _assignmentTemplates.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                      itemCount: _assignmentTemplates.length,
                      itemBuilder: (context, index) {
                        return _buildAssignmentCard(_assignmentTemplates[index], index);
                      },
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
          onPressed: () async {
            final result = await Get.to(() => const CreateAssignmentTemplateScreen());
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                _assignmentTemplates.insert(0, result);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Assignment template created successfully!'),
                  backgroundColor: NMTheme.accentTeal,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          },
          backgroundColor: NMTheme.primaryPurple,
          elevation: 0,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Create Assignment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: NMTheme.surface,
              shape: BoxShape.circle,
              boxShadow: NMTheme.cardShadows,
            ),
            child: const Icon(Icons.assignment_outlined, size: 64, color: NMTheme.primaryPurple),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Assignments Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: NMTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first assignment template to assign to students',
            style: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment, int index) {
    final isTheory = assignment['type'] == 'Theory';
    final assignedCount = (assignment['assignedTo'] as List).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: NMCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => _showAssignToBatchDialog(assignment),
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isTheory
                          ? const Color(0xFFFB8C00).withOpacity(0.12)
                          : NMTheme.primaryPurple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isTheory ? Icons.description_outlined : Icons.quiz_outlined,
                      color: isTheory ? const Color(0xFFFB8C00) : NMTheme.primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: NMTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignment['subject'],
                          style: const TextStyle(
                            color: NMTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: NMTheme.textSecondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFE53935)),
                            SizedBox(width: 10),
                            Text('Delete', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteAssignment(index);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              NMInsetContainer(
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    assignment['description'],
                    style: const TextStyle(
                      color: NMTheme.textSecondary,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildPillTag(
                    icon: isTheory ? Icons.edit_note_rounded : Icons.checklist_rounded,
                    label: assignment['type'],
                    color: isTheory ? const Color(0xFFFB8C00) : NMTheme.primaryPurple,
                  ),
                  const SizedBox(width: 8),
                  _buildPillTag(
                    icon: Icons.grade_outlined,
                    label: '${assignment['totalMarks']} Marks',
                    color: NMTheme.accentTeal,
                  ),
                  if (!isTheory && assignment['totalQuestions'] != null) ...[
                    const SizedBox(width: 8),
                    _buildPillTag(
                      icon: Icons.quiz_outlined,
                      label: '${assignment['totalQuestions']} Qs',
                      color: NMTheme.accentOcean,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: Colors.grey.withOpacity(0.18)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: NMTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM d, yyyy').format(assignment['createdDate']),
                        style: const TextStyle(
                          color: NMTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: assignedCount > 0
                          ? NMTheme.accentTeal.withOpacity(0.12)
                          : const Color(0xFFFB8C00).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          assignedCount > 0 ? Icons.check_circle_rounded : Icons.pending_outlined,
                          size: 13,
                          color: assignedCount > 0 ? NMTheme.accentTeal : const Color(0xFFFB8C00),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          assignedCount > 0 ? 'Assigned ($assignedCount)' : 'Unassigned',
                          style: TextStyle(
                            color: assignedCount > 0 ? NMTheme.accentTeal : const Color(0xFFFB8C00),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillTag({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
