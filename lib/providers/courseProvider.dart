import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Course {
  String id;
  String imageUrl;
  String name;
  String description;
  String reason;
  String abilities;
  String exLevel;
  String contentUrl;

  Course(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.description,
      required this.reason,
      required this.abilities,
      required this.exLevel,
      required this.contentUrl});
}

class CourseProvider with ChangeNotifier {
  CourseProvider() {
    generateCourses();
  }

  List<Course> _courses = [];

  List<Course> get courses {
    return [..._courses];
  }

  List<Course> queryCourse(String queryString) {
    return _courses
        .where((element) =>
            element.name.toLowerCase().startsWith(queryString.toLowerCase()))
        .toList();
  }

  void generateCourses() {
    const _uuid = Uuid();
    List<Course> genList = List<Course>.generate(
      24,
      (index) => Course(
        id: _uuid.v4(),
        imageUrl:
            'https://camblycurriculumicons.s3.amazonaws.com/5e2b9a72db0da5490226b6b5?h=d41d8cd98f00b204e9800998ecf8427e',
        name: 'IELTS Speaking Part 1',
        description:
            'Practice answering Part 1 questions from past years\' IELTS exams',
        reason:
            'Feeling confident answering Part 1 questions will help you get off to a strong start on your IELTS speaking exam.',
        abilities:
            'You\'ll practice giving strong answers in Part 1, with tips and tricks recommended by real IELTS examiners.',
        exLevel: 'Any Level',
        contentUrl: 'http://www.africau.edu/images/default/sample.pdf',
      ),
    );
    _courses = genList;
    notifyListeners();
  }
}
