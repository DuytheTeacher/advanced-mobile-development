import 'package:advanced_mobile_dev/widgets/screens/account/profile.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/forgot-password.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/login.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/register.dart';
import 'package:advanced_mobile_dev/widgets/screens/courses/course-detail.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tab-bar.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/tutor-detail.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LET TUTOR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const Login(title: 'Login'),
        '/register': (BuildContext context) =>
            const Register(title: 'Register'),
        '/forgot-password': (BuildContext context) =>
            const ForgotPassword(title: 'Forgot Password'),
        '/tutor-detail': (BuildContext context) =>
            const TutorDetail(title: 'Tutor'),
        '/profile': (BuildContext context) => const Profile(title: 'Profile'),
        '/course-detail': (BuildContext context) =>
            const CourseDetail(title: 'Course Detail'),
      },
      home: const MyHomePage(title: 'LetTutor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(
        child: Tabbar(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
