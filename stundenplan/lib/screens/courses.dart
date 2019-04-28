import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/course_cell.dart';
import 'package:stundenplan/model.dart';

class CoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: PlatformText("Kurse"),
          ),
          body: SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemExtent: 76.0,
              itemBuilder: (BuildContext context, int index) {
                final course = model.courses[index];
                return CourseCell(course: course);
              },
              itemCount: model.courses.length,
            ),
          ),
        );
      },
    );
  }
}
