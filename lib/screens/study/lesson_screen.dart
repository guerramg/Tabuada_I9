import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class LessonScreen extends StatefulWidget {
  final LessonContent lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final isBoy = context.watch<AppState>().profile?.isBoy ?? true;
    final slides = widget.lesson.slides;
    final slide = slides.isEmpty
        ? null
        : slides[index.clamp(0, slides.length - 1)];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.displayTitle(isBoy)),
      ),
      body: CircuitBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: slides.isEmpty ? 0 : (index + 1) / slides.length,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                color: AppColors.cyan,
                backgroundColor: AppColors.grey.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GradientCard(
                  padding: const EdgeInsets.all(22),
                  child: slide == null
                      ? Center(
                          child: Text(
                            'Lição em breve!',
                            style: GoogleFonts.exo2(fontSize: 18),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide.title(isBoy),
                              style: GoogleFonts.exo2(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cyan,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              slide.body(isBoy),
                              style: GoogleFonts.exo2(
                                fontSize: 17,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (index > 0)
                    TextButton(
                      onPressed: () => setState(() => index--),
                      child: const Text('Voltar'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (index >= slides.length - 1) {
                        Navigator.pop(context);
                      } else {
                        setState(() => index++);
                      }
                    },
                    child: Text(
                      index >= slides.length - 1 ? 'Bora treinar!' : 'Próxima',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
