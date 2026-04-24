import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import 'auth_providers.dart';
import 'widgets/mesh_gradient_bg.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await ref.read(authRepositoryProvider).signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) context.go('/today');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator(color: NexusColors.accentLavender)),
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
                color: NexusColors.accentLavender.withValues(alpha: 0.15),
                blurRadius: 20,
              )
            ],
          ),
          child: Icon(LucideIcons.scan, color: NexusColors.accentLavender),
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
            controller: _emailController,
            hintText: 'student@university.edu',
            prefixIcon: Icon(LucideIcons.mail, color: NexusColors.textMuted),
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
                  color: NexusColors.accentLavender,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          GlassInput(
            controller: _passwordController,
            hintText: '••••••••',
            obscureText: !_isPasswordVisible,
            prefixIcon: Icon(LucideIcons.lock, color: NexusColors.textMuted),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
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
                color: Colors.black,
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
                Icon(LucideIcons.globe, size: 24, color: Colors.white),
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
            color: NexusColors.accentLavender,
          ),
        ),
      ],
    );
  }
}

