import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentPaymentScreen extends StatefulWidget {
  const ParentPaymentScreen({super.key});

  @override
  State<ParentPaymentScreen> createState() => _ParentPaymentScreenState();
}

class _ParentPaymentScreenState extends State<ParentPaymentScreen> {
  bool isDownloading = false;

  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Installment 1 (Down Payment)',
      'date': '15 Jan 2024',
      'mode': 'UPI / NetBanking',
      'amount': 100000,
      'status': 'Paid',
    },
    {
      'title': 'Installment 2',
      'date': '10 Feb 2024',
      'mode': 'Card Payment',
      'amount': 100000,
      'status': 'Paid',
    },
    {
      'title': 'Final Installment (3 of 3)',
      'date': 'Due: 15 Mar 2024',
      'mode': 'Pending',
      'amount': 100000,
      'status': 'Due',
    },
  ];

  final List<Map<String, dynamic>> receipts = [
    {
      'receiptNumber': 'EM-2024-101',
      'amount': 100000.00,
      'date': '15 Jan 2024',
      'mode': 'Online UPI',
    },
    {
      'receiptNumber': 'EM-2024-102',
      'amount': 100000.00,
      'date': '10 Feb 2024',
      'mode': 'Debit Card',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Fee Payments',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStudentCard(),
                    const SizedBox(height: 18),
                    _buildInstallmentPlanCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...transactions.map((tx) => _buildTransactionCard(tx)),
                    const SizedBox(height: 24),
                    const Text(
                      'Payment Receipts',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...receipts.map((r) => _buildReceiptCard(r)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard() {
    return NMCard(
      padding: const EdgeInsets.all(16),
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
            child: const Icon(Icons.school_outlined, color: NMTheme.primaryPurple, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aditya Mishra',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Class 11th JEE-MAINS • ID: 202400123',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: NMTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentPlanCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NMTheme.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: NMTheme.primaryPurple.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Academic Fee',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Session 2025-26', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '₹3,00,000',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Next Due: ₹1,00,000',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Due date: 15 Mar 2024 • Installment 3',
                      style: TextStyle(color: Colors.white70, fontSize: 11.5),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _showPaymentDialog(context, 100000, 3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: NMTheme.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    final isPaid = tx['status'] == 'Paid';
    final Color statusColor = isPaid ? NMTheme.accentTeal : const Color(0xFFFB8C00);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPaid ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      color: NMTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${tx['date']} • ${tx['mode']}',
                    style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${tx['amount']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: NMTheme.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tx['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptCard(Map<String, dynamic> receipt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: NMTheme.primaryPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.receipt_long_rounded, color: NMTheme.primaryPurple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receipt #${receipt['receiptNumber']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: NMTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${receipt['date']} • ${receipt['mode']}',
                    style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary),
                  ),
                ],
              ),
            ),
            NMIconButton(
              icon: Icons.download_rounded,
              size: 38,
              iconSize: 20,
              iconColor: NMTheme.primaryPurple,
              onTap: () => _downloadReceipt(receipt),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, int amount, int installmentNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: NMTheme.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Make Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: NMTheme.textDark)),
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
            NMCard(
              padding: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount Payable', style: TextStyle(color: NMTheme.textSecondary, fontWeight: FontWeight.w600)),
                  Text('₹$amount', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NMTheme.primaryPurple)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: NMTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: NMTheme.primaryPurple.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Payment processed successfully!'),
                        backgroundColor: NMTheme.accentTeal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(
                    child: Text(
                      'Proceed to Secure Gateway',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.5),
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

  Future<void> _downloadReceipt(Map<String, dynamic> receipt) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(30),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('EduMunch Fee Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.purple800)),
                  pw.SizedBox(height: 20),
                  pw.Text('Receipt No: ${receipt['receiptNumber']}'),
                  pw.Text('Date: ${receipt['date']}'),
                  pw.Text('Mode: ${receipt['mode']}'),
                  pw.Text('Student: Aditya Mishra (Class 11th JEE Mains)'),
                  pw.SizedBox(height: 20),
                  pw.Text('Amount: ₹${receipt['amount']}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/receipt_${receipt['receiptNumber']}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receipt saved: $filePath'),
            backgroundColor: NMTheme.accentTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving receipt: $e'), backgroundColor: const Color(0xFFE53935)),
        );
      }
    }
  }
}
