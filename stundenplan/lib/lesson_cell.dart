import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stundenplan/model.dart';
import 'package:stundenplan/screens/course.dart';

class LessonCell extends StatelessWidget {
  const LessonCell({Key key, this.lesson, this.clickable = true})
      : super(key: key);

  final bool clickable;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!clickable) return;
        Navigator.of(context, rootNavigator: true).push(
          platformPageRoute(
              builder: (context) => PlatformWidget(
                    android: (context) => CourseScreen(course: lesson.course),
                    ios: (context) => CourseScreen(course: lesson.course),
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: PlatformText(
                lesson.course.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: lesson.course.color, shape: BoxShape.circle),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    PlatformText(lesson.name, overflow: TextOverflow.ellipsis),
                    PlatformText(lesson.location, overflow: TextOverflow.ellipsis),
                  ],
                ),
                padding: EdgeInsets.only(left: 16, right: 16),
              ),
              flex: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                PlatformText(
                    lesson.start.hour.toString().padLeft(2, '0') +
                        ':' +
                        lesson.start.minute.toString().padLeft(2, '0') +
                        ' - ' +
                        lesson.end.hour.toString().padLeft(2, '0') +
                        ':' +
                        lesson.end.minute.toString().padLeft(2, '0'),
                    style: TextStyle(color: CupertinoColors.inactiveGray)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      child: Icon(
                        CupertinoIcons.check_mark,
                        color: CupertinoColors.inactiveGray,
                      ),
                      visible: lesson.end.isBefore(DateTime.now()),
                    ),
                    PlatformText(
                      getDayOfWeek(lesson.start.weekday) +
                          ', ' +
                          lesson.start.day.toString().padLeft(2, '0') +
                          '.' +
                          lesson.start.month.toString().padLeft(2, '0') +
                          '.',
                      style: TextStyle(color: CupertinoColors.inactiveGray),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getDayOfWeek(int weekday) {
    assert(weekday >= 1 && weekday <= 7);
    return ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"][weekday - 1];
  }
}
