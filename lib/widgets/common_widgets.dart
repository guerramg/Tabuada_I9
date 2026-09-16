import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/theme/app_theme.dart';

class CoinCounter extends StatelessWidget {
  final int balance;
  final bool compact;

  const CoinCounter({super.key, required this.balance, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: palette.inputFill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.coin.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            '$balance I9\$',
            style: GoogleFonts.exo2(
              fontWeight: FontWeight.w700,
              color: AppColors.coin,
              fontSize: compact ? 13 : 15,
            ),
          ),
        ],
      ),
    );
  }
}

class StreakBadge extends StatelessWidget {
  final int streak;
  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.inputFill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: GoogleFonts.exo2(
              fontWeight: FontWeight.w700,
              color: AppColors.offWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class MonthDayDots extends StatelessWidget {
  final Set<String> completedDays;
  final Color accent;

  const MonthDayDots({
    super.key,
    required this.completedDays,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final now = DateTime.now();
    final days = DateTime(now.year, now.month + 1, 0).day;
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(days, (i) {
        final day = i + 1;
        final key =
            '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        final done = completedDays.contains(key);
        final isToday = day == now.day;
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? accent : AppColors.grey.withValues(alpha: 0.35),
            border: isToday ? Border.all(color: palette.secondary, width: 1.5) : null,
          ),
        );
      }),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? palette.card,
            palette.cardAlt,
          ],
        ),
        border: Border.all(color: palette.border),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: card,
    );
  }
}

class StarRating extends StatelessWidget {
  final int stars;
  const StarRating({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Text(
          i < stars ? '⭐' : '☆',
          style: const TextStyle(fontSize: 16),
        );
      }),
    );
  }
}

class CircuitBackground extends StatelessWidget {
  final Widget child;
  const CircuitBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return CustomPaint(
      painter: _CircuitPainter(
        line: palette.circuit,
        node: palette.secondary.withValues(alpha: 0.4),
      ),
      child: child,
    );
  }
}

class _CircuitPainter extends CustomPainter {
  final Color line;
  final Color node;
  const _CircuitPainter({required this.line, required this.node});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = line
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final paths = <Path>[
      Path()
        ..moveTo(0, size.height * 0.2)
        ..lineTo(size.width * 0.25, size.height * 0.2)
        ..lineTo(size.width * 0.25, size.height * 0.45)
        ..lineTo(size.width * 0.55, size.height * 0.45),
      Path()
        ..moveTo(size.width, size.height * 0.7)
        ..lineTo(size.width * 0.7, size.height * 0.7)
        ..lineTo(size.width * 0.7, size.height * 0.35)
        ..lineTo(size.width * 0.4, size.height * 0.35),
      Path()
        ..moveTo(size.width * 0.1, size.height)
        ..lineTo(size.width * 0.1, size.height * 0.6)
        ..lineTo(size.width * 0.35, size.height * 0.6),
    ];

    for (final path in paths) {
      canvas.drawPath(path, paint);
    }

    final nodePaint = Paint()
      ..color = node
      ..style = PaintingStyle.fill;
    for (final offset in [
      Offset(size.width * 0.25, size.height * 0.2),
      Offset(size.width * 0.55, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.7),
      Offset(size.width * 0.1, size.height * 0.6),
    ]) {
      canvas.drawCircle(offset, 3.5, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircuitPainter oldDelegate) =>
      oldDelegate.line != line || oldDelegate.node != node;
}
