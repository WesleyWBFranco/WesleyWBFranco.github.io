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
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.cormorantSc(
                      color: Color.fromARGB(255, 39, 93, 80),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '    ',
                      ), // Indentação do primeiro parágrafo
                      TextSpan(
                        text:
                            'Queremos começar dizendo que sua presença no nosso casamento já é, de verdade, um presente imenso para nós.\n\n',
                      ),
                      TextSpan(text: '    '), // Indentação do segundo parágrafo
                      TextSpan(
                        text:
                            'Sabemos que dar um presente é uma forma especial de demonstrar carinho — e, para quem desejar nos abençoar dessa forma, preparamos uma lista simbólica. Os itens aparecem como “sofá”, “geladeira”, entre outros, mas na verdade representam valores que serão enviados via Pix e utilizados conforme nossas necessidades nesta nova fase.\n\n',
                      ),
                      TextSpan(
                        text: '    ',
                      ), // Indentação do terceiro parágrafo
                      TextSpan(
                        text:
                            'Optamos por esse formato porque, no momento, ainda não temos uma casa definitiva e moramos em Curitiba. Como a celebração será em outra cidade, não temos como transportar presentes físicos de volta conosco, o que tornaria difícil aproveitá-los da melhor forma nesse momento.\n\n',
                      ),
                      TextSpan(text: '    '), // Indentação do quarto parágrafo
                      TextSpan(
                        text:
                            'Se você se sentir à vontade para participar, será uma alegria. Mas, acima de tudo, o que realmente importa para nós é poder celebrar esse dia ao lado de pessoas especiais como você.\n\n',
                      ),
                      TextSpan(text: '    '), // Indentação da observação
                      TextSpan(
                        text:
                            'Obs: Os valores são sugestões, fique à vontade para presentear com o valor que achar melhor.\n',
                      ),
                    ],
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
                  const SizedBox(height: 155),
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
