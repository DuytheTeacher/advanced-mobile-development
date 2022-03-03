import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  _coursesCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: 300,
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                'https://camblycurriculumicons.s3.amazonaws.com/5e0e8b212ac750e7dc9886ac?h=d41d8cd98f00b204e9800998ecf8427e',
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Life in the Internet Age',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Text(
                  'Let\'s discuss how technology is changing the way we live',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                child: Text(
                  'Beginner - 9 lessons',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listCourses() {
    return Column(
      children: List.generate(4, (index) => _coursesCard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
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
                'Courses',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 4,
                    ),
                  )),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                        'LiveTutor has built the most quality, methodical and scientific courses in the fields of life for those who are in need of improving their knowledge of the fields.'),
                  ),
                ),
              ),
              _listCourses(),
            ],
          ),
        ),
      ),
    );
  }
}
