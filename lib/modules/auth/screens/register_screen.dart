import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_de_presentes/helper/helper_function.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPwController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future registerUser() async {
    if (passwordConfirmed()) {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        String userRole = 'user';

        addUserDetails(
          nameController.text.trim(),
          emailController.text.trim(),
          userRole,
          userCredential.user!.uid,
        );
      } on FirebaseAuthException catch (e) {
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future addUserDetails(
    String name,
    String email,
    String userRole,
    String uid,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': userRole,
    });
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() == confirmPwController.text.trim()) {
      return true;
    } else {
      return false;
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
                'REGISTRAR',
                style: GoogleFonts.cormorantSc(
                  color: Color.fromARGB(255, 39, 93, 80),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: GoogleFonts.cormorantSc(
                          color: const Color.fromARGB(255, 39, 93, 80),
                          fontWeight: FontWeight.w700,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Color.fromARGB(255, 39, 93, 80),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        border: OutlineInputBorder(
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmPwController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        labelStyle: GoogleFonts.cormorantSc(
                          color: const Color.fromARGB(255, 39, 93, 80),
                          fontWeight: FontWeight.w700,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 39, 93, 80),
                        ),
                        border: OutlineInputBorder(
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
                        onPressed: registerUser,
                        child: Text(
                          'Registrar-se',
                          style: GoogleFonts.cormorantSc(
                            color: Color.fromARGB(255, 253, 243, 222),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem uma conta?',
                    style: GoogleFonts.cormorantSc(
                      color: Color.fromARGB(255, 39, 93, 80),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Entrar',
                      style: GoogleFonts.cormorantSc(
                        color: Color.fromARGB(255, 39, 93, 80),
                        fontSize: 14,
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
