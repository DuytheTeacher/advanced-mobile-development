import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-list-only.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tab-bar.dart';
import 'package:flutter/material.dart';

class TurtorList extends StatefulWidget {
  const TurtorList({Key? key}) : super(key: key);

  @override
  _TurtorListState createState() => _TurtorListState();
}

class _TurtorListState extends State<TurtorList> {
  List<Tutor> tutorsList = [];

  _filterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
              6,
              (index) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Chip(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      label: Text('Speciality',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 10)),
                    ),
                  )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(children: <Widget>[
          _filterChips(),
          TutorList(filter: SearchOptions.name, queryString: 'all')
        ]),
      ),
    );
  }
}

