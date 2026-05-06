class Quiz {
  final int id;
  final String pergunta;
  final String imagem;
  final List<String> alternativas;
  final int respostaCorreta;

  Quiz({
    required this.id,
    required this.pergunta,
    required this.imagem,
    required this.alternativas,
    required this.respostaCorreta,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      pergunta: json['pergunta'],
      imagem: json['imagem'],
      alternativas: List<String>.from(json['alternativas']),
      respostaCorreta: json['respostaCorreta'],
    );
  }
}