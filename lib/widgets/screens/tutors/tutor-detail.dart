import 'package:flutter/material.dart';

class TutorDetail extends StatefulWidget {
  const TutorDetail({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TutorDetailState createState() => _TutorDetailState();
}

class _TutorDetailState extends State<TutorDetail> {
  List<String> languagesList = ['English', 'Vietnamese'];
  List<String> specialitiesList = [
    'English of business',
    'Conversational',
    'English for kids',
    'IELTS',
    'TOEIC'
  ];
  String interest =
      'I loved the weather, the scenery and the laid-back lifestyle of the locals.';
  String experience =
      'I have more than 10 years of teaching english experience';

  _generateStars(double iconSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: iconSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: iconSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: iconSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: iconSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: iconSize,
        ),
      ],
    );
  }

  _tutorInfo() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 2,
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
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  'Tutor name',
                  style: TextStyle(fontSize: 17),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Teacher',
                    style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                  ),
                ),
                Text('Viet Nam')
              ],
            )),
        Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _generateStars(24),
                const Icon(
                  Icons.favorite_outline,
                  color: Colors.red,
                )
              ],
            ))
      ],
    );
  }

  _actionsGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'Message',
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.report,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'Report',
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).primaryColor),
            ),
          ],
        )
      ],
    );
  }

  _tutorDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
          'I am passionate about running and fitness, I often compete in trail/mountain running events and I love pushing myself. I am training to one day take part in ultra-endurance events. I also enjoy watching rugby on the weekends, reading and watching podcasts on Youtube. My most memorable life experience would be living in and traveling around Southeast Asia.'),
    );
  }

  _chipsSectionGenerator(String section, List<String> chips) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            Wrap(
              spacing: 10,
              runSpacing: -10,
              children: List.generate(
                  chips.length,
                  (index) => Chip(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      label: Text(
                        chips[index],
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor),
                      ))),
            )
          ],
        ),
      ),
    );
  }

  _textSectionGenerator(String section, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                description,
              ),
            )
          ],
        ),
      ),
    );
  }

  _commentCard() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://api.app.lettutor.com/avatar/4d54d3d7-d2a9-42e5-97a2-5ed38af5789aavatar1627913015850.00',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  radius: 30,
                )),
            Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Student name',
                            style: TextStyle(fontSize: 15),
                          ),
                          _generateStars(18),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'He is the best teacher that I\'ve been ever leant! Thank you for all of your helpful, interesting, meaningful lessons. I wish you all the best on your career path.',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF616161)),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              '20:20:20. 20/02/2022',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _listCommentsGenerator() {
    return Column(
      children: List.generate(5, (index) => _commentCard()),
    );
  }

  _commentSectionGenerator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Rating and comments (5)',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          ),
        ),
        _listCommentsGenerator()
      ],
    );
  }

  _listDateBooking(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(
              7,
              (index) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () {
                          _showTimeBookingModal(ctx);
                        },
                        child: const Text('2020-03-02')),
                  )),
        ),
      ),
    );
  }

  _listTimeBooking() {
    // return Expanded(
    //   child: GridView.count(
    //     primary: false,
    //     padding: const EdgeInsets.all(8),
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //     crossAxisCount: 2,
    //     children: List.generate(
    //       4,
    //       (index) => SizedBox(
    //         width: double.infinity,
    //         height: 50,
    //         child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(50))),
    //             onPressed: () {},
    //             child: const Text('2020-03-02')),
    //       ),
    //     ),
    //   ),
    // );
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 50,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: 6,
        itemBuilder: (context, index) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () {},
            child: const Text('2020-03-02')),
      ),
    );
  }

  _dateBooking(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Pick your date!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        _listDateBooking(ctx)
      ],
    );
  }

  _timeBooking() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Pick your time!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        _listTimeBooking()
      ],
    );
  }

  _showDateBookingModal(BuildContext ctx) {
    return showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: SizedBox(
              width: double.infinity,
              child: _dateBooking(ctx),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  _showTimeBookingModal(BuildContext ctx) {
    return showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: SizedBox(
              width: double.infinity,
              child: _timeBooking(),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Column(children: <Widget>[
              _tutorInfo(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDateBookingModal(context);
                    },
                    child: const Text('Booking'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ),
              ),
              _actionsGroup(),
              _tutorDescription(),
              _chipsSectionGenerator('Languages', languagesList),
              _chipsSectionGenerator('Specialities', specialitiesList),
              _textSectionGenerator('Interest', interest),
              _textSectionGenerator('Teaching Experience', experience),
              _commentSectionGenerator()
            ]),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
