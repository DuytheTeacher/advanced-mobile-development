import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
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
  bool isLoading = false;

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
                          isLoading = true;
                        });

                        final classProvider = Provider.of<ClassProvider>(context, listen: false);
                        classProvider.cancelClass(currentClass.id);
                        await Future.delayed(const Duration(milliseconds: 500));

                        setState(() {
                          isLoading = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Cancel class Successfully!'), behavior: SnackBarBehavior.floating, backgroundColor: Theme.of(context).accentColor,),
                        );
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
        classProvider.getClassByUserId(userProvider.currentUser.id);

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
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                ),
                const Text('1 lesson'),
                _tutorSection(tutorDetail),
                _scheduleSection(currentClass),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, VideoCall.routeName, arguments: VideoCallArguments(currentClass.schedule));
                          }, child: const Text('Join meeting'))
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
          ...upcomingClasses.map((element) => _scheduleCard(element)).toList()
        ],
      );
    }

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
              isLoading ? const Center(child: CircularProgressIndicator()) : _listSchedule(),
            ],
          ),
        ),
      ),
    );
  }
}
