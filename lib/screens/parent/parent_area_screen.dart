import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/profile.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class ParentAreaScreen extends StatefulWidget {
  const ParentAreaScreen({super.key});

  @override
  State<ParentAreaScreen> createState() => _ParentAreaScreenState();
}

class _ParentAreaScreenState extends State<ParentAreaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabs;
  final capCtrl = TextEditingController();
  List<Map<String, Object?>> focusEvents = [];
  List<Map<String, Object?>> progress = [];

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 4, vsync: this);
    final state = context.read<AppState>();
    capCtrl.text = state.budget.capReais.toStringAsFixed(2);
    _loadExtras();
  }

  Future<void> _loadExtras() async {
    final state = context.read<AppState>();
    focusEvents = await state.focusEvents();
    progress = await state.progressRows();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    tabs.dispose();
    capCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    final state = context.read<AppState>();
    final reais = double.tryParse(capCtrl.text.replaceAll(',', '.')) ?? 30;
    await state.updateBudget(
      state.budget.copyWith(monthlyCapI9: (reais * 100).round()),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Orçamento atualizado.')),
    );
  }

  Future<void> _redeem() async {
    final state = context.read<AppState>();
    if (state.wallet.balance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo zerado.')),
      );
      return;
    }
    final pinCtrl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar troca física'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pagar R\$ ${state.wallet.balanceReais.toStringAsFixed(2)} '
              '(${state.wallet.balance} I9\$) em dinheiro físico?',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinCtrl,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Confirme o PIN',
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirmar')),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final pinOk = await state.validatePin(pinCtrl.text);
    if (!mounted) return;
    if (!pinOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN incorreto.')),
      );
      return;
    }
    final amount = await state.redeemBalance();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Troca registrada: $amount I9\$ '
          '(R\$ ${(amount / 100).toStringAsFixed(2)}).',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final p = state.profile!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Responsável'),
        bottom: TabBar(
          controller: tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Controle'),
            Tab(text: 'Orçamento'),
            Tab(text: 'Relatório'),
            Tab(text: 'Troca'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabs,
        children: [
          _ControlTab(profile: p, state: state),
          _BudgetTab(
            state: state,
            capCtrl: capCtrl,
            onSave: _saveBudget,
          ),
          _ReportTab(
            state: state,
            focusEvents: focusEvents,
            progress: progress,
          ),
          _RedeemTab(state: state, onRedeem: _redeem),
        ],
      ),
    );
  }
}

class _ControlTab extends StatelessWidget {
  final Profile profile;
  final AppState state;
  const _ControlTab({required this.profile, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Gênero do aluno',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(
          children: [
            ChoiceChip(
              label: const Text('Menino'),
              selected: profile.gender == 'boy',
              onSelected: (_) async {
                await state.updateProfile(profile.copyWith(gender: 'boy'));
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Menina'),
              selected: profile.gender == 'girl',
              onSelected: (_) async {
                await state.updateProfile(profile.copyWith(gender: 'girl'));
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Série máxima (ensino e questões)',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        Slider(
          value: profile.maxGrade.toDouble(),
          min: 1,
          max: 9,
          divisions: 8,
          label: '${profile.maxGrade}º ano',
          onChanged: (v) async {
            await state.updateProfile(profile.copyWith(maxGrade: v.round()));
          },
        ),
        Text('${profile.maxGrade}º ano',
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 20),
        Text('Ano foco (questões do aluno)',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          '75% das perguntas vêm deste ano. Os outros 25% vêm de anos abaixo. '
          'Do 5º ao 9º, o bloco de 75% prioriza contas e problemas (+ − × ÷).',
          style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 13, height: 1.35),
        ),
        const SizedBox(height: 8),
        if (profile.maxGrade <= 1)
          Text(
            'Só o 1º ano está liberado — 100% das questões deste ano.',
            style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 13),
          )
        else
          Slider(
            value: profile.clampedFocusGrade.toDouble(),
            min: 1,
            max: profile.maxGrade.toDouble(),
            divisions: profile.maxGrade - 1,
            label: '${profile.clampedFocusGrade}º ano',
            onChanged: (v) async {
              await state.updateProfile(
                profile.copyWith(focusGrade: v.round()),
              );
            },
          ),
        Text('${profile.clampedFocusGrade}º ano',
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 20),
        Text('Modo Foco',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        SwitchListTile(
          title: const Text('Ativo na Prova'),
          value: state.focus.enabledOnTest,
          onChanged: (v) =>
              state.updateFocus(state.focus.copyWith(enabledOnTest: v)),
        ),
        SwitchListTile(
          title: const Text('Ativo no Desafio'),
          value: state.focus.enabledOnChallenge,
          onChanged: (v) =>
              state.updateFocus(state.focus.copyWith(enabledOnChallenge: v)),
        ),
        SwitchListTile(
          title: const Text('Zerar prova inteira se sair'),
          subtitle: const Text('Mais rígido: qualquer saída anula a sessão'),
          value: state.focus.voidWholeTestOnExit,
          onChanged: (v) => state
              .updateFocus(state.focus.copyWith(voidWholeTestOnExit: v)),
        ),
        const SizedBox(height: 12),
        GradientCard(
          child: Text(
            'Dica Android: use App Fixado. No desktop, combine tela cheia. '
            'O app detecta saída e registra no relatório.',
            style: GoogleFonts.exo2(color: AppColors.grey, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _BudgetTab extends StatelessWidget {
  final AppState state;
  final TextEditingController capCtrl;
  final VoidCallback onSave;

  const _BudgetTab({
    required this.state,
    required this.capCtrl,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final b = state.budget;
    final days = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: capCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Teto mensal (R\$)',
            prefixText: 'R\$ ',
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onSave, child: const Text('Salvar teto')),
        const SizedBox(height: 20),
        Text('Divisão do orçamento',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        _PctSlider(
          label: 'Tarefas diárias (${b.pctDaily}%)',
          value: b.pctDaily,
          onChanged: (v) {
            final rest = 100 - v;
            final extras = (rest * b.pctExtras / (b.pctExtras + b.pctMonthBonus))
                .round()
                .clamp(0, rest);
            state.updateBudget(b.copyWith(
              pctDaily: v,
              pctExtras: extras,
              pctMonthBonus: rest - extras,
            ));
          },
        ),
        Text(
          'Fatia do dia ≈ ${b.dailySlice(days)} I9\$ '
          '(R\$ ${(b.dailySlice(days) / 100).toStringAsFixed(2)})',
          style: GoogleFonts.exo2(color: AppColors.grey),
        ),
        const SizedBox(height: 8),
        Text('Extras quiz/desafio/prova: ${b.pctExtras}% '
            '(${b.extrasPool} I9\$)',
            style: GoogleFonts.exo2()),
        Text('Bônus mês completo: ${b.pctMonthBonus}% '
            '(${b.monthBonusPool} I9\$)',
            style: GoogleFonts.exo2()),
        const SizedBox(height: 16),
        Text('Calendário do mês',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        MonthDayDots(
          completedDays: state.completedDays,
          accent: state.theme.accent,
        ),
        const SizedBox(height: 12),
        Text(
          'Distribuídos: ${state.earnedThisMonth}/${b.monthlyCapI9} I9\$',
          style: GoogleFonts.exo2(color: AppColors.cyan),
        ),
      ],
    );
  }
}

class _PctSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _PctSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.exo2()),
        Slider(
          value: value.toDouble(),
          min: 20,
          max: 70,
          divisions: 10,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

class _ReportTab extends StatelessWidget {
  final AppState state;
  final List<Map<String, Object?>> focusEvents;
  final List<Map<String, Object?>> progress;

  const _ReportTab({
    required this.state,
    required this.focusEvents,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM HH:mm');
    final strong = progress.where((p) {
      final a = p['total_attempts'] as int? ?? 0;
      final c = p['correct'] as int? ?? 0;
      return a > 0 && c / a >= 0.7;
    }).length;
    final weak = progress.where((p) {
      final a = p['total_attempts'] as int? ?? 0;
      final c = p['correct'] as int? ?? 0;
      return a > 0 && c / a < 0.5;
    }).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resumo',
                  style: GoogleFonts.exo2(fontWeight: FontWeight.w800)),
              Text('Tópicos fortes: $strong · Fracos: $weak',
                  style: GoogleFonts.exo2(color: AppColors.grey)),
              Text('Streak atual: ${state.currentStreak}',
                  style: GoogleFonts.exo2(color: AppColors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      const labels = ['Diário', 'Extra', 'Bônus'];
                      final i = v.toInt();
                      if (i < 0 || i > 2) return const SizedBox.shrink();
                      return Text(labels[i],
                          style: GoogleFonts.exo2(fontSize: 11));
                    },
                  ),
                ),
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(
                    toY: state.budget.pctDaily.toDouble(),
                    color: AppColors.cyan,
                  ),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(
                    toY: state.budget.pctExtras.toDouble(),
                    color: AppColors.blue,
                  ),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(
                    toY: state.budget.pctMonthBonus.toDouble(),
                    color: state.theme.accent,
                  ),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Saídas do app (Modo Foco)',
            style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
        if (focusEvents.isEmpty)
          Text('Nenhuma saída registrada.',
              style: GoogleFonts.exo2(color: AppColors.grey))
        else
          ...focusEvents.map((e) {
            final when =
                DateTime.tryParse(e['exited_at'] as String? ?? '') ??
                    DateTime.now();
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${e['mode']} · ${e['action_taken']}',
                  style: GoogleFonts.exo2(fontWeight: FontWeight.w600)),
              subtitle: Text(fmt.format(when),
                  style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 12)),
            );
          }),
      ],
    );
  }
}

class _RedeemTab extends StatelessWidget {
  final AppState state;
  final VoidCallback onRedeem;

  const _RedeemTab({required this.state, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientCard(
            color: AppColors.coin.withValues(alpha: 0.15),
            child: Column(
              children: [
                Text('${state.wallet.balance} I9\$',
                    style: GoogleFonts.exo2(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.coin)),
                Text(
                  'Equivalente: R\$ ${state.wallet.balanceReais.toStringAsFixed(2)}',
                  style: GoogleFonts.exo2(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Entregue o valor em dinheiro físico ao aluno e confirme abaixo. '
            'O saldo resgatável será zerado e o histórico registrado.',
            style: GoogleFonts.exo2(height: 1.4, color: AppColors.grey),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onRedeem,
            icon: const Icon(Icons.payments_rounded),
            label: const Text('Confirmar troca física'),
          ),
        ],
      ),
    );
  }
}
