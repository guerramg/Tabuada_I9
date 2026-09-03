import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/screens/parent/parent_area_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openParent(BuildContext context) async {
    final pinCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Área do Responsável'),
        content: TextField(
          controller: pinCtrl,
          obscureText: true,
          maxLength: 4,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'PIN de 4 dígitos',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Entrar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final valid = await context.read<AppState>().validatePin(pinCtrl.text);
    if (!context.mounted) return;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN incorreto.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ParentAreaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final p = state.profile;

    return CircuitBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Perfil',
                style: GoogleFonts.exo2(
                    fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            GradientCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: state.theme.accent,
                    child: Text(
                      p?.isBoy == false ? '👧' : '👦',
                      style: const TextStyle(fontSize: 34),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(p?.name ?? '-',
                      style: GoogleFonts.exo2(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  Text(
                    'Kit ${p?.isBoy == false ? 'Estrela' : 'Aventura'} · '
                    'até ${p?.maxGrade ?? '-'}º ano',
                    style: GoogleFonts.exo2(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Streak: ${state.currentStreak} dias '
                      '(recorde ${state.bestStreak})',
                      style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Conquistas: '
                      '${state.achievements.where((a) => a.unlocked).length}/'
                      '${state.achievements.length}',
                      style: GoogleFonts.exo2(color: AppColors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openParent(context),
              icon: const Icon(Icons.lock_rounded),
              label: const Text('Área do Responsável'),
            ),
            const SizedBox(height: 20),
            Text(
              'um app i9 · Mathi9 Kids',
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
