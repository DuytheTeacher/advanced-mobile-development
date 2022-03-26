import 'package:advanced_mobile_dev/api/notification_api.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key, required this.title}) : super(key: key);

  final String title;
  static String routeName = '/forgot-password';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final String logoTitle = 'LET TURTOR';

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);

    // App Logo render
    _logo() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/images/tutor_logo.png',
                  fit: BoxFit.cover,
                )),
            Text(logoTitle,
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28))
          ],
        ),
      );
    }

    // App backup email form render
    _backupEmailForm() {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Email', hintText: 'example@email.com'),
              controller: emailController,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ],
        ),
      );
    }

    // App send button render
    _sendButton() {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () {
              final returnedPassword = userData.recoveryPassword(emailController.text);
              String message = 'Can not find your email address. Please check again!';

              if (returnedPassword.isNotEmpty) {
                message = 'Your password is $returnedPassword . Please do not share with other people';
              }
              NotificationApi.showNotification(
                title: 'Recovery password',
                body: message,
                payload: 'sarah.abs'
              );
            },
            child: const Text(
              'Send',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            )),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.forgotPassword)),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _logo(),
            _backupEmailForm(),
            _sendButton(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
