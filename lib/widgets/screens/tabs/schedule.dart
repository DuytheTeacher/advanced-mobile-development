import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  _tutorSection() {
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
                        'https://api.app.lettutor.com/avatar/4d54d3d7-d2a9-42e5-97a2-5ed38af5789aavatar1627913015850.00',
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
                    children: const <Widget>[
                      Text(
                        'Tutor name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Vietnamese',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF616161)),
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

  _scheduleSection() {
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Lesson Time: 20:00 - 21:30',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.red),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
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

  _scheduleCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Thu, 03 Mar 22',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
              ),
              const Text('1 lesson'),
              _tutorSection(),
              _scheduleSection(),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: Text('Join meeting'))
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
      children: List.generate(4, (index) => _scheduleCard()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _listSchedule(),
            ],
          ),
        ),
      ),
    );
  }
}
