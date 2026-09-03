import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _capCtrl = TextEditingController(text: '30');
  String _gender = 'boy';
  int _maxGrade = 5;
  int _step = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _capCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final name = _nameCtrl.text.trim();
    final pin = _pinCtrl.text.trim();
    final capReais = double.tryParse(_capCtrl.text.replaceAll(',', '.')) ?? 30;
    if (name.isEmpty || pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome e PIN de 4 dígitos.')),
      );
      return;
    }
    final state = context.read<AppState>();
    await state.createProfile(
      name: name,
      gender: _gender,
      pin: pin,
      maxGrade: _maxGrade,
      monthlyCapI9: (capReais * 100).round(),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircuitBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bora configurar o Mathi9 Kids',
                  style: GoogleFonts.exo2(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Passo ${_step + 1} de 3',
                  style: GoogleFonts.exo2(color: AppColors.cyan),
                ),
                const SizedBox(height: 24),
                Expanded(child: _buildStep()),
                Row(
                  children: [
                    if (_step > 0)
                      TextButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('Voltar'),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_step < 2) {
                          setState(() => _step++);
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_step < 2 ? 'Continuar' : 'Começar!'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome do aluno',
                hintText: 'Ex.: Rafa',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            Text('Gênero (visual e conversa)',
                style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _GenderCard(
                    selected: _gender == 'boy',
                    title: 'Menino',
                    subtitle: 'Kit Aventura',
                    color: AppColors.adventureOrange,
                    onTap: () => setState(() => _gender = 'boy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderCard(
                    selected: _gender == 'girl',
                    title: 'Menina',
                    subtitle: 'Kit Estrela',
                    color: AppColors.starPink,
                    onTap: () => setState(() => _gender = 'girl'),
                  ),
                ),
              ],
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Até qual série liberar?',
                style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('O app ensina do 1º até esta série (BNCC).',
                style: GoogleFonts.exo2(color: AppColors.grey)),
            Slider(
              value: _maxGrade.toDouble(),
              min: 1,
              max: 9,
              divisions: 8,
              label: '$_maxGradeº ano',
              activeColor: AppColors.cyan,
              onChanged: (v) => setState(() => _maxGrade = v.round()),
            ),
            Text('$_maxGradeº ano',
                textAlign: TextAlign.center,
                style: GoogleFonts.exo2(
                    fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),
            TextField(
              controller: _capCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Teto mensal em R\$',
                hintText: '30.00',
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '1 I9\$ = R\$ 0,01. O aluno nunca ganha acima deste teto no mês.',
              style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 13),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('PIN do responsável (4 dígitos)',
                style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Protege o painel: teto, série, gênero, troca de I9\$ e relatório.',
              style: GoogleFonts.exo2(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'PIN',
                counterText: '',
              ),
            ),
            const Spacer(),
            GradientCard(
              child: Text(
                'Dica: combine em casa que a troca do dinheiro é física, com o responsável confirmando no painel.',
                style: GoogleFonts.exo2(height: 1.4),
              ),
            ),
          ],
        );
    }
  }
}

class _GenderCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _GenderCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      onTap: onTap,
      color: selected ? color.withValues(alpha: 0.25) : null,
      child: Column(
        children: [
          Icon(selected ? Icons.check_circle : Icons.circle_outlined,
              color: color),
          const SizedBox(height: 8),
          Text(title,
              style: GoogleFonts.exo2(fontWeight: FontWeight.w800, fontSize: 16)),
          Text(subtitle, style: GoogleFonts.exo2(color: AppColors.grey)),
        ],
      ),
    );
  }
}
