import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabuadai9/theme/app_colors.dart';

enum GenderKit { boy, girl }

class AppTheme {
  final GenderKit kit;

  const AppTheme({this.kit = GenderKit.boy});

  Color get accent =>
      kit == GenderKit.boy ? AppColors.adventureOrange : AppColors.starPink;

  Color get accentAlt =>
      kit == GenderKit.boy ? AppColors.adventureGreen : AppColors.starLilac;

  Color get accentSoft =>
      kit == GenderKit.boy ? AppColors.cyan : AppColors.starGold;

  ThemeData get material {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.navy,
      colorScheme: ColorScheme.dark(
        primary: AppColors.blue,
        secondary: AppColors.cyan,
        tertiary: accent,
        surface: const Color(0xFF0A1A2E),
        error: AppColors.danger,
        onPrimary: AppColors.white,
        onSecondary: AppColors.navy,
        onSurface: AppColors.offWhite,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.exo2TextTheme(base.textTheme).apply(
        bodyColor: AppColors.offWhite,
        displayColor: AppColors.offWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.offWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.exo2(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.offWhite,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF0A1A2E),
        selectedItemColor: accent,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.exo2(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF12253A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.grey),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF0F2035),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
    );
  }
}

class CopyKit {
  final GenderKit kit;
  const CopyKit(this.kit);

  bool get isBoy => kit == GenderKit.boy;

  String get hello => isBoy ? 'Fala, campeão!' : 'Fala, craque!';
  String get awesome => isBoy ? 'Mandou muito!' : 'Arrasou!';
  String get next => isBoy ? 'Partiu próxima!' : 'Bora brilhar!';
  String get almost => isBoy ? 'Quase lá, tenta de novo!' : 'Quase! Você chega lá!';
  String get correct => isBoy ? 'Fechou! Mandou a real!' : 'Isso! Arrasou no raciocínio!';
  String get wrong => isBoy ? 'Ops, não foi dessa vez.' : 'Eita, essa escapou.';
  String get focusWarn => isBoy
      ? 'Eita, voltou pro treino — se sair de novo essa questão zera!'
      : 'Ei, foco! Se sair de novo essa questão zera, tá?';
  String get dailyDone => isBoy ? 'Tarefa do dia no bolso!' : 'Tarefa do dia brilhando!';
  String get studyCta => isBoy ? 'Bora estudar!' : 'Vamos aprender!';
}
