import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/screens/study/topic_hub_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class SubjectMapScreen extends StatelessWidget {
  const SubjectMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final maxGrade = state.profile?.maxGrade ?? 5;
    final currentGrade = state.profile?.currentGrade ?? 1;

    return CircuitBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Mapa de Matérias',
              style: GoogleFonts.exo2(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Liberado até o $maxGradeº ano (BNCC). Ano em foco: $currentGradeº.',
              style: GoogleFonts.exo2(color: AppColors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(maxGrade, (i) {
                final grade = i + 1;
                final selected = grade == currentGrade;
                return ChoiceChip(
                  label: Text('$gradeº'),
                  selected: selected,
                  onSelected: (_) async {
                    final p = state.profile;
                    if (p == null) return;
                    await state.updateProfile(p.copyWith(currentGrade: grade));
                  },
                  selectedColor: state.theme.accent,
                  labelStyle: GoogleFonts.exo2(
                    color: selected ? AppColors.navy : AppColors.offWhite,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            ...subjects.map((s) {
              final color = Color(int.parse('FF${s.colorHex}', radix: 16));
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GradientCard(
                  color: color.withValues(alpha: 0.18),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TopicHubScreen(
                          grade: currentGrade,
                          subject: s,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(s.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: GoogleFonts.exo2(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Lição + tarefa + quiz + prova',
                              style: GoogleFonts.exo2(
                                color: AppColors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.cyan),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
