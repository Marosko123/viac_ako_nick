// ignore_for_file: avoid_print

import 'dart:async';

import 'package:ViacAkoNick/common/server_handling/request_handler.dart';
import 'package:ViacAkoNick/screens/primary_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/global_variables.dart';
import '../components/my_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLoading = false;
  int _noInternetCounter = 0;
  dynamic _timer;

  void isServerOnline() async {
    var result = await RequestHandler.isServerOnline();

    if (result == true) {
      Navigator.of(context).popAndPushNamed(PrimaryPage.routeName);
      return;
    }

    _noInternetCounter++;
    print('_noInternetCounter: $_noInternetCounter');

    if (_noInternetCounter >= 20) {
      try {
        return setState(() {
          showLoading = false;
          _timer.cancel();
        });
      } catch (e) {
        print(e);
      }
    }

    await Future.delayed(const Duration(seconds: 1), () => isServerOnline());
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      showLoading = true;
      setState(() {});
      isServerOnline();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Viac Ako Nick',
                  style: GoogleFonts.pacifico(
                    color: const Color(0xff4e8489),
                    fontSize: 27,
                  ),
                ),
                if (showLoading)
                  const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff4e8489),
                      ),
                      strokeWidth: 1.5,
                    ),
                  ),
                if (showLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Načítavam...',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                if (showLoading == false ||
                    GlobalVariables.isConnectedToServer == false)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Nie ste pripojený k internetu',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                if (showLoading == false)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Skontrolujte pripojenie a reštartujte aplikáciu',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
              ],
            ),
          ),
          const Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: MyButton(
              text: 'Rýchlo Preč',
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }
}
