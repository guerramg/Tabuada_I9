import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    _boot();
  }

  Future<void> _boot() async {
    final state = context.read<AppState>();
    await state.bootstrap();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    if (state.hasProfile) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: CircuitBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.35),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/brand/i9_logo.png',
                        width: 160,
                        height: 160,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Mathi9 Kids',
                      style: GoogleFonts.exo2(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.offWhite,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Cérebro no 9. Matemática que dá play.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.exo2(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cyan,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const CircularProgressIndicator(color: AppColors.blue),
                    const Spacer(),
                    Text(
                      'um app i9',
                      style: GoogleFonts.exo2(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'i9 Soluções Inteligentes',
                      style: GoogleFonts.exo2(
                        color: AppColors.grey.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
