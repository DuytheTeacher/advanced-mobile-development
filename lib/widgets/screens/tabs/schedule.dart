import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/tutor-detail.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/video-call.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
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

    final allClasses =
        Provider.of<ClassProvider>(context, listen: false).classes;
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
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, TutorDetail.routeName,
                          //     arguments: TutorDetailArguments(tutorDetail.id));
                        },
                        child: Text(
                          tutorDetail.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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

  _scheduleSection(Class currentClass) {
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Lesson Time: ${DateFormat.jm().format(currentClass.schedule)} - ${DateFormat.jm().format(currentClass.schedule.add(const Duration(hours: 1, minutes: 30)))}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.red),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isFirstLoading = true;
                        });

                        final classProvider =
                            Provider.of<ClassProvider>(context, listen: false);
                        Class nextClass =
                            classProvider.getClassById(currentClass.id);
                        bool ableToCancel = DateTime.now().isBefore(nextClass
                            .schedule
                            .subtract(const Duration(hours: 2)));

                        await Future.delayed(const Duration(milliseconds: 500));

                        if (ableToCancel) {
                          classProvider.cancelClass(currentClass.id);
                          _firstLoad();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Cancel class Successfully!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Cancel Failed! You can only cancel 2 hours in advanced'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }

                        setState(() {
                          _isFirstLoading = false;
                        });
                      },
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
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

    final upcomingClasses =
        classProvider.getClassByUserId(userProvider.currentUser?.id);

    upcomingClasses.sort((a, b) => a.schedule.compareTo(b.schedule));

    _scheduleCard(Class currentClass) {
      final tutorDetail =
          tutorProvider.getTutorDetailById(currentClass.tutorId);

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
                const Text('1 lesson'),
                // _tutorSection(tutorDetail),
                _scheduleSection(currentClass),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, VideoCall.routeName,
                                arguments:
                                    VideoCallArguments(currentClass.schedule));
                          },
                          child: const Text('Join meeting'))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    _listSchedule() {
      return Column(
        children: [
          SizedBox(
            height: _isMoreLoading ? 282 : 337,
            child: ListView.separated(
              shrinkWrap: true,
              controller: _controller,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: upcomingClasses.length,
              itemBuilder: (BuildContext context, int index) {
                Class currentClass = upcomingClasses[index];
                return Center(child: _scheduleCard(currentClass));
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
              'assets/images/schedule_logo.png',
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            )),
            const Text(
              'Schedule',
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
                      'Here is a list of the sessions you have booked. \nYou can track when the meeting starts, join the meeting with one click or can cancel the meeting before 2 hours.'),
                ),
              ),
            ),
            _isFirstLoading
                ? const Center(child: CircularProgressIndicator())
                : classes.isEmpty
                    ? const Center(
                        child: Text(
                        'There is no class!',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))
                    : _listSchedule(),
          ],
        ),
      ),
    );
  }
}
