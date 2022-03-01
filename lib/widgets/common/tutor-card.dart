import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class TutorCard extends StatefulWidget {
  const TutorCard({Key? key}) : super(key: key);

  @override
  _TutorCardState createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  _generateStars() {
    return Row(
      children: const [
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ],
    );
  }

  _generateBadges() {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Chip(
            backgroundColor: Theme.of(context).primaryColorLight,
            label: Text('BADGE',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 8)),
          ),
          Chip(
            backgroundColor: Theme.of(context).primaryColorLight,
            label: Text('BADGE',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 8)),
          ),
          Chip(
            backgroundColor: Theme.of(context).primaryColorLight,
            label: Text('BADGE',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 8)),
          ),
          Chip(
            backgroundColor: Theme.of(context).primaryColorLight,
            label: Text('BADGE',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 8)),
          ),
          Chip(
            backgroundColor: Theme.of(context).primaryColorLight,
            label: Text('BADGE',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 8)),
          ),
          Chip(
            backgroundColor: Theme.of(context).primaryColorLight,
            label: Text('BADGE',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 8)),
          ),
        ],
      ),
    );
  }

  _tutorInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          const Expanded(
              flex: 1,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://api.app.lettutor.com/avatar/4d54d3d7-d2a9-42e5-97a2-5ed38af5789aavatar1627913015850.00'),
              )),
          Expanded(
            flex: 7,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Tutor name',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    _generateStars(),
                    _generateBadges()
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: Icon(Icons.favorite_border,
                  color: Theme.of(context).primaryColor)),
        ],
      ),
    );
  }

  _tutorDescription() {
    return const Text(
      'I am passionate about running and fitness, I often compete in trail/mountain running events and I love pushing myself. I am training to one day take part in ultra-endurance events. I also enjoy watching rugby on the weekends, reading and watching podcasts on Youtube. My most memorable life experience would be living in and traveling around Southeast Asia.',
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
      style: TextStyle(
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [_tutorInfo(), _tutorDescription()],
        ),
      ),
    );
  }
}
