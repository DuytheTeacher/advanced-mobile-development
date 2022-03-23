import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-card.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tab-bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorList extends StatefulWidget {
  TutorList({Key? key, required this.filter, required this.queryString}) : super(key: key);

  SearchOptions filter;
  String queryString;

  @override
  State<TutorList> createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  @override
  Widget build(BuildContext context) {
    final tutorData = Provider.of<TutorProvider>(context);

    return SizedBox(
      height: 530.5,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tutorData.queryTutor(widget.filter, widget.queryString).length,
        itemBuilder: (BuildContext context, int index) {
          Tutor tutor = tutorData.queryTutor(widget.filter, widget.queryString)[index];
          return Center(child: TutorCard(tutor: tutor,));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}