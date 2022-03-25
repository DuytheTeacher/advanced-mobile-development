import 'package:advanced_mobile_dev/providers/courseProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/courses/course-detail.dart';

import 'package:flutter/material.dart';

class CoursesList extends StatefulWidget {
  CoursesList({Key? key, required this.coursesList}) : super(key: key);

  List<Course> coursesList;

  @override
  State<CoursesList> createState() => _CoursesList();
}

class _CoursesList extends State<CoursesList> {
  int _page = 0;
  final int _limit = 10;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  List<Course> courses = [];

  @override
  initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CoursesList oldWidget) {
    courses = widget.coursesList;
    _firstLoad();
    super.didUpdateWidget(oldWidget);
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
      _hasNextPage = true;
      _page = 0;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      courses = widget.coursesList.sublist(
          0, widget.coursesList.length > 10 ? 10 : widget.coursesList.length);
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      _page += 1;
      int total = widget.coursesList.length;
      int ending = _limit * (_page + 1);

      setState(() {
        if (total < _limit) {
          _hasNextPage = false;
          return;
        } else if (ending <= total) {
          courses.addAll(widget.coursesList.sublist(_limit * _page, ending));
        } else {
          courses.addAll(widget.coursesList.sublist(_limit * _page));
          _hasNextPage = false;
        }
      });

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _coursesCard(Course course) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: 300,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, CourseDetail.routeName, arguments: CourseDetailArgument(course));
          },
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  course.imageUrl,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    course.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    course.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                  child: Text(
                    'Beginner - 1 lesson(s)',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: _isLoadMoreRunning ? 282 : 338,
                  child: ListView.separated(
                    shrinkWrap: true,
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      Course course = courses[index];
                      return Center(
                          child: _coursesCard(
                        course,
                      ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }
}
