import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Quiz> perguntas = [];
  int selecionado = -1;
  int perguntaAtual = 0;

  @override
  void initState() {
    super.initState();
    carregarQuiz();
  }

  Future<void> carregarQuiz() async {
    final String response =
        await rootBundle.loadString('assets/mokup/quiz.json');
    final data = json.decode(response);

    setState(() {
      perguntas = data.map<Quiz>((e) => Quiz.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (perguntas.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = perguntas[perguntaAtual];

    return Scaffold(
      backgroundColor: const Color(0xFFE6E3C2),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 181),
        title: const Text("Vigiar e Punir"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              "Questão nº ${perguntaAtual + 1}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(q.imagem),
            ),

            const SizedBox(height: 20),

            Text(
              q.pergunta,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ...List.generate(q.alternativas.length, (index) {
              return RadioListTile(
                title: Text(q.alternativas[index]),
                value: index,
                groupValue: selecionado,
                onChanged: (value) {
                  setState(() {
                    selecionado = value!;
                  });
                },
              );
            }),

            const SizedBox(height: 20),

            
            ElevatedButton(
              onPressed: () {
                if (selecionado == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selecione uma resposta")),
                  );
                  return;
                }

                if (selecionado == q.respostaCorreta) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Resposta correta!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Resposta errada!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAD7B5),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text("Responder"),
              ),
            ),

            const SizedBox(height: 10),

            
            ElevatedButton(
              onPressed: () {
                if (selecionado == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Responda antes de avançar")),
                  );
                  return;
                }

                if (perguntaAtual < perguntas.length - 1) {
                  setState(() {
                    perguntaAtual++;
                    selecionado = -1;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fim do quiz!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAD7B5),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text("Próxima questão"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}