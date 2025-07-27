import 'package:flutter/material.dart';
import '../models/cartaModel.dart';
import '../models/giocoModel.dart';
import '../utils/cartaUtils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Gioco gioco;

  @override
  void initState() {
    super.initState();
    gioco = Gioco();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double appBarHeight = AppBar().preferredSize.height;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    final double availableBodyHeight =
        screenHeight - appBarHeight - topPadding - bottomPadding;

    const double cardAspectRatio = 1 / 1.4;

    final double totalHorizontalPaddingAndSpacing =
        (12 * 2) + (6 * 2) + (2 * (9 - 1));
    final double maxCardWidth =
        (screenWidth - totalHorizontalPaddingAndSpacing) / 9;
    double desiredCardHeight = maxCardWidth / cardAspectRatio;

    final double requiredTableHeight =
        (desiredCardHeight * 4) + (2 * (4 - 1)) + (6 * 2);

    final double finalTableHeight = (availableBodyHeight * 0.6).clamp(
      200.0,
      400.0,
    );
    desiredCardHeight = (finalTableHeight - (2 * (4 - 1)) - (6 * 2)) / 4;

    final double finalCardWidthGrid = maxCardWidth;
    final double finalCardHeightGrid = desiredCardHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solitario Napoletano'),
        centerTitle: true,
        backgroundColor: const Color(0xFF388E3C),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // Tavolo carte
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF388E3C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              height: finalTableHeight,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 36,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: finalCardWidthGrid / finalCardHeightGrid,
                ),
                itemBuilder: (context, index) {
                  int riga = index ~/ 9;
                  int colonna = index % 9;
                  Carta? carta = gioco.tavolo[riga][colonna];

                  return GestureDetector(
                    onTap: () {
                      if (carta != null) {
                        bool giocata = gioco.giocaCartaSuTavolo(riga, colonna);
                        if (giocata) {
                          setState(() {});
                          if (gioco.ultimoScartoEraRe) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ops.. hai pescato un 10!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          _checkFinePartita();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mossa non valida'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF6E3),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF6D4C41),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: carta != null
                          ? Image.asset(
                              carta.coperta
                                  ? 'lib/assets/0_Retro.jpg'
                                  : nomeImmagine(carta),
                              fit: BoxFit.contain,
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Sezione carta in mano (centrale e più grande)
            Column(
              children: [
                const Text(
                  'Carta in Mano',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                _buildCartaInMano(),
              ],
            ),
            const SizedBox(height: 16),

            // Sezione mazzo esterno e re scartati
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_buildMazzoEsterno(), _buildReScartati()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMazzoEsterno() {
    return Column(
      children: [
        const Text(
          'Mazzo Esterno',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: List.generate(4, (index) {
            Carta? carta = gioco.mazzoEsterno[index];
            return GestureDetector(
              onTap: () {
                int rePrima = gioco.reScartatiLista.length;
                bool success = gioco.pescaCarta(index);
                if (success) {
                  setState(() {});
                  int reDopo = gioco.reScartatiLista.length;
                  if (reDopo > rePrima) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ops.. hai pescato un 10!')),
                    );
                  }
                  _checkFinePartita();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Non puoi pescare ora')),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 48,
                height: 67,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF6E3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF6D4C41),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: carta != null
                    ? Image.asset(nomeImmagine(carta), fit: BoxFit.contain)
                    : const SizedBox.shrink(),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCartaInMano() {
    return Container(
      width: 80,
      height: 104,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6E3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF6D4C41), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: gioco.cartaInMano != null
          ? Image.asset(nomeImmagine(gioco.cartaInMano!), fit: BoxFit.contain)
          : const Text(
              'Nessuna\ncarta',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
    );
  }

  Widget _buildReScartati() {
    return Column(
      children: [
        const Text(
          'Re Scartati',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: List.generate(4, (i) {
            if (i < gioco.reScartatiLista.length) {
              final re = gioco.reScartatiLista[i];
              return Container(
                margin: const EdgeInsets.all(3),
                width: 48,
                height: 67,
                child: Image.asset(nomeImmagine(re), fit: BoxFit.contain),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(3),
                width: 48,
                height: 67,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade400),
                ),
              );
            }
          }),
        ),
      ],
    );
  }

  void _checkFinePartita() {
    if (gioco.vittoria()) {
      _showDialog('Hai vinto!', 'Complimenti, hai completato il gioco!');
    } else if (gioco.partitaPersa()) {
      _showDialog('Hai perso!', 'Hai trovato 4 Re prima di completare.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // chiudo il dialog
              setState(() {
                gioco = Gioco(); // nuova partita
              });
            },
            child: const Text('Nuova partita'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // chiudo il dialog
              Navigator.popUntil(
                context,
                ModalRoute.withName('/'),
              ); // torno alla home
            },
            child: const Text('Torna alla Home'),
          ),
        ],
      ),
    );
  }
}
