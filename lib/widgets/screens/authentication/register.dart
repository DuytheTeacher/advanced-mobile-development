import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Register> createState() => _RegisterState();

  static const routeName = '/register';
}

class _RegisterState extends State<Register> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);

    // App Register form render
    _registerForm() {
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full name can not be empty!';
                }
                if (value.length < 3) {
                  return 'Full name can not less than 3 characters!';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Full name *', hintText: 'Name'),
              controller: fullNameController,
              enableSuggestions: false,
              autocorrect: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email can not be empty!';
                }
                if (!RegExp(
                        '^[a-zA-Z0-9.!#\$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$')
                    .hasMatch(value)) {
                  return 'Invalid Email address';
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
                if (value.length < 3) {
                  return 'Password can not less than 3 characters!';
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
            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value != passwordController.text) {
                  return 'Confirm password does not match!';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Confirm Password *', hintText: '*********'),
              controller: confirmedPasswordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ],
        ),
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
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              } else if (!userData.validateEmail(emailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Email has already existed! Please check again!')),
                );
              } else {
                userData.register(emailController.text, passwordController.text,
                    fullNameController.text);
                userData.login();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Register Successfully!')),
                );
              }
            },
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
                Navigator.pop(context);
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
      appBar:
          AppBar(title: Text(widget.title), automaticallyImplyLeading: false),
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
