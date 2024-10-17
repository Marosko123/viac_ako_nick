import 'package:ViacAkoNick/common/my_colors.dart';
import 'package:ViacAkoNick/screens/chat_screen.dart';
import 'package:ViacAkoNick/screens/primary_page.dart';
import 'package:ViacAkoNick/screens/splash_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

void main() {
  MyColors.setColors();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viac Ako Nick',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Viac Ako Nick - Domov'),
      home: const SplashScreen(),
      routes: {
        PrimaryPage.routeName: (ctx) => const PrimaryPage(),
        ChatScreen.routeName: (ctx) => const ChatScreen(),
      },
    );
  }
}
