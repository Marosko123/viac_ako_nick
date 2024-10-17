import 'package:ViacAkoNick/common/my_colors.dart';
import 'package:ViacAkoNick/components/my_button.dart';
import 'package:ViacAkoNick/screens/chat_screen.dart';
import 'package:ViacAkoNick/screens/register_screen.dart';
import 'package:flutter/material.dart';

class PrimaryPage extends StatefulWidget {
  const PrimaryPage({Key? key}) : super(key: key);
  static const routeName = '/primary-page';

  @override
  PrimaryPageState createState() => PrimaryPageState();
}

class PrimaryPageState extends State<PrimaryPage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Initialize the _pages list inside initState()
    _pages = [
      const RegisterScreen(),
      const ChatScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Header
              const Row(
                children: [
                  Expanded(
                    child: MyButton(text: "Rýchlo preč", onTap: null),
                  )
                ],
              ),

              _pages[_selectedIndex],
            ],
          ),
        ),
      ),
    );
  }
}
