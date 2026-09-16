import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabuadai9/services/tabuada_service.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/theme/app_theme.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class TabuadaTableScreen extends StatelessWidget {
  final int table;
  final int through;

  const TabuadaTableScreen({
    super.key,
    required this.table,
    this.through = 10,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final rows = TabuadaService.rowsFor(table, through: through);

    return Scaffold(
      appBar: AppBar(title: Text('Tabuada do $table')),
      body: CircuitBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              color: palette.accent.withValues(alpha: 0.18),
              child: Text(
                'Tabuada do $table — de 0 até $through',
                style: GoogleFonts.exo2(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...rows.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GradientCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${r.$1} × ${r.$2}',
                          style: GoogleFonts.exo2(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '= ${r.$3}',
                        style: GoogleFonts.exo2(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: palette.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dica: fale em voz alta. Depois treine × e ÷ no menu.',
              style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
