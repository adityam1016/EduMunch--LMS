import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'parent_app_drawer.dart';
import 'parent_notification_screen.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentDashboardMain extends StatefulWidget {
  final String childName;
  final List<Map<String, String>> children;
  final Function(String) onChangeChild;

  const ParentDashboardMain({
    required this.childName,
    required this.children,
    required this.onChangeChild,
    super.key,
  });

  @override
  State<ParentDashboardMain> createState() => _ParentDashboardMainState();
}

class _ParentDashboardMainState extends State<ParentDashboardMain> {
  bool _isProfileExpanded = false;

  Map<String, String> get selectedChild {
    return widget.children.firstWhere(
      (child) => child['name'] == widget.childName,
      orElse: () => widget.children.first,
    );
  }

  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Attendance',
      'icon': Icons.calendar_today_outlined,
      'color': NMTheme.accentOcean,
      'route': '/parent-attendance',
    },
    {
      'title': 'Performance',
      'icon': Icons.trending_up_rounded,
      'color': NMTheme.accentTeal,
      'route': '/parent-performance',
    },
    {
      'title': 'Payments',
      'icon': Icons.account_balance_wallet_outlined,
      'color': NMTheme.primaryPurple,
      'route': '/payments',
    },
    {
      'title': 'Timetable',
      'icon': Icons.schedule_outlined,
      'color': const Color(0xFFFB8C00),
      'route': '/parent-timetable',
    },
    {
      'title': 'PTM Online',
      'icon': Icons.groups_outlined,
      'color': const Color(0xFF43A047),
      'route': '/ptm',
    },
    {
      'title': 'Grievance',
      'icon': Icons.support_agent_outlined,
      'color': const Color(0xFFE53935),
      'route': '/parent-grievance',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final child = selectedChild;

    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const ParentAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'EduMunch',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () => Get.to(() => const ParentNotificationScreen()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    _buildChildSelectorCard(child),
                    const SizedBox(height: 20),
                    _buildFeatureGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildSelectorCard(Map<String, String> child) {
    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NMTheme.surface,
                  boxShadow: NMTheme.cardShadows,
                ),
                child: const Icon(Icons.face_rounded, size: 36, color: NMTheme.primaryPurple),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      child['batch'] ?? '',
                      style: const TextStyle(fontSize: 13, color: NMTheme.textSecondary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${child['studentId']}',
                      style: const TextStyle(fontSize: 12, color: NMTheme.accentTeal, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              NMIconButton(
                icon: _isProfileExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 36,
                iconSize: 22,
                iconColor: NMTheme.textSecondary,
                onTap: () => setState(() => _isProfileExpanded = !_isProfileExpanded),
              ),
            ],
          ),
          if (_isProfileExpanded) ...[
            const SizedBox(height: 14),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Center', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13)),
                Text(child['center'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700, color: NMTheme.textDark, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Branch', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13)),
                Text(child['branch'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700, color: NMTheme.textDark, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Switch Child:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: NMTheme.textDark)),
            ),
            const SizedBox(height: 8),
            Row(
              children: widget.children.map((c) {
                final isSelected = c['name'] == child['name'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => widget.onChangeChild(c['name']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? NMTheme.primaryPurple : NMTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected ? null : NMTheme.cardShadows,
                      ),
                      child: Text(
                        c['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : NMTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final feat = _features[index];
        final Color color = feat['color'];

        return NMCard(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => Get.toNamed(feat['route']),
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(feat['icon'], color: color, size: 22),
                ),
                Text(
                  feat['title'],
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
