import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _isFirstLoading = false;
  bool _isMoreLoading = false;
  int _page = 0;
  final int _limit = 5;
  bool _hasNextPage = true;
  late ScrollController _controller;

  List<Class> classes = [];

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

  void _firstLoad() async {
    setState(() {
      _isFirstLoading = true;
      _page = 0;
      _hasNextPage = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final allClasses = Provider.of<ClassProvider>(context, listen: false)
        .getHistoryByUserId(userProvider.currentUser?.id);
    classes = allClasses.sublist(
        0, allClasses.length > _limit ? _limit : allClasses.length);
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isFirstLoading = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoading == false &&
        _isMoreLoading == false &&
        _controller.position.extentAfter < 100) {
      setState(() {
        _isMoreLoading = true;
      });

      final classProvider = Provider.of<ClassProvider>(context, listen: false);

      await Future.delayed(const Duration(milliseconds: 1000));
      _page += 1;
      int total = classes.length;
      int ending = _limit * (_page + 1);

      setState(() {
        if (total < _limit) {
          _hasNextPage = false;
          return;
        } else if (ending <= total) {
          classes.addAll(classProvider.classes.sublist(_limit * _page, ending));
        } else {
          classes.addAll(classProvider.classes.sublist(_limit * _page));
          _hasNextPage = false;
        }
      });

      setState(() {
        _isMoreLoading = false;
      });
    }
  }

  _historySection(Class currentClass) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lesson Time: ${DateFormat.jm().format(currentClass.schedule)} - ${DateFormat.jm().format(currentClass.schedule.add(const Duration(hours: 1, minutes: 30)))}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _reviewSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Teach has not reviewed yet.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _tutorSection(Tutor tutorDetail) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        tutorDetail.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    radius: 30,
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tutorDetail.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          tutorDetail.country,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF616161)),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final histories =
        classProvider.getHistoryByUserId(userProvider.currentUser?.id);

    histories.sort((a, b) => a.schedule.compareTo(b.schedule));

    _historyCard(Class currentClass) {
      final tutorDetail = tutorProvider.getTutorDetailById(currentClass.tutorId);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('E, d MMMM y').format(currentClass.schedule),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 28),
                ),
                Text(
                    '${DateTime.now().difference(currentClass.schedule).inHours} hours ago'),
                // _tutorSection(tutorDetail),
                _historySection(currentClass),
                _reviewSection()
              ],
            ),
          ),
        ),
      );
    }

    _listHistory() {
      return Column(
        children: [
          SizedBox(
            height: _isMoreLoading ? 282 : 337,
            child: ListView.separated(
              shrinkWrap: true,
              controller: _controller,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: histories.length,
              itemBuilder: (BuildContext context, int index) {
                Class currentClass = histories[index];
                return Center(child: _historyCard(currentClass));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          if (_isMoreLoading == true)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                child: Image.asset(
              'assets/images/history_logo.png',
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            )),
            const Text(
              'History',
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
                      'The following is a list of lessons you have attended.\nYou can review the details of the lessons you have attended.'),
                ),
              ),
            ),
            histories.isEmpty ? const Center(child: Text('There is no history!', style: TextStyle(fontSize: 20),),) : _listHistory(),
          ],
        ),
      ),
    );
  }
}
