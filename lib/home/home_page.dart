import 'package:flutter/material.dart';
import 'package:tabuadai9/exercicio/exercicio_page.dart';
import 'package:tabuadai9/home/index_page.dart';
import 'package:tabuadai9/tabuada/tabuada_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    var indice = 0;
   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(
            title: Center(
              child: Text('Tabuada i9'),
              ),
            backgroundColor: Color(0xff042a49),
            foregroundColor: Colors.white,
            ),
           bottomNavigationBar: BottomNavigationBar(
            currentIndex: indice,
            onTap: (index){
              setState(() {
                indice = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home
                  ),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list_alt
                  ),
                  label: 'Ver Tabuada'
                  ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calculate
                  ),
                   label: 'Exercício'),
            ]
            ),
            body: IndexedStack(
              index: indice,
              children: [
                IndexPage(),
                TabuadaPage(),
                ExercicioPage()
              ],
            ),
       );
  }
}