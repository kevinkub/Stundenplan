import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:stundenplan/model.dart';
import 'package:stundenplan/screens/course.dart';

class CourseCell extends StatelessWidget {
  const CourseCell({Key key, this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: course.color,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                child: PlatformText(course.name),
                padding: EdgeInsets.only(left: 16, right: 16),
              ),
              flex: 2,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: PlatformText(
                  (course.getProgress() * 100).round().toString() + " %",
                  style: TextStyle(
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
                padding: EdgeInsets.only(right: 16),
              ),
              flex: 1,
            ),
            Icon(CupertinoIcons.right_chevron,
                color: CupertinoColors.inactiveGray),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
              builder: (context) => CourseScreen(course: course)),
        );
      },
    );
  }
}
