import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import 'widgets/progress_ring.dart';
import 'widgets/checklist_tile.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Atmospheric backgrounds
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentCyan.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentCyan.withOpacity(0.1), blurRadius: 120),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentBlue.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentBlue.withOpacity(0.1), blurRadius: 100),
                  ],
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: Column(
                      children: [
                        _buildDateNavigator(),
                        const SizedBox(height: 32),
                        const ProgressRing(completed: 7, total: 10),
                        const SizedBox(height: 32),
                        _buildTabs(),
                        const SizedBox(height: 24),
                        _buildChecklist(),
                      ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NexusColors.surfaceGlass,
              border: Border.all(color: NexusColors.glassBorder),
            ),
            child: const Icon(Icons.person, size: 20, color: NexusColors.textSecondary),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'NEXUS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NexusColors.accentCyan,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: NexusColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(Icons.chevron_left),
        Text(
          'Rabu, 23 Apr',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: NexusColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        _iconButton(Icons.chevron_right),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        shape: BoxShape.circle,
        border: Border.all(color: NexusColors.glassBorder),
      ),
      child: Icon(icon, color: NexusColors.textSecondary),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        border: Border.all(color: NexusColors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                'Harian',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                'Mingguan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                'Custom',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    return Column(
      children: [
        const ChecklistTile(
          title: 'Review Material Sains Bab 4',
          subtitle: 'Prioritas Tinggi',
        ),
        const SizedBox(height: 8),
        const ChecklistTile(
          title: 'Draft Essay Sejarah',
          subtitle: 'Due: 23:59',
        ),
        const SizedBox(height: 8),
        const ChecklistTile(
          title: 'Kirim Email ke Dosen Pembimbing',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: NexusColors.glassBorder, height: 1),
        ),
        const Opacity(
          opacity: 0.5,
          child: ChecklistTile(
            title: 'Latihan Soal Kalkulus',
            isCompleted: true,
          ),
        ),
        const SizedBox(height: 8),
        const Opacity(
          opacity: 0.5,
          child: ChecklistTile(
            title: 'Baca Bab 2 Pengantar Ekonomi',
            isCompleted: true,
          ),
        ),
      ],
    );
  }
}
