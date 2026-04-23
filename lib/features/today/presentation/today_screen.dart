import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import 'widgets/greeting_header.dart';
import 'widgets/next_class_card.dart';
import 'widgets/today_habits_card.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100), // extra padding bottom for nav bar
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const GreetingHeader(),
                const SizedBox(height: 32),
                const NextClassCard(),
                const SizedBox(height: 32),
                const TodayHabitsCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: NexusColors.background.withValues(alpha: 0.8),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NexusColors.surface,
              border: Border.all(color: NexusColors.glassBorder),
            ),
            child: const Icon(Icons.person, size: 20, color: NexusColors.textSecondary),
          ),
          ShaderMask(
            shaderCallback: (bounds) => NexusColors.accentGrad.createShader(bounds),
            child: Text(
              'NEXUS',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: Colors.white,
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
}
