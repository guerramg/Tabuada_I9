import 'dart:math';

import 'package:flutter/material.dart';

class ExercicioPage extends StatefulWidget {
  const ExercicioPage({super.key});

  @override
  State<ExercicioPage> createState() => _ExercicioPageState();
}

class _ExercicioPageState extends State<ExercicioPage> {
  final formKey = GlobalKey<FormState>();
  final resposta = TextEditingController();
  var num1 = 0;
  var num2 = 0;

  void gerarConta() {
    int number1 = Random().nextInt(11) + 1;
    int number2 = Random().nextInt(11) + 1;
    setState(() {
      num1 = number1;
      num2 = number2;
    });
  }
  void verificarResposta() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (num1 * num2 == int.parse(resposta.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resposta correta!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resposta incorreta!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    resposta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff042a49),
              ),
              child: Center(
                child: Text(
                  '${num1} x ${num2} = ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff042a49),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                gerarConta();
              },
              child: Text('Gerar Calculo'),
            ),
            SizedBox(height: 70),
            Form(
              key: formKey,
              child: TextFormField(
                controller: resposta,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Resposta:',
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff042a49),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                verificarResposta();
              },
              child: Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}
