import 'dart:ui';

import 'package:flutter/material.dart';

class SegmentoEmTresPontosPainter extends CustomPainter {
  ///Lista de pontos principais, os três pontos os quais seram ligados.
  final List<Offset> pontosPrincipais;

  ///Lista de pontos intermediários, os quais ligam os pontos principais.
  final List<Offset> pontosIntermediarios;

  ///Lista de cores atribuídas aos pontos principais.
  final List<Color> coresPrincipais;

  ///Cor padrão atribuída àos pontos intermediários.
  final corPontosIntermediarios = Paint()
    ..color = Colors.amber
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round;

  SegmentoEmTresPontosPainter(
    this.pontosPrincipais,
    this.pontosIntermediarios,
    this.coresPrincipais, {
    required Listenable repaint,
  }) : super(repaint: repaint);

  ///Função chamada automaticamente ao atualizarmos o valor da variável _update
  ///mencionada anteriormente.
  @override
  void paint(Canvas canvas, Size size) {
    //No flutter, a coordenada (0,0) inicia no canto superior esquerdo, logo,
    //isso é feito para podermos trabalhar com o padrão que já utilizamos,
    //com a coordenada (0,0) sendo no canto inferior esquerdo.
    canvas.translate(0, size.height);
    canvas.scale(1, -1);

    //Desenha cada ponto principal com as cores especificadas e com a largura 15.
    for (int i = 0; i < pontosPrincipais.length; i++) {
      final cor = Paint()
        ..color = coresPrincipais[i]
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round;

      final ponto = [pontosPrincipais[i]];
      canvas.drawPoints(PointMode.points, ponto, cor);
    }

    if (pontosIntermediarios.isNotEmpty) {
      //Desenha cada ponto intermediário com a cor âmbar e com a largura 5.
      for (int i = 0; i < pontosIntermediarios.length; i++) {
        final ponto = [pontosIntermediarios[i]];
        canvas.drawPoints(PointMode.points, ponto, corPontosIntermediarios);
      }
    }
  }

  @override
  bool shouldRepaint(SegmentoEmTresPontosPainter oldDelegate) => true;
}
