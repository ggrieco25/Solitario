enum Seme { coppe, denari, spade, bastoni }

class Carta {
  final Seme seme;
  final int valore;
  bool coperta;

  Carta({required this.seme, required this.valore, this.coperta = true});

  // Metodo copyWith per clonare la carta con proprietà opzionalmente modificate
  Carta copyWith({Seme? seme, int? valore, bool? coperta}) {
    return Carta(
      seme: seme ?? this.seme,
      valore: valore ?? this.valore,
      coperta: coperta ?? this.coperta,
    );
  }

  // Metodo statico per creare una carta da un indice (0-39)
  static Carta fromIndex(int index) {
    int semeIndex = index ~/ 10; // 0-3 (semi)
    int valore = (index % 10) + 1; // valori da 1 a 10
    return Carta(seme: Seme.values[semeIndex], valore: valore, coperta: true);
  }
}
