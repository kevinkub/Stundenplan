import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stundenplan/model.dart';
import 'package:stundenplan/screens/auth.dart';
import 'package:stundenplan/screens/calendar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/screens/courses.dart';
import 'package:stundenplan/screens/settings.dart';
import 'package:stundenplan/screens/timeline.dart';

void main() => runApp(StundenplanApp());

class StundenplanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModel<AppModel>(
      model: new AppModel(),
      child: CupertinoApp(
        title: 'Stundenplan',
        home: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) {
            return model.needsAuth() ? AuthScreen() : MainScaffold();
          },
        ),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  MainScaffold({Key key}) : super(key: key);
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    const IconData calendarIconLine = const IconData(0xf3f3,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData calendarIconFilled = const IconData(0xf3f4,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData timelineIconLine = const IconData(0xf453,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData timelineIconFilled = const IconData(0xf454,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData courseIconLine = const IconData(0xf3e9,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData courseIconFilled = const IconData(0xf3ea,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData settingIconLine = const IconData(0xf43c,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData settingIconFilled = const IconData(0xf43d,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(calendarIconLine),
              activeIcon: Icon(calendarIconFilled),
              title: Text("Kalender")),
          BottomNavigationBarItem(
              icon: Icon(timelineIconLine),
              activeIcon: Icon(timelineIconFilled),
              title: Text("Timeline")),
          BottomNavigationBarItem(
              icon: Icon(courseIconLine),
              activeIcon: Icon(courseIconFilled),
              title: Text("Kurse")),
          BottomNavigationBarItem(
              icon: Icon(settingIconLine),
              activeIcon: Icon(settingIconFilled),
              title: Text("Einstellungen")),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        assert(index >= 0 && index <= 3);
        switch (index) {
          case 0:
            return CalendarScreen();
            break;
          case 1:
            return TimelineScreen();
            break;
          case 2:
            return CoursesScreen();
            break;
          case 3:
            return SettingsScreen();
            break;
        }
      },
    );
  }
}
