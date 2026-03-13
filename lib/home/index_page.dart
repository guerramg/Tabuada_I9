import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {

  const IndexPage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Center(
         child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
              color: Colors.white30,
              child: Image.asset('assets/images/einstein.png'),
              ),
              Text('Selecione uma Opção Abaixo',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text('Para Estudar!',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
           ],
         ),
          
       );
  }
}