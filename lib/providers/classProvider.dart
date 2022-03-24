import 'package:flutter/foundation.dart';

class Class {
  final String id;
  final String userId;
  final String tutorId;
  final DateTime schedule;

  Class({required this.id, required this.userId, required this.tutorId, required this.schedule});
}

class ClassProvider with ChangeNotifier {
  final List<Class> _classes = [];

  List<Class> get classes {
    return [..._classes];
  }

  void addClass(Class newClass) {
    _classes.add(newClass);
    notifyListeners();
  }

  List<Class> getClassByIds(String tutorId, String userId) {
    return [..._classes].where((element) => element.tutorId == tutorId && element.userId == userId).toList();
  }
}