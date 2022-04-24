import 'package:advanced_mobile_dev/models/tutor-model.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/tutor-detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorCard extends StatefulWidget {
  TutorCard({Key? key, required this.tutor, required this.favorites})
      : super(key: key);

  TutorModel tutor;
  List<String> favorites;

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
          children: widget.tutor.specialties.map<Widget>((element) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Chip(
                backgroundColor: Theme.of(context).primaryColorLight,
                label: Text(element.toUpperCase(),
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
                    widget.tutor.avatar,
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
                    _generateStars(5),
                    _generateBadges()
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                icon: widget.favorites.indexWhere(
                            (element) => element == widget.tutor.userId) !=
                        -1
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () async {
                  final tutorData =
                      Provider.of<TutorProvider>(context, listen: false);
                  var resp =
                      await tutorData.toggleFavorite(widget.tutor.userId);
                  if (resp != null && resp == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Tutor is added to Favorite'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).accentColor,
                    ));
                  } else if (resp != null && resp == false) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Tutor is removed from Favorite'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).accentColor,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(tutorData.errorMessage),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).accentColor,
                    ));
                  }
                },
              )),
        ],
      ),
    );
  }

  _tutorDescription() {
    return Text(
      widget.tutor.bio,
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);

    return GestureDetector(
      onTap: () async {
        var asyncDetail = await tutorProvider.getTutorDetailAsync(widget.tutor.userId);
        Navigator.pushNamed(context, TutorDetail.routeName,
            arguments: TutorDetailArguments(widget.tutor.id, asyncDetail));
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
