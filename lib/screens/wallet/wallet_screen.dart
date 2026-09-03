import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fmt = DateFormat('dd/MM HH:mm');

    return CircuitBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Carteira I9\$',
              style: GoogleFonts.exo2(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            GradientCard(
              color: AppColors.coin.withValues(alpha: 0.12),
              child: Column(
                children: [
                  Text(
                    '${state.wallet.balance} I9\$',
                    style: GoogleFonts.exo2(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.coin,
                    ),
                  ),
                  Text(
                    '= R\$ ${state.wallet.balanceReais.toStringAsFixed(2)}',
                    style: GoogleFonts.exo2(
                      fontSize: 18,
                      color: AppColors.offWhite,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A troca física é confirmada pelo responsável no painel (PIN).',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.exo2(
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GradientCard(
                    child: Column(
                      children: [
                        Text('Ganhos',
                            style: GoogleFonts.exo2(color: AppColors.grey)),
                        Text('${state.wallet.totalEarned}',
                            style: GoogleFonts.exo2(
                                fontWeight: FontWeight.w800, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientCard(
                    child: Column(
                      children: [
                        Text('Resgatados',
                            style: GoogleFonts.exo2(color: AppColors.grey)),
                        Text('${state.wallet.totalRedeemed}',
                            style: GoogleFonts.exo2(
                                fontWeight: FontWeight.w800, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Extrato',
                style: GoogleFonts.exo2(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (state.transactions.isEmpty)
              Text('Ainda sem movimentos. Bora estudar!',
                  style: GoogleFonts.exo2(color: AppColors.grey))
            else
              ...state.transactions.map((t) {
                final positive = t.amount >= 0;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    positive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: positive ? AppColors.success : AppColors.danger,
                  ),
                  title: Text(t.description,
                      style: GoogleFonts.exo2(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${t.type} · ${fmt.format(t.createdAt)}',
                    style: GoogleFonts.exo2(color: AppColors.grey, fontSize: 12),
                  ),
                  trailing: Text(
                    '${positive ? '+' : ''}${t.amount}',
                    style: GoogleFonts.exo2(
                      fontWeight: FontWeight.w800,
                      color: positive ? AppColors.success : AppColors.danger,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
