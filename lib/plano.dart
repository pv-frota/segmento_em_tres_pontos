import 'package:flutter/material.dart';
import 'package:segmento_em_tres_pontos/custom_painter.dart';

class Plano extends StatefulWidget {
  const Plano({Key? key}) : super(key: key);

  @override
  _PlanoState createState() => _PlanoState();
}

class _PlanoState extends State<Plano> {
  ///Lista de pontos principais, os três pontos os quais seram ligados.
  List<Offset> pontosPrincipais = [];

  ///Lista de pontos intermediários, os quais ligam os pontos principais.
  List<Offset> pontosIntermediarios = [];

  ///Lista de cores atribuídas aos pontos principais.
  List<Color> coresPrincipais = [];

  ///Valor o qual ao ser modificado, notifica a tela para ser atualizada.
  final _update = ValueNotifier<int>(0);

  ///Função para adicionar à lista de pontos principais, os valores x e y,
  ///à serem plotados com a intensidade em RGB indicados por r,g e b
  ///e forçar a aparecem na tela.
  ///OBS: cor desses pontos são automaticamente âmbar (laranja-amarelo).
  void plotarPontoPrincipal(double x, double y, int r, int g, int b) {
    pontosPrincipais.add(Offset(x, y));
    coresPrincipais.add(Color.fromRGBO(r, g, b, 1));
    _update.value++;
  }

  ///Função para adicionar à lista de pontos intermediários, os valores x e y,
  ///à serem plotados pelo algoritmo e forçar a aparecem na tela.
  ///OBS: cor desses pontos são automaticamente âmbar (laranja-amarelo).
  plotarPontoIntermediario(double x, double y) {
    pontosIntermediarios.add(Offset(x, y));
    _update.value++;
  }

  ///Função a qual atribui os pontos a serem ligados e inicia
  ///o algoritmo de Bresenham.
  void iniciarSegmentos() async {
    //Valores (x,y) do primeiro ponto, o qual se ligará com o segundo ponto.
    double x1 = pontosPrincipais[0].dx;
    double y1 = pontosPrincipais[0].dy;
    //Valores (x,y) do segundo ponto, o qual se ligará com o terceiro ponto.
    double x2 = pontosPrincipais[1].dx;
    double y2 = pontosPrincipais[1].dy;
    //Valores (x,y) do terceiro ponto.
    double x3 = pontosPrincipais[2].dx;
    double y3 = pontosPrincipais[2].dy;

    setState(() async {
      //desenhar entre o primeiro e o segundo ponto
      await iniciarAlgoritmoBresenham(x1, y1, x2, y2);
      await Future.delayed(const Duration(seconds: 1));
      //desenhar entre o segundo e o terceiro ponto
      await iniciarAlgoritmoBresenham(x2, y2, x3, y3);
    });
  }

  ///Função a qual a partir de dois pontos, cria uma reta entre eles de acordo
  ///com o Algoritmo de Bresenham.
  Future<void> iniciarAlgoritmoBresenham(double x1, double y1, double x2, double y2) async {
    //Calculando a diferença entre x2 e x1.
    final dx = x2 - x1;
    //Calculando a diferença entre y2 e y1.
    final dy = y2 - y1;
    //Incrementar ou decrementar dependendo se o ponto anterior é maior ou não.
    final xInc = x1 > x2 ? -1 : 1;
    final yInc = y1 > y2 ? -1 : 1;
    dynamic x = x1;
    dynamic y = y1;
    //Caso a diferença de x for maior ou igual a de y, x será a variável
    //independente (incrementada a cada iteração), senão será y.
    if ((dx >= dy)) {
      final dPr = 2 * dy;
      final dPru = (dPr - 2 * dx);
      //Variável de decisão
      dynamic P = dPr - dx;
      //Caso a diferença de x seja positiva, a repetição continuará enquanto x2
      //ser maior que x, senão, enquanto x ser maior que x2.
      while (dx > 0 ? x < x2 : x2 < x) {
        //Operação feita para demonstrar mais facilmente o desenho dos pontos
        //intermediários gerados pelo algoritmo.
        await Future.delayed(const Duration(microseconds: 500));
        plotarPontoIntermediario(x, y);
        if (P > 0) {
          //xInc e yInc positivos, significam seguir em direção oposta a (0,0).
          //xInc e yInc negativos, significam seguir em direção a (0,0).
          P += dPru;
          x += xInc;
          y += yInc;
        } else if (yInc == -1) {
          P += dPr;
          x += xInc;
          y += yInc;
        } else {
          P += dPr;
          x += xInc;
        }
      }
    } else {
      //Caso y seja a variável independente, trocamos os valores de dx e dy nos
      //cálculos.
      final dPr = 2 * dx;
      final dPru = (dPr - 2 * dy);
      dynamic P = dPr - dy;
      while (dy > 0 ? y < y2 : y2 < y) {
        await Future.delayed(const Duration(microseconds: 500));
        plotarPontoIntermediario(x, y);
        if (P > 0) {
          P += dPru;
          x += xInc;
          y += yInc;
        } else if (xInc == -1) {
          P += dPr;
          x += xInc;
          y += yInc;
        } else {
          P += dPr;
          y += yInc;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmento em três pontos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay_sharp),
            onPressed: () => reiniciar(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showAdicionarDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => iniciarSegmentos(),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomPaint(
          painter: SegmentoEmTresPontosPainter(
            pontosPrincipais,
            pontosIntermediarios,
            coresPrincipais,
            repaint: _update,
          ),
          size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height),
        ),
      ),
    );
  }

  void reiniciar() {
    setState(() {
      pontosPrincipais = [];
      pontosIntermediarios = [];
      coresPrincipais = [];
      _update.value++;
    });
  }

  void showAdicionarDialog() {
    double x = 0;
    double y = 0;
    int r = 0;
    int g = 0;
    int b = 0;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Ponto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(label: Text("X")),
                  onChanged: (text) {
                    x = double.parse(text);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Y")),
                  onChanged: (text) {
                    y = double.parse(text);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("R")),
                  onChanged: (text) {
                    r = int.parse(text);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("G")),
                  onChanged: (text) {
                    g = int.parse(text);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("B")),
                  onChanged: (text) {
                    b = int.parse(text);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                setState(() {
                  plotarPontoPrincipal(x, y, r, g, b);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
