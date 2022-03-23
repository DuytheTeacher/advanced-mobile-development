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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 483,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.tutorsList.length,
        itemBuilder: (BuildContext context, int index) {
          Tutor tutor = widget.tutorsList[index];
          return Center(child: TutorCard(tutor: tutor,));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}