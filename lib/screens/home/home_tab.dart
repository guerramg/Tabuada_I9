import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/screens/study/quiz_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/services/content_service.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _startDaily(BuildContext context) async {
    final state = context.read<AppState>();
    final profile = state.profile;
    final focus = profile?.clampedFocusGrade ?? 1;
    final exercises = await ContentService.instance.buildSession(
      focusGrade: focus,
      maxGrade: profile?.maxGrade ?? focus,
      mode: SessionMode.daily,
    );
    if (!context.mounted) return;
    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conteúdo ainda não disponível.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          mode: SessionMode.daily,
          grade: focus,
          unit: 'misto',
          exercises: exercises,
          title: 'Tarefa do Dia',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.profile;
    final accent = state.theme.accent;

    return CircuitBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.copy.hello,
                        style: GoogleFonts.exo2(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        profile?.name ?? 'Aluno',
                        style: GoogleFonts.exo2(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Ano foco: ${profile?.clampedFocusGrade ?? '-'}º  ·  '
                        '75% deste ano, 25% dos anteriores',
                        style: GoogleFonts.exo2(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                StreakBadge(streak: state.currentStreak),
                const SizedBox(width: 8),
                CoinCounter(balance: state.wallet.balance, compact: true),
              ],
            ),
            const SizedBox(height: 20),
            GradientCard(
              color: accent.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.dailyDoneToday
                        ? state.copy.dailyDone
                        : 'Tarefa do dia te esperando',
                    style: GoogleFonts.exo2(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.dailyDoneToday
                        ? 'Você já garantiu a fatia de hoje. Bora treinar extras?'
                        : 'Complete a tarefa diária e liberar I9\$ da fatia do dia.',
                    style: GoogleFonts.exo2(color: AppColors.grey),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: state.dailyDoneToday
                        ? null
                        : () => _startDaily(context),
                    child: Text(
                      state.dailyDoneToday ? 'Já feita hoje' : state.copy.studyCta,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dias do mês',
                    style: GoogleFonts.exo2(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${state.completedDays.length} dias no verde. Mês completo = bônus máximo!',
                    style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  MonthDayDots(
                    completedDays: state.completedDays,
                    accent: accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orçamento do mês',
                      style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: state.budget.monthlyCapI9 == 0
                        ? 0
                        : (state.earnedThisMonth / state.budget.monthlyCapI9)
                            .clamp(0, 1),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.cyan,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.earnedThisMonth} / ${state.budget.monthlyCapI9} I9\$ '
                    '(R\$ ${(state.earnedThisMonth / 100).toStringAsFixed(2)} / '
                    'R\$ ${state.budget.capReais.toStringAsFixed(2)})',
                    style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GradientCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizScreen.loader(
                            mode: SessionMode.challenge,
                            focusGrade: profile?.clampedFocusGrade ?? 1,
                            maxGrade: profile?.maxGrade ?? 5,
                            title: 'Desafio Relâmpago',
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Text('⚡', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text('Desafio',
                            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizScreen.reviewLoader(
                            focusGrade: profile?.clampedFocusGrade ?? 1,
                            maxGrade: profile?.maxGrade ?? 5,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Text('🔁', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text('Revisão',
                            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
