import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_de_presentes/common/widgets/standard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  Duration _timeLeft = const Duration();

  final DateTime weddingDate = DateTime(2025, 10, 11, 20, 0);

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

    return '$days   :   $hours   :   $minutes   :   $seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 243, 222),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/aliança.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Queridos convidados,',
                  style: GoogleFonts.cormorantSc(
                    color: Color.fromARGB(255, 39, 93, 80),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sabemos que o maior presente é ter vocês conosco neste dia tão especial — e, de coração, não esperamos nada além da presença, do carinho e das orações de cada um.\n'
                  'Mas também entendemos que presentear é uma forma bonita e tradicional de demonstrar amor. Por isso, caso sintam-se tocados a nos abençoar dessa forma, criamos uma lista simbólica com algumas sugestões.\n'
                  'Os itens aparecem como objetos (como geladeira, sofá, entre outros), mas, na prática, os valores correspondentes serão enviados via Pix, diretamente a nós, e usados conforme as necessidades e sonhos da nossa nova caminhada juntos.\n',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.cormorantSc(
                    color: Color.fromARGB(255, 39, 93, 80),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Com gratidão e muito carinho,',
                  style: GoogleFonts.cormorantSc(
                    color: Color.fromARGB(255, 39, 93, 80),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Wesley e  Jenifer',
                  style: GoogleFonts.italianno(
                    color: Color.fromARGB(255, 200, 81, 3),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 39, 93, 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final standardScreenState =
                          context
                              .findAncestorStateOfType<StandardScreenState>();
                      if (standardScreenState != null) {
                        standardScreenState.changePage(1, fromDrawer: false);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StandardScreen(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Presentear',
                      style: GoogleFonts.cormorantSc(
                        color: Color.fromARGB(255, 253, 243, 222),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'Falta pouco para o grande dia!',
                    style: GoogleFonts.cormorantSc(
                      color: Color.fromARGB(255, 253, 243, 222),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 175),
                  Text(
                    _formatDuration(_timeLeft),
                    style: GoogleFonts.rajdhani(
                      color: Color.fromARGB(255, 253, 243, 222),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '           DIAS                  HORAS            MINUTOS        SEGUNDOS  ',
                    style: GoogleFonts.cormorantSc(
                      color: Color.fromARGB(255, 253, 243, 222),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
