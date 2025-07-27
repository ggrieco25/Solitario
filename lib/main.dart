import 'package:flutter/material.dart';
import 'screens/gameScreen.dart';

void main() {
  runApp(const SolitarioApp());
}

class SolitarioApp extends StatelessWidget {
  const SolitarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Carte Napoletane',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDF6E3),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB71C1C)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF388E3C),
          elevation: 6,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB71C1C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showRegoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Regole del Solitario'),
        content: const SingleChildScrollView(
          child: Text(
            'Benvenuto al Solitario con Carte Napoletane!\n\n'
            '1. Il tavolo è formato da 4 righe, ciascuna rappresenta un seme.\n'
            '2. Ci sono 9 colonne per i valori da 1 a 9.\n'
            '3. Il mazzo esterno contiene 4 carte coperte.\n'
            '4. La tua mano contiene 1 carta visibile.\n'
            '5. Quando peschi una carta dal mazzo esterno, puoi posizionarla su una riga, se non è già presente un seme uguale.\n'
            '6. Se peschi un Re (valore 10), lo scarti subito e peschi un\'altra carta.\n'
            '7. Se scarti 4 Re, perdi la partita.\n'
            '8. Vinci se completi tutte le righe senza pescare 4 Re.\n\n'
            'Buona fortuna e buon divertimento!',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Solitario Napoletano')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Solitario Carte Napoletane',
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.rule),
                label: const Text('Regole'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 26,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => _showRegoleDialog(context),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Inizia Partita'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
