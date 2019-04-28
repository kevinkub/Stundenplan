import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppModel extends Model {
  var courses = new List<Course>();
  var lessons = new List<Lesson>();
  var _preferences = SharedPreferences.getInstance();
  var _needsAuth = false;
  var _isInPeekMode = false;
  var lastRefreshText = "Nie";

  AppModel() {
    checkNeedsAuth();
    setupFromCache();
    setup();
  }

  void setPeek(String calendarToPeek) async {
    var preferences = await _preferences;
    preferences.setString(PreferenceKeys.Peek, calendarToPeek);
    setup();
  }

  void setToken(String token) async {
    var preferences = await _preferences;
    preferences.setString(PreferenceKeys.Token, token);
    checkNeedsAuth();
    setup();
  }

  bool isInPeekMode() {
    return _isInPeekMode;
  }

  void setup() async {
    lessons = await getLessons();
    courses = getCourses(lessons);
    notifyListeners();
  }

  void setupFromCache() async {
    final preferences = await _preferences;
    if (preferences.containsKey(PreferenceKeys.Cache)) {
      final cache = preferences.getString(PreferenceKeys.Cache);
      if (null != cache) {
        if (preferences.containsKey(PreferenceKeys.LastUpdate)) {
          lastRefreshText = preferences.getString(PreferenceKeys.LastUpdate);
        }
        lessons = parseIcal(cache);
        courses = getCourses(lessons);
        notifyListeners();
      }
    }
  }

  void setCache(String icalDataToCache) async {
    final preferences = await _preferences;
    preferences.setString(PreferenceKeys.Cache, icalDataToCache);
    lastRefreshText = DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now());
    preferences.setString(PreferenceKeys.LastUpdate, lastRefreshText);
    notifyListeners();
  }

  void checkNeedsAuth() async {
    final preferences = await _preferences;
    var token = preferences.getString(PreferenceKeys.Token);
    var prevValue = _needsAuth;
    if (null == token || token.isEmpty) {
      _needsAuth = true;
    } else {
      _needsAuth = false;
    }
    if (prevValue != _needsAuth) {
      notifyListeners();
    }
  }

  EventList<Lesson> getEventList() {
    final list = EventList<Lesson>();
    for (var lesson in lessons) {
      list.add(
          DateTime(lesson.start.year, lesson.start.month, lesson.start.day),
          lesson);
    }
    return list;
  }

  bool needsAuth() {
    return _needsAuth;
  }

  Future<String> httpGet(String url) async {
      final httpClient = new HttpClient();
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      final data = response.transform(utf8.decoder).join();
      return data;
  }

  List<Lesson> parseIcal(String icalData) {
    var lessons = new List<Lesson>();
    Lesson lesson;
    for (var line in icalData.split("\r\n")) {
      if ('BEGIN:VEVENT' == line) {
        lesson = new Lesson();
      } else if (line.startsWith('SUMMARY')) {
        lesson.name = line
            .replaceAll('SUMMARY:', '')
            .replaceAll('*', ' ')
            .replaceAll('\\,', ',')
            .replaceAll(',', ', ')
            .replaceAll('  ', ' ')
            .trim();
      } else if (line.startsWith('DESCRIPTION')) {
        lesson.description = line
            .replaceAll('DESCRIPTION:', '')
            .replaceAll('*', ' ')
            .replaceAll('\\,', ',')
            .replaceAll(',', ', ')
            .replaceAll('  ', ' ')
            .trim();
      } else if (line.startsWith('LOCATION')) {
        lesson.location = line
            .replaceAll('LOCATION:', '')
            .replaceAll('*', ' ')
            .replaceAll('\\,', ',')
            .replaceAll(',', ', ')
            .replaceAll('  ', ' ')
            .trim();
      } else if (line.startsWith('DTSTART;TZID=Europe/Berlin:')) {
        final date =
            DateTime.parse(line.replaceAll('DTSTART;TZID=Europe/Berlin:', ''));
        lesson.start = date;
      } else if (line.startsWith('DTEND;TZID=Europe/Berlin:')) {
        final date =
            DateTime.parse(line.replaceAll('DTEND;TZID=Europe/Berlin:', ''));
        lesson.end = date;
      } else if ('END:VEVENT' == line) {
        if (lesson.name.contains("E-Learning")) {
          lesson.location = "E-Learning " + lesson.location;
        }
        lesson.name = lesson.name.replaceFirst(lesson.location, '').trim();
        lessons.add(lesson);
      }
    }
    lessons.sort((l1, l2) => l1.start.compareTo(l2.start));
    return lessons;
  }

  Future<List<Lesson>> getLessons() async {
    final preferences = await _preferences;
    final token = preferences.getString(PreferenceKeys.Token);
    final potentialPeek = preferences.getString(PreferenceKeys.Peek);
    if (null != token) {
      var url = 'https://intranet.fhdw.de/ical/$token';
      if(null != potentialPeek && potentialPeek.isNotEmpty) {
        url += '/$potentialPeek';
        _isInPeekMode = true;
      } else {
        _isInPeekMode = false;
      }
      final ical = await httpGet(url);
      setCache(ical);
      return parseIcal(ical);
    }
    return new List<Lesson>();
  }

  Future<List<String>> getAvailableCalendars() async {
    final preferences = await _preferences;
    final token = preferences.getString(PreferenceKeys.Token);
    final response = await httpGet('https://intranet.fhdw.de/ical/$token/-');
    return response.split("\n");
  }

  List<Course> getCourses(List<Lesson> lessons) {
    var courses = new List<Course>();
    var colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.amber,
      Colors.brown,
      Colors.indigo,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.deepPurple,
      Colors.cyan,
      Colors.lightGreen,
      Colors.yellow,
      Colors.deepOrange,
      Colors.blueGrey,
    ];
    var availableColors = colors.toList();

    var regexp = new RegExp(r"^[A-Z]*$");
    for (var lesson in lessons) {
      var potentialClassNames = lesson.name.split(' ');
      var className = '*';
      for (var potentialClassName in potentialClassNames) {
        if (regexp.hasMatch(potentialClassName)) {
          className = potentialClassName.toUpperCase();
          break;
        }
      }
      var course = courses.firstWhere((course) => course.name == className,
          orElse: () => null);
      if (null == course) {
        course = Course(name: className);
        if (availableColors.length == 0) {
          availableColors = colors.toList();
        }
        course.color = availableColors.removeAt(0);
        courses.add(course);
      }
      lesson.name = lesson.name.replaceFirst(course.name, '').trim();
      course.lessons.add(lesson);
      lesson.course = course;
    }
    courses.sort((a, b) => a.name.compareTo(b.name));
    return courses;
  }
}

class PreferenceKeys {
  static const Token = "TOKEN";
  static const Peek = "PEEK";
  static const Cache = "CACHE";
  static const LastUpdate = "LASTUPDATE";
}

class Lesson {
  DateTime start, end;
  String name, description, location;
  Course course;

  @override
  String toString() {
    return '{ name: "$name", description: "$description", location: "$location", start: "$start", end: "$end" }';
  }
}

class Course {
  String name;
  Color color;
  List<Lesson> lessons;

  Course({this.name}) : super() {
    lessons = new List<Lesson>();
  }

  double getProgress() {
    var totalMinutes = 0;
    var currentMinutes = 0;
    var now = DateTime.now();
    for (var lesson in lessons) {
      totalMinutes += lesson.end.difference(lesson.start).inMinutes;
      if (now.isAfter(lesson.start)) {
        currentMinutes += min(lesson.end.difference(lesson.start).inMinutes,
            now.difference(lesson.start).inMinutes);
      }
    }
    return currentMinutes / totalMinutes;
  }
}
