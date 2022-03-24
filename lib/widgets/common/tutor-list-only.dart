import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-card.dart';

import 'package:flutter/material.dart';

class TutorList extends StatefulWidget {
  TutorList({Key? key, required this.tutorsList}) : super(key: key);

  List<Tutor> tutorsList;

  @override
  State<TutorList> createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  int _page = 0;
  final int _limit = 10;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  List<Tutor> tutors = [];

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
  void didUpdateWidget(covariant TutorList oldWidget) {
    tutors = widget.tutorsList;
    _firstLoad();
    super.didUpdateWidget(oldWidget);
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      tutors = widget.tutorsList.sublist(0, widget.tutorsList.length > 10 ? 10 : widget.tutorsList.length);
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

      await Future.delayed(const Duration(seconds: 1));
      _page += 1;
      int total = widget.tutorsList.length;
      int ending = _limit * (_page + 1);

      setState(() {
        if (total < _limit) {
          _hasNextPage = false;
          return;
        } else if (ending <= total) {
          tutors.addAll(widget.tutorsList.sublist(_limit * _page, ending));
        } else {
          tutors.addAll(widget.tutorsList.sublist(_limit * _page));
          _hasNextPage = false;
        }
      });

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 483,
      width: double.infinity,
      child: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: _isLoadMoreRunning ? 427 : 483,
                  child: ListView.separated(
                    shrinkWrap: true,
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: tutors.length,
                    itemBuilder: (BuildContext context, int index) {
                      Tutor tutor = tutors[index];
                      return Center(
                          child: TutorCard(
                        tutor: tutor,
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
