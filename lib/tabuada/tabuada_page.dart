import 'package:flutter/material.dart';

class TabuadaPage extends StatefulWidget {
  const TabuadaPage({super.key});

  @override
  State<TabuadaPage> createState() => _TabuadaPageState();
}

class _TabuadaPageState extends State<TabuadaPage> {
  final formKey = GlobalKey<FormState>();
  final _tabuadaController = TextEditingController();

  int tabuada = 0;

  @override
  void dispose() {
    _tabuadaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formKey,
      
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    controller: _tabuadaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tabuada 1:',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Valor de 3 dígitos obrigatório';
                      }
                      int? tabuada = int.tryParse(_tabuadaController.text);
                      if (tabuada.runtimeType != int) {
                        return 'Aceito apenas valores numéricos';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var formValid = formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        setState(() {
                          tabuada = int.parse(_tabuadaController.text);
                          // GerarTabuada(numero: tabuada!).calcularTabuada();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff042a49),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text('Gerar Tabuada'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                if(tabuada != 0)
                  for (var i = 0; i <= 20; i++)
                  ListTile(
                    title: Text('$tabuada x $i',
                            style: TextStyle(fontSize: 20),
                            ),
                    subtitle: Text('Resultado: ${tabuada * i}',
                             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                             
                            ),
                    trailing: Icon(Icons.numbers, color: Colors.green,
                  ),
                  )
                  
                // print("$numero x $i = ${numero * i}
              ],
            ),
          ],
        ),
      ),
    );
  }
}
