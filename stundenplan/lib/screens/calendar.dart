import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/lesson_cell.dart';
import 'package:stundenplan/model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var _date = DateTime.now();
  var _month = DateTime.now();

  void goToToday() {
    setState(() {
      _date = DateTime.now();
      _month = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(_month.month >= 1 && _month.month <= 12);
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: PlatformText([
              "Januar",
              "Februar",
              "März",
              "April",
              "Mai",
              "Juni",
              "Juli",
              "August",
              "September",
              "Oktober",
              "November",
              "Dezember"
            ][_month.month - 1]),
            trailingActions: <Widget>[
              PlatformWidget(
                ios: (context) {
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: PlatformText("Heute"),
                    onPressed: goToToday,
                  );
                },
                android: (context) {
                  return IconButton(
                    icon: Icon(Icons.today),
                    onPressed: goToToday,
                  );
                },
              ),
            ],
          ),
          body: Container(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 0.5,
                            color: CupertinoColors.lightBackgroundGray),
                      ),
                      color: Color.fromRGBO(250, 250, 250, 1),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 420),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: CalendarCarousel<Lesson>(
                          thisMonthDayBorderColor: Colors.grey,
                          daysTextStyle: TextStyle(color: Colors.black87),
                          weekendTextStyle: TextStyle(color: Colors.black87),
                          staticSixWeekFormat: true,
                          showHeader: false,
                          height: 327,
                          locale: "de",
                          weekDayFormat: WeekdayFormat.standaloneShort,
                          weekDayMargin: EdgeInsets.fromLTRB(0, 10, 0, 4),
                          weekdayTextStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                          childAspectRatio: 1.2,
                          selectedDateTime: _date,
                          onCalendarChanged: (DateTime d) {
                            setState(() {
                              _month = d;
                            });
                          },
                          onDayPressed: (DateTime d, _) {
                            setState(() {
                              _date = d;
                            });
                          },
                          markedDatesMap: model.getEventList(),
                          markedDateShowIcon: true,
                          markedDateIconOffset: 0,
                          markedDateIconMargin: 0,
                          // hack - if the calendar library becomes more flexible, this should be changed.
                          markedDateIconMaxShown: 1,
                          markedDateIconBuilder: (event) {
                            final events =
                                getLessonsForDay(model.lessons, event.start);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: events.map((event) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 23, right: .5, left: .5),
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isSameDay(_date, event.start) ||
                                            isSameDay(
                                                DateTime.now(), event.start)
                                        ? Colors.white
                                        : event.course.color,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final lessons = getLessonsForDay(model.lessons, _date);
                        if (lessons.length > 0) {
                          return ListView.builder(
                            itemCount: lessons.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(
                                    left: 16,
                                    top: index == 0 ? 16 : 0,
                                    right: 16),
                                child: LessonCell(lesson: lessons[index]),
                              );
                            },
                          );
                        } else {
                          return Container(
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/festivities.svg',
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }

  List<Lesson> getLessonsForDay(List<Lesson> lessons, DateTime date) {
    return lessons.where((lesson) => isSameDay(lesson.start, date)).toList();
  }
}
