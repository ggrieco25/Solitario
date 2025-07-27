import "../models/cartaModel.dart";

String nomeImmagine(Carta carta) {
  if (carta.coperta) return 'lib/assets/0_Retro.jpg';

  int base;
  switch (carta.seme) {
    case Seme.denari:
      base = 1;
      break;
    case Seme.coppe:
      base = 11;
      break;
    case Seme.spade:
      base = 21;
      break;
    case Seme.bastoni:
      base = 31;
      break;
  }

  int numero = base + carta.valore - 1;
  String numeroStr = numero.toString().padLeft(2, '0');

  return 'lib/assets/${numeroStr}_${semeToString(carta.seme)}.jpg';
}

String semeToString(Seme s) {
  switch (s) {
    case Seme.denari:
      return 'denari';
    case Seme.coppe:
      return 'coppe';
    case Seme.spade:
      return 'spade';
    case Seme.bastoni:
      return 'bastoni';
  }
}
