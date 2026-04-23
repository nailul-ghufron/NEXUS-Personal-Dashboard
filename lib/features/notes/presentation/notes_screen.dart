import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_input.dart';
import 'widgets/note_card.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Atmospheric backgrounds
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentCyan.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentCyan.withOpacity(0.1), blurRadius: 150),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentBlue.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentBlue.withOpacity(0.1), blurRadius: 150),
                  ],
                ),
              ),
            ),
            // Content
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    child: Column(
                      children: [
                        _buildSearchInput(),
                        const SizedBox(height: 24),
                        _buildMasonryGrid(),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'NOTES',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.64,
              color: NexusColors.textPrimary,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: NexusColors.accentGrad,
              boxShadow: [
                BoxShadow(color: NexusColors.accentCyan.withOpacity(0.4), blurRadius: 12),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return GlassInput(
      hintText: 'Search notes...',
      prefixIcon: const Icon(Icons.search, color: NexusColors.textSecondary),
    );
  }

  Widget _buildMasonryGrid() {
    // Simple 2-column masonry simulation using Rows and Columns
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: const [
              NoteCard(
                title: 'Physics Midterm Formulas',
                content: 'Kinematics: v = u + at, s = ut + 1/2at^2.\nRemember to check units before plugging into equations.\nForces: F = ma. Torque = r x F.',
                date: '2 hours ago',
                tint: NoteTint.aurora,
              ),
              NoteCard(
                title: 'To-Do: Weekend',
                content: '✓ Groceries\n✓ Laundry\n☐ Finish Math P-Set',
                date: 'Oct 12',
                tint: NoteTint.neutral,
              ),
              NoteCard(
                title: 'Questions for Prof. Smith',
                content: 'Clarify the grading rubric for the final project.\nCan we use external libraries for the coding assignment?',
                date: 'Oct 08',
                tint: NoteTint.dusk,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: const [
              NoteCard(
                title: 'Lit Essay Ideas',
                content: 'Theme of isolation in modern dystopia.\nCompare 1984 with Brave New World.\nFocus on the role of technology as a silencer vs an amplifier.',
                date: 'Yesterday',
                tint: NoteTint.ocean,
              ),
              NoteCard(
                title: 'Biology Lab Notes',
                content: 'Mitochondria observations. The dye took 5 mins to settle.\nSample B showed higher activity under heat stress.',
                date: 'Oct 10',
                tint: NoteTint.forest,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
