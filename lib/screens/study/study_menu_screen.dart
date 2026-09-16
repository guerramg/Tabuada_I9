import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/screens/study/subject_map_screen.dart';
import 'package:tabuadai9/screens/study/tabuada_hub_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/theme/app_theme.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

/// Estudar tab: exclusive Tabuada menu + BNCC subjects of the focus year.
class StudyMenuScreen extends StatelessWidget {
  const StudyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.profile;
    final focus = profile?.studyCeiling ?? 1;
    final palette = AppPalette.of(context);

    return CircuitBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Estudar',
              style: GoogleFonts.exo2(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ano foco: $focusº — só matérias deste ano e dos anteriores.',
              style: GoogleFonts.exo2(color: AppColors.grey),
            ),
            const SizedBox(height: 20),
            GradientCard(
              color: palette.accent.withValues(alpha: 0.22),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TabuadaHubScreen()),
                );
              },
              child: Row(
                children: [
                  const Text('✖️', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Treino de Tabuada',
                          style: GoogleFonts.exo2(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Menu exclusivo: ver, treinar × e ÷, quiz e contra o relógio',
                          style: GoogleFonts.exo2(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: palette.secondary),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GradientCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubjectMapScreen()),
                );
              },
              child: Row(
                children: [
                  const Text('📚', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Matérias do $focusº ano',
                          style: GoogleFonts.exo2(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Lição, tarefa, quiz e prova — 1º até $focusº (BNCC)',
                          style: GoogleFonts.exo2(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: palette.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
