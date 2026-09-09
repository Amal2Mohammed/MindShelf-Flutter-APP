import 'package:flutter/material.dart';
import 'welcomingPage.dart';
import 'choose_role_page.dart';      
import 'writer_register_page.dart';    
import 'writer_dashboard_page.dart';   
//import 'login_page.dart';              // (your login)
//import 'preferences_page.dart';        // (the page you go to after Skip)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reading App',
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 37, 195, 215), useMaterial3: true),
      initialRoute: '/',       // use routes instead of `home:`
      routes: {
        '/': (_) => const WelcomePage(),
        '/role': (_) => const ChooseRolePage(),              // pick Reader/Writer
        '/writer/register': (_) => const WriterRegisterPage(),
        '/writer/dashboard': (_) => const WriterDashboardPage(),
       // '/login': (_) => const LoginPage(),
       // '/prefs': (_) => const PreferencesPage(),            // after Skip
        // (optional) '/reader/register': (_) => const RegisterPage(role: AppRole.reader),
      },
    );
  }
}