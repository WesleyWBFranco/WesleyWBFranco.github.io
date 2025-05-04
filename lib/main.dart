import 'package:firebase_core/firebase_core.dart';
import 'package:lista_de_presentes/modules/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_presentes/firebase_options.dart';
import 'package:lista_de_presentes/services/cart_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartService())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthPage());
  }
}
