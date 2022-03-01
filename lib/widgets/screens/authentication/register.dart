import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // App Register form render
    _registerForm() {
      return Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
                labelText: 'Full name *', hintText: 'Name'),
            controller: fullnameController,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
                labelText: 'Email', hintText: 'example@email.com'),
            controller: emailController,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
                labelText: 'Password', hintText: '*********'),
            controller: passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
                labelText: 'Confirm Password *', hintText: '*********'),
            controller: confirmedPasswordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ],
      );
    }

    // App login button render
    _registerButton() {
      return Padding(
        padding: const EdgeInsets.only(top: 35),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () {},
            child: const Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            )),
      );
    }

    // App group of social login methods
    _socialLogin() {
      return SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.facebook_outlined),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Ink(
              decoration: const ShapeDecoration(
                color: Colors.red,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.alternate_email_outlined),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
    }

    // App register button text
    _register() {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account? '),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Log In',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _registerForm(),
            _registerButton(),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Or continue with',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            _socialLogin(),
            _register()
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
