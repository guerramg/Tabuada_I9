import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class ReviewItem {
  final String question;
  final bool correct;
  final String explain;
  final String userAnswer;

  const ReviewItem({
    required this.question,
    required this.correct,
    required this.explain,
    required this.userAnswer,
  });
}

class ResultScreen extends StatelessWidget {
  final SessionMode mode;
  final String title;
  final int correct;
  final int total;
  final List<String> unlockedKeys;
  final List<ReviewItem> reviewLogs;

  const ResultScreen({
    super.key,
    required this.mode,
    required this.title,
    required this.correct,
    required this.total,
    required this.unlockedKeys,
    this.reviewLogs = const [],
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final ratio = total == 0 ? 0.0 : correct / total;

    return Scaffold(
      appBar: AppBar(title: Text('Resultado · $title')),
      body: CircuitBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              color: app.theme.accent.withValues(alpha: 0.2),
              child: Column(
                children: [
                  Text(
                    ratio >= 0.8
                        ? app.copy.awesome
                        : ratio >= 0.5
                            ? 'Bom ritmo!'
                            : app.copy.almost,
                    style: GoogleFonts.exo2(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$correct / $total acertos',
                    style: GoogleFonts.exo2(
                      fontSize: 20,
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CoinCounter(balance: app.wallet.balance),
                ],
              ),
            ),
            if (unlockedKeys.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Conquistas novas',
                  style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...unlockedKeys.map((k) {
                final match = app.achievements.where((a) => a.key == k);
                final title = match.isEmpty ? k : match.first.title;
                final icon = match.isEmpty ? '🏅' : match.first.icon;
                return ListTile(
                  leading: Text(icon, style: const TextStyle(fontSize: 22)),
                  title: Text(title, style: GoogleFonts.exo2()),
                );
              }),
            ],
            if (reviewLogs.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Revisão da prova',
                  style: GoogleFonts.exo2(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ...reviewLogs.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GradientCard(
                    color: (r.correct ? AppColors.success : AppColors.danger)
                        .withValues(alpha: 0.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.question,
                            style: GoogleFonts.exo2(
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Sua resposta: ${r.userAnswer}',
                            style: GoogleFonts.exo2(
                                color: AppColors.grey, fontSize: 13)),
                        const SizedBox(height: 8),
                        Text(r.explain,
                            style: GoogleFonts.exo2(height: 1.35)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
