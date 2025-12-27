import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  // Variable to track the selected role
  String selectedRole = 'Student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Header Text
                  const Text(
                    "Welcome to",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E), // Dark tech blue
                    ),
                  ),
                  const Text(
                    "EduMunch",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Please select your role to continue.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Role Options
                  Expanded(
                    child: ListView(
                      children: [
                        _buildRoleCard(
                          title: 'Student',
                          icon: Icons.school_outlined,
                          isSelected: selectedRole == 'Student',
                        ),
                        _buildRoleCard(
                          title: 'Parent',
                          icon: Icons.people_outline,
                          isSelected: selectedRole == 'Parent',
                        ),
                        _buildRoleCard(
                          title: 'Teacher',
                          icon: Icons.co_present_outlined,
                          isSelected: selectedRole == 'Teacher',
                        ),
                        _buildRoleCard(
                          title: 'Staff',
                          icon: Icons.badge_outlined,
                          isSelected: selectedRole == 'Staff',
                        ),
                      ],
                    ),
                  ),
                  
                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your navigation logic here
                          print("Selected Role: $selectedRole");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2962FF), // Primary Blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper for Role Cards
  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return _RoleCardWidget(
      title: title,
      icon: icon,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          selectedRole = title;
        });
      },
    );
  }
}

class _RoleCardWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCardWidget({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_RoleCardWidget> createState() => _RoleCardWidgetState();
}

class _RoleCardWidgetState extends State<_RoleCardWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: _isHovering 
                ? const Color(0xFFE3F2FD) // Light blue on hover
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.isSelected ? const Color(0xFF2962FF) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 28,
                color: widget.isSelected ? const Color(0xFF2962FF) : Colors.black45,
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  color: widget.isSelected ? const Color(0xFF2962FF) : Colors.black87,
                ),
              ),
              const Spacer(),
              // Custom Radio Circle
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected ? const Color(0xFF2962FF) : Colors.black26,
                    width: 2,
                  ),
                  color: widget.isSelected ? const Color(0xFF2962FF) : Colors.transparent,
                ),
                child: widget.isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}