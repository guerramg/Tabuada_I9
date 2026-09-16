import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabuadai9/theme/app_colors.dart';

enum GenderKit { boy, girl }

/// Runtime colors that swap the whole chrome: i9 blue (boy) vs pink (girl).
class AppPalette extends ThemeExtension<AppPalette> {
  final Color scaffold;
  final Color surface;
  final Color card;
  final Color cardAlt;
  final Color border;
  final Color circuit;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color inputFill;
  final Color navBar;

  const AppPalette({
    required this.scaffold,
    required this.surface,
    required this.card,
    required this.cardAlt,
    required this.border,
    required this.circuit,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.inputFill,
    required this.navBar,
  });

  factory AppPalette.boy() => AppPalette(
        scaffold: AppColors.navy,
        surface: const Color(0xFF0A1A2E),
        card: const Color(0xFF0F2035),
        cardAlt: const Color(0xFF0A1A2E),
        border: AppColors.blue.withValues(alpha: 0.25),
        circuit: AppColors.cyan.withValues(alpha: 0.12),
        primary: AppColors.blue,
        secondary: AppColors.cyan,
        accent: AppColors.adventureOrange,
        inputFill: const Color(0xFF12253A),
        navBar: const Color(0xFF0A1A2E),
      );

  factory AppPalette.girl() => AppPalette(
        scaffold: AppColors.starNavy,
        surface: AppColors.starSurface,
        card: AppColors.starCard,
        cardAlt: AppColors.starCardAlt,
        border: AppColors.starPink.withValues(alpha: 0.4),
        circuit: AppColors.starPink.withValues(alpha: 0.22),
        primary: AppColors.starPrimary,
        secondary: AppColors.starSecondary,
        accent: AppColors.starPink,
        inputFill: const Color(0xFF3A1528),
        navBar: AppColors.starSurface,
      );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? AppPalette.boy();

  @override
  AppPalette copyWith({
    Color? scaffold,
    Color? surface,
    Color? card,
    Color? cardAlt,
    Color? border,
    Color? circuit,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? inputFill,
    Color? navBar,
  }) =>
      AppPalette(
        scaffold: scaffold ?? this.scaffold,
        surface: surface ?? this.surface,
        card: card ?? this.card,
        cardAlt: cardAlt ?? this.cardAlt,
        border: border ?? this.border,
        circuit: circuit ?? this.circuit,
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        accent: accent ?? this.accent,
        inputFill: inputFill ?? this.inputFill,
        navBar: navBar ?? this.navBar,
      );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardAlt: Color.lerp(cardAlt, other.cardAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      circuit: Color.lerp(circuit, other.circuit, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
    );
  }
}

class AppTheme {
  final GenderKit kit;

  const AppTheme({this.kit = GenderKit.boy});

  bool get isGirl => kit == GenderKit.girl;

  AppPalette get palette => isGirl ? AppPalette.girl() : AppPalette.boy();

  Color get accent =>
      isGirl ? AppColors.starPink : AppColors.adventureOrange;

  Color get accentAlt =>
      isGirl ? AppColors.starLilac : AppColors.adventureGreen;

  Color get accentSoft => isGirl ? AppColors.starGold : AppColors.cyan;

  ThemeData get material {
    final p = palette;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: p.scaffold,
      colorScheme: ColorScheme.dark(
        primary: p.primary,
        secondary: p.secondary,
        tertiary: accent,
        surface: p.surface,
        error: AppColors.danger,
        onPrimary: AppColors.white,
        onSecondary: p.scaffold,
        onSurface: AppColors.offWhite,
      ),
      extensions: [p],
    );

    return base.copyWith(
      textTheme: GoogleFonts.exo2TextTheme(base.textTheme).apply(
        bodyColor: AppColors.offWhite,
        displayColor: AppColors.offWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.scaffold,
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
        backgroundColor: p.navBar,
        selectedItemColor: accent,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.exo2(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: p.secondary,
        thumbColor: p.accent,
        inactiveTrackColor: AppColors.grey.withValues(alpha: 0.4),
      ),
      chipTheme: ChipThemeData(
        selectedColor: p.accent,
        backgroundColor: p.inputFill,
        labelStyle: GoogleFonts.exo2(color: AppColors.offWhite),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.inputFill,
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
          borderSide: BorderSide(color: p.accent, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.grey),
      ),
      cardTheme: CardThemeData(
        color: p.card,
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
