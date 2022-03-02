import 'package:flutter/material.dart';

import '../../common/tutor-card.dart';

class TurtorList extends StatefulWidget {
  const TurtorList({Key? key}) : super(key: key);

  @override
  _TurtorListState createState() => _TurtorListState();
}

class _TurtorListState extends State<TurtorList> {
  final searchController = TextEditingController();

  _searchBar(TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search Tutors',
          fillColor: Colors.grey[350],
          filled: true,
          contentPadding: const EdgeInsets.all(10.0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Color(0xFFD6D6D6),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFFD6D6D6)),
          ),
        ),
      ),
    );
  }

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

  _listRecommendedTutors() {
    return SizedBox(
      height: 483.4,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return const Center(child: TutorCard());
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
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
          _searchBar(searchController),
          _filterChips(),
          _listRecommendedTutors()
        ]),
      ),
    );
  }
}
