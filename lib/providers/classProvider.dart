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

  void cancelClass(String classId) {
    _classes.removeWhere((element) => element.id == classId);
    notifyListeners();
  }

  List<Class> getClassByIds(String tutorId, String userId) {
    return [..._classes].where((element) => element.tutorId == tutorId && element.userId == userId).toList();
  }

  List<Class> getClassByUserId(String userId) {
    return [..._classes].where((element) => element.userId == userId).toList();
  }
}