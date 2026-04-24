import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GlassButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isPrimary;
  final double borderRadius;
  final double? width;
  final double? height;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isPrimary = true,
    this.borderRadius = 24,
    this.width,
    this.height = 56,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: widget.isPrimary ? NexusColors.accentGrad : null,
            color: widget.isPrimary ? null : NexusColors.surfaceGlass,
            border: widget.isPrimary ? null : Border.all(color: NexusColors.glassBorder, width: 1),
            boxShadow: _isHovered && widget.isPrimary ? [
              BoxShadow(
                color: NexusColors.accentLavender.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ] : [],
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
