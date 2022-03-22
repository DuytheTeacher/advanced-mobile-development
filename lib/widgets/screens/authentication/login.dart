import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const routeName = '/login';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final String logoTitle = 'LET TURTOR';
  final _formKey = GlobalKey<FormState>();

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

    // App login form render
    _loginForm() {
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username can not be empty!';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Email', hintText: 'example@email.com'),
              controller: emailController,
              enableSuggestions: false,
              autocorrect: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password can not be empty!';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Password', hintText: '*********'),
              controller: passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ],
        ),
      );
    }

    // Forgot password button render
    _forgotPassword() {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            )),
      );
    }

    // App login button render
    _loginButton() {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              } else if (!userData.validate(emailController.text, passwordController.text)){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Failed! Email or password is incorrect!')),
                );
              } else {
                userData.login();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successfully!')),
                );
              }
            },
            child: const Text(
              'Log In',
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
            const Text('Don\'t have account? '),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Register.routeName);
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _logo(),
            _loginForm(),
            _forgotPassword(),
            _loginButton(),
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
