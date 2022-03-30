import 'dart:math';
import 'dart:convert';

import 'package:advanced_mobile_dev/widgets/screens/tabs/tab-bar.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tutor-list.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutor {
  String id;
  String imageUrl;
  String name;
  int ratingStars;
  String description;
  String country;
  List<String> languages;
  List<String> specialities;
  String interest;
  String exp;
  bool isFavorite;

  Tutor(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.ratingStars,
      required this.description,
      required this.country,
      required this.languages,
      required this.specialities,
      required this.interest,
      required this.exp,
      required this.isFavorite});

  Tutor.fromMap(Map map)
      : id = map['id'],
        imageUrl = map['imageUrl'],
        name = map['name'],
        ratingStars = map['ratingStars'],
        description = map['description'],
        country = map['country'],
        languages = List<String>.from(map['languages']),
        specialities = List<String>.from(map['specialities']),
        interest = map['interest'],
        exp = map['exp'],
        isFavorite = map['isFavorite'];

  Map toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'ratingStars': ratingStars,
      'description': description,
      'country': country,
      'languages': languages,
      'specialities': specialities,
      'interest': interest,
      'exp': exp,
      'isFavorite': isFavorite,
    };
  }
}

class Comment {
  String userImageUrl;
  String userName;
  String userId;
  String content;
  int ratingStars;
  DateTime date;

  Comment(
      {required this.userImageUrl,
      required this.userName,
      required this.userId,
      required this.content,
      required this.ratingStars,
      required this.date});

  Comment.fromMap(Map map)
      : userImageUrl = map['userImageUrl'],
        userName = map['userName'],
        userId = map['userId'],
        ratingStars = map['ratingStars'],
        content = map['content'],
        date = DateTime.tryParse(map['date']) ?? DateTime.now();

  Map toMap() {
    return {
      'userImageUrl': userImageUrl,
      'userName': userName,
      'userId': userId,
      'ratingStars': ratingStars,
      'content': content,
      'date': date.toIso8601String()
    };
  }
}

class TutorProvider with ChangeNotifier {
  List<Tutor> _tutors = [];
  late SharedPreferences prefs;

  List<Tutor> get tutorsList {
    return [..._tutors];
  }

  TutorProvider() {
    setup();
  }

  void setup() async {
    prefs = await SharedPreferences.getInstance();
    await loadData();
    if (_tutors.isEmpty) {
      generateList();
      await saveData();
    }
  }

  saveData() async {
    List<String> spList =
    _tutors.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList('tutors', spList);
  }

  loadData() async {
    List<String> spList = await prefs.getStringList('tutors') ?? [];
    _tutors = spList.map((item) => Tutor.fromMap(json.decode(item))).toList();
    notifyListeners();
  }

  String randomName() {
    List<String> firstName = [
      'Tim',
      'John',
      'Jack',
      'Anna',
      'Tom',
      'Nick',
      'Paul',
      'Jammy'
    ];
    List<String> lastName = [
      'Cook',
      'Cena',
      'Grealish',
      'Bell',
      'Cruise',
      'Pop',
      'Torres',
      'Dang'
    ];
    int randomFirstName = Random().nextInt(8);
    int randomLastName = Random().nextInt(8);

    return '${firstName[randomFirstName]} ${lastName[randomLastName]}';
  }

  List<String> randomSpec() {
    List<String> specsList = [
      'English of business',
      'TOEIC',
      'IELTS',
      'English for kids',
      'Conversational'
    ];

    int randomSpecIndex = Random().nextInt(5);
    return [specsList[randomSpecIndex]];
  }

  void generateList() {
    const _uuid = Uuid();
    List<Tutor> genList = List<Tutor>.generate(
      24,
      (index) => Tutor(
          id: _uuid.v4(),
          imageUrl: 'https://source.unsplash.com/random/?avatar/tutor',
          name: randomName(),
          ratingStars: Random().nextInt(5),
          description:
              'I am passionate about running and fitness, I often compete in trail/mountain running events and I love pushing myself. I am training to one day take part in ultra-endurance events. I also enjoy watching rugby on the weekends, reading and watching podcasts on Youtube. My most memorable life experience would be living in and traveling around Southeast Asia.',
          country: 'Vietnam',
          languages: ['English', 'French', 'Chinese'],
          specialities: randomSpec(),
          interest:
              'I loved the weather, the scenery and the laid-back lifestyle of the locals.',
          exp: 'I have more than 10 years of teaching english experience',
          isFavorite: false),
    );
    _tutors = genList;
    notifyListeners();
  }

  List<Comment> generateComments() {
    const _uuid = Uuid();
    return List<Comment>.generate(
        Random().nextInt(10),
        (index) => Comment(
            userImageUrl: 'https://source.unsplash.com/random/?user/students',
            userName: randomName(),
            userId: _uuid.v4(),
            content:
                'He is the best teacher that I\'ve been ever leant! Thank you for all of your helpful, interesting, meaningful lessons. I wish you all the best on your career path.',
            ratingStars: Random().nextInt(5),
            date:
                DateTime.now().subtract(Duration(days: Random().nextInt(30)))));
  }

  void toggleFavorite(String tutorId) {
    int index = _tutors.indexWhere((element) => element.id == tutorId);
    _tutors[index].isFavorite = !_tutors[index].isFavorite;
    notifyListeners();
    saveData();
  }

  List<Tutor> queryTutor(SearchOptions filter, String queryString) {
    if (queryString == 'all') {
      return [..._tutors];
    } else if (filter == SearchOptions.name) {
      return _tutors
          .where((element) =>
              element.name.toLowerCase().startsWith(queryString.toLowerCase()))
          .toList();
    } else {
      return _tutors
          .where((element) => element.country
              .toLowerCase()
              .startsWith(queryString.toLowerCase()))
          .toList();
    }
  }

  List<Tutor> queryTutorWithSpecAndSort(
      List<String> specs, SortingOptions sorting) {
    List<Tutor> tempList = [..._tutors];

    if (sorting == SortingOptions.ascending) {
      tempList.sort((a, b) => a.ratingStars.compareTo(b.ratingStars));
    } else if (sorting == SortingOptions.descending) {
      tempList.sort((a, b) => a.ratingStars.compareTo(b.ratingStars) * -1);
    }

    if (specs.isEmpty) {
      return tempList;
    }
    return [...tempList].where((element) {
      return [...element.specialities].where(specs.contains).isNotEmpty;
    }).toList();
  }

  List<Tutor> getFavorite() {
    return [..._tutors].where((element) => element.isFavorite).toList();
  }

  Tutor getTutorDetailById(String id) {
    return _tutors.singleWhere((element) => element.id == id);
  }
}
