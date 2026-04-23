import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import 'widgets/mesh_gradient_bg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  void _login() {
    // Navigate to today
    context.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MeshGradientBg(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildLoginForm(),
                    const SizedBox(height: 32),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: NexusColors.surfaceGlass,
            border: Border.all(color: NexusColors.glassBorder),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: NexusColors.accentCyan.withOpacity(0.15),
                blurRadius: 20,
              )
            ],
          ),
          child: const Icon(Icons.my_location, color: NexusColors.accentCyan),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => NexusColors.accentGrad.createShader(bounds),
          child: Text(
            'Nexus',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.64,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Initialize your workspace',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: NexusColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputLabel('Email Address'),
          const SizedBox(height: 4),
          GlassInput(
            hintText: 'student@university.edu',
            prefixIcon: const Icon(Icons.mail_outline, color: NexusColors.textMuted),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputLabel('Password'),
              Text(
                'Forgot?',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: NexusColors.accentCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          GlassInput(
            hintText: '••••••••',
            obscureText: !_isPasswordVisible,
            prefixIcon: const Icon(Icons.lock_outline, color: NexusColors.textMuted),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: NexusColors.textMuted,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          GlassButton(
            onPressed: _login,
            child: Text(
              'Access Console',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: Colors.black, // on-primary-fixed
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider(color: NexusColors.glassBorder)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: NexusColors.textMuted,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: NexusColors.glassBorder)),
            ],
          ),
          const SizedBox(height: 24),
          GlassButton(
            isPrimary: false,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Logo Icon (Mock)
                const Icon(Icons.g_mobiledata, size: 32, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Continue with Google',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: NexusColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: NexusColors.textSecondary,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Unregistered entity? ',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: NexusColors.textSecondary,
          ),
        ),
        Text(
          'Initialize account',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: NexusColors.accentCyan,
          ),
        ),
      ],
    );
  }
}
