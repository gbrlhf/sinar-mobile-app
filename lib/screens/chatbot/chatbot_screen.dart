import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_theme.dart';
import '../../models/pju_data.dart';
import '../../providers/pju_provider.dart';

enum _Sender { user, sinar }

class _ChatMessage {
  final _Sender sender;
  final String text;
  final DateTime timestamp;

  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  static const List<String> _templateQuestions = [
    'Apakah lampu menyala?',
    'Berapa baterai sekarang?',
    'Berapa tegangan saat ini?',
    'Bagaimana kondisi panel surya?',
    'Bagaimana kondisi sistem?',
    'Ada potensi kerusakan?',
  ];

  String _formatVoltage(double voltage) {
    return '${voltage.toStringAsFixed(1).replaceAll('.', ',')} V';
  }

  String _generateAnswer(String question, PJUProvider pju) {
    final modeText = pju.operationMode == OperationMode.automatic
        ? 'otomatis'
        : 'manual';

    switch (question) {
      case 'Apakah lampu menyala?':
        if (pju.lampStatus) {
          return 'Ya, lampu saat ini menyala.\nMode pengoperasian sedang $modeText.';
        } else {
          return 'Lampu saat ini mati.\nMode pengoperasian sedang $modeText.';
        }

      case 'Berapa baterai sekarang?':
        final batteryStatus =
            pju.componentStatus['Baterai']?.toLowerCase() ?? 'baik';
        return 'Baterai saat ini ${pju.batteryPercentage.toInt()}%.\nKondisi baterai $batteryStatus.';

      case 'Berapa tegangan saat ini?':
        return 'Tegangan baterai saat ini ${_formatVoltage(pju.voltage)}.';

      case 'Bagaimana kondisi panel surya?':
        return 'Kondisi panel surya saat ini ${pju.solarPanelStatus}.';

      case 'Bagaimana kondisi sistem?':
        final isAllGood = pju.componentStatus.values.every(
          (status) => status.toUpperCase() == 'BAIK',
        );
        if (isAllGood) {
          return 'Semua komponen sistem saat ini dalam kondisi baik.';
        } else {
          final issueComponents = pju.componentStatus.entries
              .where((e) => e.value.toUpperCase() != 'BAIK')
              .map((e) => '• ${e.key}: ${e.value}')
              .join('\n');
          return 'Saat ini ada komponen yang perlu diperhatikan:\n$issueComponents';
        }

      case 'Ada potensi kerusakan?':
        return 'Saat ini sistem dalam kondisi normal berdasarkan data yang tersedia.\n\n'
            'Fitur prediksi akan menggunakan data historis untuk melihat perubahan kondisi sistem.\n\n'
            'Prediksi: BELUM TERSEDIA';

      default:
        return 'Silakan pilih pertanyaan yang tersedia untuk mengetahui kondisi sistem.';
    }
  }

  void _handleQuestionTap(String question, PJUProvider pju) {
    final now = DateTime.now();
    final answerText = _generateAnswer(question, pju);

    setState(() {
      _messages.add(
        _ChatMessage(
          sender: _Sender.user,
          text: question,
          timestamp: now,
        ),
      );
      _messages.add(
        _ChatMessage(
          sender: _Sender.sinar,
          text: answerText,
          timestamp: now,
        ),
      );
    });

    // Auto-scroll ke pesan terbaru
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showQuestionsBottomSheet(BuildContext context, PJUProvider pju) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Judul & Subtitle Bottom Sheet
                const Text(
                  'Pilih Pertanyaan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Silakan pilih informasi yang ingin diketahui.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 8),

                // Daftar 6 Pertanyaan Template
                ..._templateQuestions.map((question) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Material(
                      color: AppTheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 2.0,
                        ),
                        dense: true,
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.help_outline,
                            size: 16,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        title: Text(
                          question,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppTheme.textSecondary,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _handleQuestionTap(question, pju);
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pju = context.watch<PJUProvider>();
    final isConnected = pju.connectionStatus.toUpperCase() == 'TERHUBUNG';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. HEADER (KONSISTEN DENGAN BERANDA & KONTROL)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tanya SINAR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryGreen,
                          letterSpacing: 1.2,
                        ),
                      ),
                      // Status Koneksi Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isConnected
                              ? AppTheme.lightGreen
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isConnected
                                ? const Color(0xFFA5D6A7)
                                : const Color(0xFFFFCDD2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isConnected
                                    ? AppTheme.statusSuccess
                                    : AppTheme.statusError,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isConnected ? 'Terhubung' : 'Terputus',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isConnected
                                    ? AppTheme.statusSuccess
                                    : AppTheme.statusError,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Informasi sederhana tentang kondisi sistem.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

            // ==========================================
            // 2. CHAT CONVERSATION AREA
            // ==========================================
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                children: [
                  // Pesan Pembuka dari SINAR
                  _buildSinarBubble(
                    'Halo! Saya SINAR.\nSilakan pilih pertanyaan untuk mengetahui kondisi sistem.',
                  ),
                  const SizedBox(height: 12),

                  // Riwayat Percakapan
                  ..._messages.map((message) {
                    if (message.sender == _Sender.user) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildUserBubble(message.text),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildSinarBubble(message.text),
                      );
                    }
                  }),
                ],
              ),
            ),

            // ==========================================
            // 3. SINGLE PROMINENT ACTION BUTTON
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _showQuestionsBottomSheet(context, pju),
                  icon: const Icon(Icons.help_outline, size: 20),
                  label: const Text(
                    'Pilihan Pertanyaan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          border: Border.all(color: const Color(0xFFC8E6C9)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildSinarBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 10, top: 2),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFA5D6A7)),
            ),
            child: const Icon(
              Icons.solar_power_outlined,
              size: 18,
              color: AppTheme.primaryGreen,
            ),
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 290),
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
