import 'package:flutter/material.dart';
import 'parent_app_drawer.dart';
import 'parent_dashboard_main.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentDashboardSelection extends StatefulWidget {
  const ParentDashboardSelection({super.key});

  @override
  State<ParentDashboardSelection> createState() => _ParentDashboardSelectionState();
}

class _ParentDashboardSelectionState extends State<ParentDashboardSelection> {
  final List<Map<String, String>> children = [
    {
      'name': 'Aditya Mishra',
      'studentId': '202400123',
      'batch': '11th JEE MAINS',
      'center': 'Kota Main Center',
      'branch': 'Science Stream (PCM)',
    },
    {
      'name': 'Vikas Sharma',
      'studentId': '202400124',
      'batch': '10th BOARDS',
      'center': 'Kota Main Center',
      'branch': 'High School',
    },
  ];

  String? selectedChildName;

  @override
  Widget build(BuildContext context) {
    if (selectedChildName != null) {
      return ParentDashboardMain(
        childName: selectedChildName!,
        children: children,
        onChangeChild: (childName) {
          setState(() {
            selectedChildName = childName;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const ParentAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Select Child',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select Your Child',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: NMTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose a profile to monitor their academic progress',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: NMTheme.textSecondary, fontSize: 13.5),
                      ),
                      const SizedBox(height: 30),
                      ...children.map((child) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: NMCard(
                            padding: const EdgeInsets.all(18),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () => setState(() => selectedChildName = child['name']),
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: NMTheme.surface,
                                      boxShadow: NMTheme.cardShadows,
                                    ),
                                    child: const Icon(Icons.face_rounded, color: NMTheme.primaryPurple, size: 30),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child['name']!,
                                          style: const TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w800,
                                            color: NMTheme.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${child['batch']} • ID: ${child['studentId']}',
                                          style: const TextStyle(fontSize: 12.5, color: NMTheme.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: NMTheme.primaryPurple),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
