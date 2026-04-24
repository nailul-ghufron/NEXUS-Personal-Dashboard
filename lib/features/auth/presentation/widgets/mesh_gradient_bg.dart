import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class MeshGradientBg extends StatelessWidget {
  const MeshGradientBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(color: NexusColors.background),
        // Top Left Cyan/Blue blob
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NexusColors.accentLavender.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: NexusColors.accentLavender.withValues(alpha: 0.15),
                  blurRadius: 100,
                  spreadRadius: 50,
                )
              ],
            ),
          ),
        ),
        // Bottom Right Blue blob
        Positioned(
          bottom: -200,
          right: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NexusColors.accentViolet.withValues(alpha: 0.20),
              boxShadow: [
                BoxShadow(
                  color: NexusColors.accentViolet.withValues(alpha: 0.20),
                  blurRadius: 100,
                  spreadRadius: 50,
                )
              ],
            ),
          ),
        ),
        // Top Right Orange/Tertiary blob (simulating #ffd6a3)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD946EF).withValues(alpha: 0.10), // Magenta/Fuchsia
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD946EF).withValues(alpha: 0.10),
                  blurRadius: 100,
                  spreadRadius: 50,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
