import 'package:flutter/material.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  _coursesCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://camblycurriculumicons.s3.amazonaws.com/5e0e8b212ac750e7dc9886ac?h=d41d8cd98f00b204e9800998ecf8427e',
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Life in the Internet Age',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Let\'s discuss how technology is changing the way we live',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
              child: ElevatedButton(
                  onPressed: () {}, child: const Text('Discover')),
            ),
          ],
        ),
      ),
    );
  }

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
        const Text(
          'Our world is rapidly changing thanks to new technology, and the vocabulary needed to discuss modern life is evolving almost daily. In this course you will learn the most up-to-date terminology from expertly crafted lessons as well from your native-speaking tutor.',
          style: TextStyle(color: Colors.grey),
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
        const Text(
          'You will learn vocabulary related to timely topics like remote work, artificial intelligence, online privacy, and more. In addition to discussion questions, you will practice intermediate level speaking tasks such as using data to describe trends.',
          style: TextStyle(color: Colors.grey),
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
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Intermediate',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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