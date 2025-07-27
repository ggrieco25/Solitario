import 'cartaModel.dart';

class Mazzo {
  List<Carta> mazzo = [];

  List<Carta> generaMazzo() {
    for (Seme seme in Seme.values) {
      for (int valore = 1; valore <= 10; valore++) {
        mazzo.add(Carta(seme: seme, valore: valore));
      }
    }
    mazzo.shuffle(); // mischia il mazzo
    return mazzo;
  }
}
