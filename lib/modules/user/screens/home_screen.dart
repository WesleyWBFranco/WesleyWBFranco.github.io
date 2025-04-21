import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  Duration _timeLeft = const Duration();

  final DateTime weddingDate = DateTime(2025, 10, 11, 17, 0);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timeLeft = weddingDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft = weddingDate.difference(DateTime.now());
        if (_timeLeft.isNegative) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return '$days dias, $hours h, $minutes min, $seconds s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 243, 222),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/wedding.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Falta pouco para o grande dia!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 39, 93, 80),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDuration(_timeLeft),
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 39, 93, 80),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'O maior presente que poderíamos receber é a sua presença no nosso grande dia.\n\n'
              'Sabemos que é tradição presentear os noivos, então montamos uma lista com muito carinho — não como uma obrigação, mas como uma sugestão para quem quiser nos mimar nesse momento especial.\n\n'
              'Como estamos em um momento de praticidade, não teremos como receber os presentes fisicamente. Por isso, adaptamos nossa lista: você escolhe o item, mas a entrega será feita por Pix.\n\n'
              'Mesmo que não usemos exatamente o valor para aquele item, tudo será utilizado com muito amor para construir nossa vida juntos.\n\n'
              'Obrigado por fazer parte disso com a gente! ❤️',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 39, 93, 80),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 93, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/shop');
                },
                child: const Text(
                  'Ver lista de presentes',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 253, 243, 222),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
