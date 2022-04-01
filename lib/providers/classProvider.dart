import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Class {
  final String id;
  final String userId;
  final String tutorId;
  final DateTime schedule;

  Class({required this.id, required this.userId, required this.tutorId, required this.schedule});

  Class.fromMap(Map map)
      : id = map['id'],
        userId = map['userId'],
        schedule = DateTime.tryParse(map['schedule']) ?? DateTime.now(),
        tutorId = map['tutorId'];

  Map toMap() {
    return {
      'id': id,
      'userId': userId,
      'schedule': schedule.toIso8601String(),
      'tutorId': tutorId
    };
  }
}

class ClassProvider with ChangeNotifier {
  List<Class> _classes = [];
  late SharedPreferences prefs;

  ClassProvider() {
    setup();
  }

  void setup() async {
    prefs = await SharedPreferences.getInstance();
    loadData();
  }

  void saveData() async {
    List<String> spList =
    _classes.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList('classes', spList);
  }

  void loadData() async {
    List<String> spList = await prefs.getStringList('classes') ?? [];
    _classes = spList.isNotEmpty ? spList.map((item) => Class.fromMap(json.decode(item))).toList() : [];
    notifyListeners();
  }

  List<Class> get classes {
    return [..._classes];
  }

  void addClass(Class newClass) {
    _classes.add(newClass);
    notifyListeners();
    saveData();
  }

  void cancelClass(String classId) {
    _classes.removeWhere((element) => element.id == classId);
    notifyListeners();
    saveData();
  }

  Class getClassById(String classId) {
    return _classes.firstWhere((element) => element.id == classId);
  }

  Duration totalLearningHours() {
    return Duration(minutes: 90 * _classes.where((element) => element.schedule.add(const Duration(minutes: 90)).isBefore(DateTime.now())).length);
  }

  List<Class> getClassByIds(String tutorId, String userId) {
    return [..._classes].where((element) => element.tutorId == tutorId && element.userId == userId).toList();
  }

  List<Class> getClassByUserId(String userId) {
    return [..._classes].where((element) => element.userId == userId && element.schedule.add(const Duration(minutes: 90)).isAfter(DateTime.now())).toList();
  }

  List<Class> getHistoryByUserId(String userId) {
    return [...classes].where((element) => element.schedule.add(const Duration(minutes: 90)).isBefore(DateTime.now())).toList();
  }
}