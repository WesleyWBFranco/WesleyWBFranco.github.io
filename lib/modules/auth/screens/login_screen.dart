import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_de_presentes/common/forgot_pw_screen.dart';
import 'package:lista_de_presentes/helper/helper_function.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;

  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 243, 222),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/presente.png',
                color: Color.fromARGB(255, 39, 93, 80),
                width: 130,
              ),
              const SizedBox(height: 10),
              Text(
                'LOGIN',
                style: GoogleFonts.cormorantSc(
                  color: Color.fromARGB(255, 39, 93, 80),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
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

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.cormorantSc(
                          color: const Color.fromARGB(255, 39, 93, 80),
                          fontWeight: FontWeight.w700,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color.fromARGB(255, 39, 93, 80),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 39, 93, 80),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 39, 93, 80),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: GoogleFonts.cormorantSc(
                          color: const Color.fromARGB(255, 39, 93, 80),
                          fontWeight: FontWeight.w700,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 39, 93, 80),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 39, 93, 80),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 39, 93, 80),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 93, 80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: login,
                        child: Text(
                          'Entrar',
                          style: GoogleFonts.cormorantSc(
                            color: Color.fromARGB(255, 253, 243, 222),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPasswordPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: GoogleFonts.cormorantSc(
                              color: Color.fromARGB(255, 39, 93, 80),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Para primeiro acesso, crie sua conta clicando no botão abaixo:',
                    style: GoogleFonts.cormorantSc(
                      color: Color.fromARGB(255, 39, 93, 80),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Cadastre-se',
                      style: GoogleFonts.cormorantSc(
                        color: Color.fromARGB(255, 39, 93, 80),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
