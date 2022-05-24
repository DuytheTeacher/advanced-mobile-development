import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/providers/courseProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/courses-list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CourseProvider>(context);

    return Padding(
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
            coursesProvider.courses.isEmpty ? const Center(child: Text('There is no course!', style: TextStyle(fontSize: 20),),) : CoursesList(query: ''),
          ],
        ),
      ),
    );
  }
}
