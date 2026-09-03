import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/screens/study/lesson_screen.dart';
import 'package:tabuadai9/screens/study/quiz_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/services/content_service.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class TopicHubScreen extends StatefulWidget {
  final int grade;
  final SubjectInfo subject;

  const TopicHubScreen({
    super.key,
    required this.grade,
    required this.subject,
  });

  @override
  State<TopicHubScreen> createState() => _TopicHubScreenState();
}

class _TopicHubScreenState extends State<TopicHubScreen> {
  LessonContent? lesson;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ContentService.instance
        .loadLesson(widget.grade, widget.subject.id);
    setState(() {
      lesson = data;
      loading = false;
    });
  }

  Future<void> _openMode(SessionMode mode, String title) async {
    final profile = context.read<AppState>().profile;
    final exercises = await ContentService.instance.buildSession(
      focusGrade: profile?.clampedFocusGrade ?? widget.grade,
      maxGrade: profile?.maxGrade ?? widget.grade,
      unit: widget.subject.id,
      mode: mode,
    );
    if (!mounted) return;
    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sem exercícios neste tópico ainda.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          mode: mode,
          grade: widget.grade,
          unit: widget.subject.id,
          exercises: exercises,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isBoy = state.profile?.isBoy ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject.emoji} ${widget.subject.name}'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  lesson?.displayTitle(isBoy) ?? widget.subject.name,
                  style: GoogleFonts.exo2(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.grade}º ano · BNCC',
                  style: GoogleFonts.exo2(color: AppColors.grey),
                ),
                const SizedBox(height: 16),
                GradientCard(
                  onTap: lesson == null
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LessonScreen(lesson: lesson!),
                            ),
                          );
                        },
                  child: Row(
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lição — aprende antes de treinar',
                          style: GoogleFonts.exo2(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.cyan),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _ModeTile(
                  emoji: '✅',
                  title: 'Tarefa do dia',
                  subtitle: context.watch<AppState>().dailyDoneToday
                      ? 'Já feita hoje'
                      : 'Fatia diária de I9\$',
                  onTap: context.watch<AppState>().dailyDoneToday
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tarefa do dia já concluída!'),
                            ),
                          );
                        }
                      : () => _openMode(SessionMode.daily, 'Tarefa do Dia'),
                ),
                _ModeTile(
                  emoji: '🎮',
                  title: 'Quiz',
                  subtitle: 'Extra pequeno',
                  onTap: () => _openMode(SessionMode.quiz, 'Quiz'),
                ),
                _ModeTile(
                  emoji: '⚡',
                  title: 'Desafio',
                  subtitle: 'Extra médio',
                  onTap: () =>
                      _openMode(SessionMode.challenge, 'Desafio'),
                ),
                _ModeTile(
                  emoji: '📝',
                  title: 'Prova',
                  subtitle: 'Extra grande + Modo Foco',
                  onTap: () => _openMode(SessionMode.test, 'Prova'),
                ),
                if (lesson != null && lesson!.topics.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Tópicos',
                      style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...lesson!.topics.map(
                    (t) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.bookmark, color: AppColors.cyan),
                      title: Text(t.name,
                          style: GoogleFonts.exo2(fontWeight: FontWeight.w600)),
                      subtitle: Text(t.bncc,
                          style: GoogleFonts.exo2(color: AppColors.grey)),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GradientCard(
        onTap: onTap,
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
                  Text(subtitle,
                      style:
                          GoogleFonts.exo2(color: AppColors.grey, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.play_arrow_rounded, color: AppColors.blue),
          ],
        ),
      ),
    );
  }
}
