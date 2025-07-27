import 'cartaModel.dart';

class Gioco {
  final List<List<Carta?>> tavolo = List.generate(
    4,
    (_) => List.filled(9, null),
  );
  final List<Carta?> mazzoEsterno = List.filled(4, null);
  final List<Carta> reScartatiLista = [];
  final List<Seme?> semiPerRiga = List.filled(4, null);
  bool _ultimoScartoEraRe = false;

  Carta? cartaInMano;
  int reScartati = 0;

  Gioco() {
    _inizializza();
  }

  void _inizializza() {
    final carte = List<Carta>.generate(40, (i) => Carta.fromIndex(i));
    carte.shuffle();

    // Tavolo: 4x9 = 36 carte
    for (int i = 0; i < 36; i++) {
      int riga = i ~/ 9;
      int colonna = i % 9;
      tavolo[riga][colonna] = carte[i];
    }

    // Mazzo esterno: 4 carte
    for (int i = 0; i < 4; i++) {
      mazzoEsterno[i] = carte[36 + i];
    }
  }

  bool get ultimoScartoEraRe => _ultimoScartoEraRe;

  bool pescaCarta(int index) {
    if (cartaInMano != null || mazzoEsterno[index] == null) return false;

    final pescata = mazzoEsterno[index]!;
    mazzoEsterno[index] = null;

    if (pescata.valore == 10) {
      pescata.coperta = false;
      _scartaRe(pescata);
      return true;
    }

    pescata.coperta = false;
    cartaInMano = pescata;
    return true;
  }

  bool giocaCartaSuTavolo(int riga, int colonna) {
    if (cartaInMano == null) return false;

    final cartaDaGiocare = cartaInMano!;
    final cartaSostituita = tavolo[riga][colonna];

    // Se la riga non ha seme assegnato
    if (semiPerRiga[riga] == null) {
      // Controlla che il seme della carta non sia già assegnato ad un'altra riga
      if (semiPerRiga.contains(cartaDaGiocare.seme)) {
        // quel seme è già usato in un'altra riga, quindi non puoi assegnarlo qui
        return false;
      }
      // Assegna il seme a questa riga
      semiPerRiga[riga] = cartaDaGiocare.seme;
    } else {
      // La riga ha già un seme assegnato, quindi la carta deve avere lo stesso seme
      if (semiPerRiga[riga] != cartaDaGiocare.seme) {
        return false;
      }
    }

    // Controlla la colonna (valore-1)
    if (colonna != cartaDaGiocare.valore - 1) {
      return false;
    }

    // Posiziona la carta
    tavolo[riga][colonna] = cartaDaGiocare.copyWith(coperta: false);

    // Gestione carta sostituita
    if (cartaSostituita == null) {
      cartaInMano = null;
      _ultimoScartoEraRe = false;
    } else if (cartaSostituita.valore == 10) {
      _scartaRe(cartaSostituita);
      cartaInMano = null;
      _ultimoScartoEraRe = true;
    } else {
      cartaInMano = cartaSostituita.copyWith(coperta: false);
      _ultimoScartoEraRe = false;
    }

    return true;
  }

  void _scartaRe(Carta re) {
    re.coperta = false;
    reScartati++;
    reScartatiLista.add(re);
  }

  bool vittoria() {
    // Tutte le carte sul tavolo devono essere scoperte e non deve esserci alcun 10 sul tavolo
    for (var riga in tavolo) {
      for (var carta in riga) {
        if (carta == null || carta.coperta || carta.valore == 10) return false;
      }
    }
    // Se siamo arrivati qui, tutte le carte sono scoperte e non ci sono 10
    // E i 4 re devono essere stati scartati (per sicurezza)
    return reScartati == 4;
  }

  bool partitaPersa() {
    // Hai perso se hai scartato tutti e 4 i re ma il tavolo non è completo
    return reScartati == 4 && !vittoria();
  }
}
