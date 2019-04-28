import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stundenplan/lesson_cell.dart';
import 'package:stundenplan/model.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({Key key, this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Kursansicht"),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
                border: Border(
                  bottom: BorderSide(
                      width: 0.5, color: CupertinoColors.lightBackgroundGray),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: course.color, shape: BoxShape.circle),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PlatformText(
                            course.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Builder(
                            builder: (context) {
                              final lessonsDone = course.lessons
                                  .where((lesson) =>
                                      lesson.end.isBefore(DateTime.now()))
                                  .toList()
                                  .length;
                              return PlatformText(
                                lessonsDone == 1
                                    ? 'Eine Vorlesung absolviert'
                                    : lessonsDone.toString() +
                                        ' Vorlesungen absolviert',
                                style: TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
                border: Border(
                  bottom: BorderSide(
                      width: 0.5, color: CupertinoColors.lightBackgroundGray),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        PlatformText(
                          "Vorlesungen",
                          style: TextStyle(fontSize: 13),
                        ),
                        PlatformText(course.lessons.length.toString(),
                            style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.inactiveGray))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        PlatformText(
                          "Demnächst",
                          style: TextStyle(fontSize: 13),
                        ),
                        PlatformText(getNextLessonInPlatformText(),
                            style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.inactiveGray))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        PlatformText(
                          "Fortschritt",
                          style: TextStyle(fontSize: 13),
                        ),
                        PlatformText(
                            (course.getProgress() * 100).round().toString() +
                                ' %',
                            style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.inactiveGray))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: course.lessons.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: index == 0 ? 16 : 0),
                      child: LessonCell(
                        lesson: course.lessons[index],
                        clickable: false,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getNextLessonInPlatformText() {
    final lesson = course.lessons.firstWhere(
        (lesson) => lesson.start.isAfter(DateTime.now()),
        orElse: () => null);
    if (null == lesson) {
      return "nie";
    }
    final diff = lesson.start.difference(DateTime.now());
    if (diff.inDays > 1) {
      return "in " + diff.inDays.toString() + " Tagen";
    }
    return "in " + diff.inHours.toString() + " Stunden";
  }
}
