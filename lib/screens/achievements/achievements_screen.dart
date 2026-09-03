import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Conquistas')),
      body: CircuitBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.achievements.length,
          itemBuilder: (context, i) {
            final a = state.achievements[i];
            return Opacity(
              opacity: a.unlocked ? 1 : 0.45,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GradientCard(
                  child: Row(
                    children: [
                      Text(a.icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.title,
                                style: GoogleFonts.exo2(
                                    fontWeight: FontWeight.w800)),
                            Text(a.description,
                                style: GoogleFonts.exo2(
                                    color: AppColors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      if (a.unlocked)
                        const Icon(Icons.check_circle, color: AppColors.success),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
