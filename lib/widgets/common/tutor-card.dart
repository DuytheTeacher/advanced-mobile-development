import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorCard extends StatefulWidget {
  TutorCard({Key? key, required this.tutor}) : super(key: key);

  Tutor tutor;

  @override
  _TutorCardState createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  _generateStars(int stars) {
    return Row(
      children: List.generate(
        5,
        (index) => index + 1 <= stars
            ? const Icon(
                Icons.star,
                color: Colors.yellow,
              )
            : const Icon(
                Icons.star_border_outlined,
                color: Colors.yellow,
              ),
      ),
    );
  }

  _generateBadges() {
    return SizedBox(
        height: 40,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.tutor.specialities.map((element) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Chip(
                backgroundColor: Theme.of(context).primaryColorLight,
                label: Text(element,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 8)),
              ),
            );
          }).toList(),
        ));
  }

  _tutorInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    widget.tutor.imageUrl,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                radius: 30,
              )),
          Expanded(
            flex: 6,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.tutor.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    _generateStars(widget.tutor.ratingStars),
                    _generateBadges()
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                icon: widget.tutor.isFavorite == true ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  final tutorData = Provider.of<TutorProvider>(context, listen: false);
                  tutorData.toggleFavorite(widget.tutor.id);
                },
              )),
        ],
      ),
    );
  }

  _tutorDescription() {
    return Text(
      widget.tutor.description,
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/tutor-detail');
      },
      behavior: HitTestBehavior.translucent,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [_tutorInfo(context), _tutorDescription()],
          ),
        ),
      ),
    );
  }
}
