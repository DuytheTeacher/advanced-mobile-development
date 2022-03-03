import 'package:advanced_mobile_dev/widgets/common/tutor-card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.seclectPage}) : super(key: key);

  final Function seclectPage;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _bookingSection() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Total lesons time is 84 hours 10 minutes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Upcoming lesson',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Text(
                          'Thu, 03 Mar 22, 20:00 - 21:30',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        )),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.video_call_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              'Enter lesson room',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).scaffoldBackgroundColor,
                            fixedSize: const Size(120, double.minPositive),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _recommendSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Recommended Tutors',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.seclectPage(2);
            },
            child: Text(
              'See all >',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  _listRecommendedTutors() {
    return SizedBox(
      height: 327,
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
    return Column(
      children: <Widget>[
        _bookingSection(),
        _recommendSection(),
        _listRecommendedTutors()
      ],
    );
  }
}
