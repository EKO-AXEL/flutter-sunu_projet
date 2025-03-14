import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_projet/config/theme.dart';
import 'package:sunu_projet/providers/authentification_service.dart';
import 'package:sunu_projet/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationService()),
          StreamProvider<User?>.value(value: AuthenticationService().authStateChanges, initialData: null,)
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SunuProjet',
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: SplashScreen()
    );
  }
}