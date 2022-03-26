// import 'package:advanced_mobile_dev/l10n/l10n.dart';
import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/courseProvider.dart';
import 'package:advanced_mobile_dev/providers/languageProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/account/profile.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/forgot-password.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/login.dart';
import 'package:advanced_mobile_dev/widgets/screens/authentication/register.dart';
import 'package:advanced_mobile_dev/widgets/screens/courses/course-detail.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tab-bar.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/become-tutor.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/favorite-tutors.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/tutor-detail.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/video-call.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Builder(
        builder: (context) {
          final languageProvider = Provider.of<LanguageProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'LET TUTOR',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                accentColor: Colors.green),
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              // '/login': (BuildContext context) => Login(title: 'Login', login: _loginCallback,),
              Register.routeName: (BuildContext context) =>
                  Register(title: AppLocalizations.of(context)!.register),
              ForgotPassword.routeName: (BuildContext context) => ForgotPassword(
                  title: AppLocalizations.of(context)!.forgotPassword),
              TutorDetail.routeName: (BuildContext context) =>
                  TutorDetail(title: AppLocalizations.of(context)!.tutor),
              Profile.routeName: (BuildContext context) =>
                  Profile(title: AppLocalizations.of(context)!.profile),
              CourseDetail.routeName: (BuildContext context) =>
                  CourseDetail(title: AppLocalizations.of(context)!.courseDetail),
              VideoCall.routeName: (BuildContext context) =>
                  VideoCall(title: AppLocalizations.of(context)!.videoCall),
              '/become-tutor': (BuildContext context) =>
                  BecomeTutor(title: AppLocalizations.of(context)!.becomeATutor),
              FavoriteTutor.routeName: (BuildContext context) => FavoriteTutor(
                    title: AppLocalizations.of(context)!.favoriteTutors,
                  )
            },
            home: const MyHomePage(title: 'LetTutor'),
            locale: Locale(languageProvider.locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        }
      ),
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
    final userData = Provider.of<UserProvider>(context);

    _renderScreen() {
      if (userData.authenticated == true) {
        return Tabbar();
      } else {
        return Login(title: AppLocalizations.of(context)!.login);
      }
    }

    return Scaffold(
      appBar: null,
      body: Center(
        child: _renderScreen(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
