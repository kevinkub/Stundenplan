import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/lesson_cell.dart';
import 'package:stundenplan/model.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  ScrollController _controller = new ScrollController();

  void _goToElement(int index) {
    _controller.animateTo((76.0 * index),
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text("Timeline"),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text("Heute"),
                  onPressed: () {
                    _goToElement(model.lessons
                        .where((lesson) => lesson.end.isBefore(DateTime.now()))
                        .length);
                  },
                ),
              ),
              child: SafeArea(
                child: Scrollbar(
                  child: ListView.builder(
                    controller: _controller,
                    padding: EdgeInsets.all(16.0),
                    itemExtent: 76.0,
                    itemBuilder: (BuildContext context, int index) {
                      final lesson = model.lessons[index];
                      return LessonCell(lesson: lesson);
                    },
                    itemCount: model.lessons.length,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
