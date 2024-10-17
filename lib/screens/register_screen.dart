import 'package:ViacAkoNick/common/global_variables.dart';
import 'package:ViacAkoNick/common/my_colors.dart';
import 'package:ViacAkoNick/components/operators_list.dart';
import 'package:ViacAkoNick/screens/chat_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-screen';

  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _phoneNumber;
  String? _question;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _startChat() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_userName == null ||
          _question == null ||
          _userName!.isEmpty ||
          _question!.isEmpty) {
        return;
      }

      // GlobalVariables.operatorId =
      GlobalVariables.user.name = _userName!;
      GlobalVariables.question = _question!;
      GlobalVariables.phone = _phoneNumber ?? '';

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Začínam chat s $_userName')),
      // );

      Navigator.of(context).pushNamed(ChatScreen.routeName);
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      String pattern = r'^\+?[0-9]{7,15}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return 'Prosím, zadajte platné tel. číslo';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Vitaj v aplikácii Viac Ako Nick!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // List of active users
            const Text(
              'Vyber si konzultanta:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),

            const OperatorsList(),
            const SizedBox(height: 16.0),

            // Information message with links
            RichText(
              text: TextSpan(
                text:
                    'Ak začnem chatovať, automaticky súhlasím s pravidlami pomoci zverejnené na našom webe pre deti ',
                style:
                    const TextStyle(color: Colors.black), // Default text style
                children: [
                  TextSpan(
                    text: 'do 12 rokov',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL(
                            'https://viacakonick.hexatech.sk/mam-menej-ako-12-rokov/');
                      },
                  ),
                  const TextSpan(text: ' a '),
                  TextSpan(
                    text: 'nad 12 rokov.',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL(
                            'https://viacakonick.hexatech.sk/mam-viac-ako-12-rokov/');
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Input field for name (required)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Meno a priezvisko*',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Meno je povinné';
                }
                return null;
              },
              onSaved: (value) {
                _userName = value;
              },
            ),
            const SizedBox(height: 16.0),

            // Input field for phone number (optional)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Telefón',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                _phoneNumber = value;
              },
              validator: _validatePhoneNumber,
            ),
            const SizedBox(height: 16.0),

            // Input field for phone number (optional)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Vaša otázka*',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Otázka je povinná';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                _question = value;
              },
            ),
            const SizedBox(height: 16.0),

            // Button to start a chat
            ElevatedButton(
              onPressed: _startChat,
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(MyColors.startChatButtonColor),
                foregroundColor:
                    WidgetStateProperty.all(MyColors.buttonTextColor),
              ),
              child: const Text('Začať chat'),
            ),
          ],
        ),
      ),
    );
  }
}
