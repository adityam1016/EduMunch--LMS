import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

/// Widget to display current session status
/// Useful for debugging and showing user session info
class SessionStatusWidget extends StatelessWidget {
  const SessionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (!authController.isLoggedIn) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green.shade700,
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  authController.role ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                ),
                Text(
                  authController.email ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

/// Button to manually refresh session
class RefreshSessionButton extends StatelessWidget {
  const RefreshSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Refresh Session',
      onPressed: () async {
        await authController.refreshSession();
        Get.snackbar(
          'Session Refreshed',
          'Your session has been extended',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}

/// Dialog to show session details
class SessionDetailsDialog extends StatelessWidget {
  const SessionDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AlertDialog(
      title: const Text('Session Details'),
      content: FutureBuilder<int>(
        future: authController.getSessionDuration(),
        builder: (context, snapshot) {
          final duration = snapshot.data ?? 0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Email', authController.email ?? 'N/A'),
              const SizedBox(height: 8),
              _buildInfoRow('Role', authController.role ?? 'N/A'),
              const SizedBox(height: 8),
              _buildInfoRow('Session Duration', '$duration hours'),
              const SizedBox(height: 8),
              _buildInfoRow('Status', authController.isLoggedIn ? 'Active' : 'Inactive'),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () async {
            await authController.refreshSession();
            Get.back();
            Get.snackbar(
              'Session Refreshed',
              'Your session has been extended',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade100,
              colorText: Colors.green.shade900,
            );
          },
          child: const Text('Refresh Session'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
