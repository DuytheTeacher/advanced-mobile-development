import 'dart:io';

import 'package:advanced_mobile_dev/api/pdf_api.dart';
import 'package:advanced_mobile_dev/providers/courseProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/courses/course-content.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({Key? key, required this.title}) : super(key: key);

  final String title;
  static String routeName = '/course-detail';

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  Course courseDetail = Course(
      id: '',
      imageUrl: '',
      name: '',
      description: '',
      reason: '',
      abilities: '',
      exLevel: '',
      contentUrl: '');

  @override
  initState() {
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as CourseDetailArgument;

      setState(() {
        courseDetail = args.course;
      });
    });

    super.initState();
  }

  _coursesCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              courseDetail.imageUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                courseDetail.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                courseDetail.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
              child: ElevatedButton(
                  onPressed: () async {
                    final file = await PDFApi.loadNetwork(courseDetail.contentUrl);
                    // Navigator.pushNamed(context, CourseContent.routeName);
                    openPDF(context, file);
                  }, child: const Text('Discover')),
            ),
          ],
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CourseContent(file: file, course: courseDetail,)));

  _overviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Overview',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: const <Widget>[
              Icon(
                Icons.question_mark_outlined,
                color: Colors.red,
              ),
              Text('Why take this course?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
            ],
          ),
        ),
        Text(
          courseDetail.reason,
          style: const TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: const <Widget>[
              Icon(
                Icons.question_mark_outlined,
                color: Colors.red,
              ),
              Text('What will you be able to do',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
            ],
          ),
        ),
        Text(
          courseDetail.abilities,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  _experienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Experience Level',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.group_add_outlined,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(courseDetail.exLevel,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ],
    );
  }

  _lengthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Course Length',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.menu_book_outlined,
                color: Theme.of(context).primaryColor,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('9 lessons',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              _coursesCard(),
              _overviewSection(),
              _experienceSection(),
              _lengthSection()
            ],
          ),
        )),
        resizeToAvoidBottomInset: false);
  }
}

class CourseDetailArgument {
  final Course course;

  CourseDetailArgument(this.course);
}
