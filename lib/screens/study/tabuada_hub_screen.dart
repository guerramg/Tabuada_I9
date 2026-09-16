import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/screens/study/quiz_screen.dart';
import 'package:tabuadai9/screens/study/tabuada_table_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/services/tabuada_service.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/theme/app_theme.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class TabuadaHubScreen extends StatefulWidget {
  const TabuadaHubScreen({super.key});

  @override
  State<TabuadaHubScreen> createState() => _TabuadaHubScreenState();
}

class _TabuadaHubScreenState extends State<TabuadaHubScreen> {
  int? selectedTable;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final focus = state.profile?.studyCeiling ?? 1;
    final tables = TabuadaService.tablesFor(focus);
    final palette = AppPalette.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Treino de Tabuada')),
      body: CircuitBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Tabuadas do 1 ao ${TabuadaService.maxTable(focus)} '
              '(liberadas no $focusº ano)',
              style: GoogleFonts.exo2(color: AppColors.grey),
            ),
            const SizedBox(height: 12),
            Text('Escolha a tabuada',
                style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todas'),
                  selected: selectedTable == null,
                  onSelected: (_) => setState(() => selectedTable = null),
                  selectedColor: palette.accent,
                ),
                ...tables.map((t) {
                  final selected = selectedTable == t;
                  return ChoiceChip(
                    label: Text('$t'),
                    selected: selected,
                    onSelected: (_) => setState(() => selectedTable = t),
                    selectedColor: palette.accent,
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            _Tile(
              emoji: '📋',
              title: 'Ver tabuada',
              subtitle: selectedTable == null
                  ? 'Escolha um número acima para ver a tabela'
                  : 'Ver $selectedTable × 0 até 10',
              onTap: selectedTable == null
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TabuadaTableScreen(
                            table: selectedTable!,
                            through: TabuadaService.timesThrough(focus),
                          ),
                        ),
                      );
                    },
            ),
            _Tile(
              emoji: '✖️',
              title: 'Treino de multiplicação',
              subtitle: 'Sequência da tabuada escolhida',
              onTap: () => _openQuiz(
                context,
                focus: focus,
                op: 'mul',
                sequential: true,
                count: 10,
                title: 'Treino ×',
                mode: SessionMode.quiz,
              ),
            ),
            _Tile(
              emoji: '➗',
              title: 'Treino de divisão',
              subtitle: 'Tabuada invertida (÷)',
              onTap: () => _openQuiz(
                context,
                focus: focus,
                op: 'div',
                sequential: false,
                count: 10,
                title: 'Treino ÷',
                mode: SessionMode.quiz,
              ),
            ),
            _Tile(
              emoji: '🎯',
              title: 'Quiz relâmpago',
              subtitle: '10 contas mistas × e ÷ · extra de I9\$',
              onTap: () => _openQuiz(
                context,
                focus: focus,
                op: 'mixed',
                sequential: false,
                count: 10,
                title: 'Quiz Tabuada',
                mode: SessionMode.quiz,
              ),
            ),
            _Tile(
              emoji: '⚡',
              title: 'Contra o relógio',
              subtitle: 'Desafio cronometrado de tabuada',
              onTap: () => _openQuiz(
                context,
                focus: focus,
                op: 'mixed',
                sequential: false,
                count: 8,
                title: 'Tabuada Relâmpago',
                mode: SessionMode.challenge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openQuiz(
    BuildContext context, {
    required int focus,
    required String op,
    required bool sequential,
    required int count,
    required String title,
    required SessionMode mode,
  }) {
    final exercises = TabuadaService.buildSession(
      focusGrade: focus,
      table: selectedTable,
      op: op,
      count: count,
      sequential: sequential,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          mode: mode,
          grade: focus,
          unit: 'tabuada',
          exercises: exercises,
          title: title,
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _Tile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
        child: GradientCard(
          onTap: onTap,
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.exo2(fontWeight: FontWeight.w800)),
                    Text(subtitle,
                        style: GoogleFonts.exo2(
                            color: AppColors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.play_arrow_rounded, color: palette.primary),
            ],
          ),
        ),
      ),
    );
  }
}
