import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_presentes/common/widgets/standard_screen.dart';
import 'package:lista_de_presentes/modules/auth/verify.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const StandardScreen();
          } else {
            return const Verify();
          }
        },
      ),
    );
  }
}
