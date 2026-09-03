import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/screens/achievements/achievements_screen.dart';
import 'package:tabuadai9/screens/home/home_tab.dart';
import 'package:tabuadai9/screens/profile/profile_screen.dart';
import 'package:tabuadai9/screens/study/subject_map_screen.dart';
import 'package:tabuadai9/screens/wallet/wallet_screen.dart';
import 'package:tabuadai9/services/app_state.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pages = [
      const HomeTab(),
      const SubjectMapScreen(),
      const WalletScreen(),
      const ProfileScreen(),
    ];

    return Theme(
      data: state.theme.material,
      child: Scaffold(
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.school_rounded), label: 'Estudar'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_rounded),
                label: 'Carteira'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Perfil'),
          ],
        ),
        floatingActionButton: index == 3
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AchievementsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.emoji_events_rounded),
                label: const Text('Conquistas'),
              )
            : null,
      ),
    );
  }
}
