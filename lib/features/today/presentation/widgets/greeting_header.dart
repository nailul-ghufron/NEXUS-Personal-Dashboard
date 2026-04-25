import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/auth_providers.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = DateTime.now().hour;
    final greeting = hour < 11 ? 'Pagi' : hour < 15 ? 'Siang' : hour < 18 ? 'Sore' : 'Malam';
    
    final user = ref.watch(currentUserProvider);
    final name = user?.userMetadata?['full_name']?.toString().split(' ').first ?? 'Pengguna';
    
    final date = DateFormat('EEEE, d MMMM yyyy', 'id_ID')
        .format(DateTime.now())
        .toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                'Selamat $greeting, $name',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.64,
                  color: NexusColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '✦',
              style: TextStyle(
                fontSize: 24,
                color: NexusColors.accentLavender,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
            color: NexusColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
