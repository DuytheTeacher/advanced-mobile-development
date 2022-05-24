import 'dart:io';
import 'package:advanced_mobile_dev/providers/courseProvider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CourseContent extends StatefulWidget {
  final File file;
  var course;

  static String routeName = '/course-content';

  CourseContent({Key? key, required this.file, required this.course})
      : super(key: key);

  @override
  State<CourseContent> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  late PDFViewController _controller;
  int _pages = 0;
  int _indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final name = widget.course['name'];
    final text = '${_indexPage + 1} of $_pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: _pages >= 2
            ? [
                Center(
                  child: Text(text),
                ),
                IconButton(
                    onPressed: () {
                      _indexPage = _indexPage == 0 ? _pages - 1 : _indexPage - 1;
                      _controller.setPage(_indexPage);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 32,
                    )),
                IconButton(
                    onPressed: () {
                      _indexPage = _indexPage == _pages - 1  ? 0 : _indexPage + 1;
                      _controller.setPage(_indexPage);
                    },
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 32,
                    ))
              ]
            : [Container()],
      ),
      body: PDFView(
        filePath: widget.file.path,
        onRender: (pages) => setState(() {
          _pages = pages!;
        }),
        onViewCreated: (controller) => setState(() {
          _controller = controller;
        }),
        onPageChanged: (indexPage, _) => setState(() {
          _indexPage = _indexPage;
        }),
      ),
    );
  }
}
