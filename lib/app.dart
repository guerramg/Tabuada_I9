import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/screens/home/home_page.dart';
import 'package:tabuadai9/screens/onboarding/onboarding_screen.dart';
import 'package:tabuadai9/screens/splash/splash_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/theme/app_theme.dart';

class Mathi9App extends StatelessWidget {
  const Mathi9App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, state, _) {
          final theme = state.ready
              ? state.theme.material
              : const AppTheme().material;
          return MaterialApp(
            title: 'Mathi9 Kids',
            debugShowCheckedModeBanner: false,
            theme: theme,
            color: AppColors.navy,
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/onboarding': (_) => const OnboardingScreen(),
              '/home': (_) => const HomeShell(),
            },
          );
        },
      ),
    );
  }
}
