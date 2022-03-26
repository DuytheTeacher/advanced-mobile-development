import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-list-only.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteTutor extends StatefulWidget {
  FavoriteTutor({Key? key, required this.title}) : super(key: key);

  final String title;
  static String routeName = '/favorite-tutors';

  @override
  State<FavoriteTutor> createState() => _FavoriteTutorState();
}

class _FavoriteTutorState extends State<FavoriteTutor> {
  @override
  Widget build(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);
    final tutors = tutorProvider.getFavorite();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    child: Image.asset(
                  'assets/images/courses_logo.png',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                )),
                const Text(
                  'Favorite Tutors',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                TutorList(tutorsList: tutors),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
