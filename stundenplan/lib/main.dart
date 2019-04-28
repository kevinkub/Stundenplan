import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stundenplan/model.dart';
import 'package:stundenplan/screens/auth.dart';
import 'package:stundenplan/screens/calendar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/screens/courses.dart';
import 'package:stundenplan/screens/settings.dart';
import 'package:stundenplan/screens/timeline.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() => runApp(StundenplanApp());

class StundenplanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModel<AppModel>(
      model: new AppModel(),
      child: PlatformApp(
        title: 'Stundenplan',
        home: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) {
            return model.needsAuth()
                ? AuthScreen()
                : PlatformWidget(
                    ios: (context) => MainScaffoldIos(),
                    android: (context) => MainScaffoldAndroid(),
                  );
          },
        ),
      ),
    );
  }
}

class MainScaffoldAndroid extends StatefulWidget {
  MainScaffoldAndroid({Key key}) : super(key: key);
  @override
  _MainScaffoldAndroidState createState() => _MainScaffoldAndroidState();
}

class _MainScaffoldAndroidState extends State<MainScaffoldAndroid> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    CalendarScreen(),
    TimelineScreen(),
    CoursesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: PlatformText('Kalender'),
            backgroundColor: Theme.of(context).accentColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: PlatformText('Timeline'),
            backgroundColor: Theme.of(context).accentColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: PlatformText('Kurse'),
            backgroundColor: Theme.of(context).accentColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: PlatformText('Einstellungen'),
            backgroundColor: Theme.of(context).accentColor,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class MainScaffoldIos extends StatefulWidget {
  MainScaffoldIos({Key key}) : super(key: key);
  @override
  _MainScaffoldIosState createState() => _MainScaffoldIosState();
}

class _MainScaffoldIosState extends State<MainScaffoldIos> {
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

    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(calendarIconLine),
                activeIcon: Icon(calendarIconFilled),
                title: PlatformText("Kalender")),
            BottomNavigationBarItem(
                icon: Icon(timelineIconLine),
                activeIcon: Icon(timelineIconFilled),
                title: PlatformText("Timeline")),
            BottomNavigationBarItem(
                icon: Icon(courseIconLine),
                activeIcon: Icon(courseIconFilled),
                title: PlatformText("Kurse")),
            BottomNavigationBarItem(
                icon: Icon(settingIconLine),
                activeIcon: Icon(settingIconFilled),
                title: PlatformText("Einstellungen")),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          assert(index >= 0 && index <= 3);
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (c) => CalendarScreen());
              break;
            case 1:
              return CupertinoTabView(builder: (c) => TimelineScreen());
              break;
            case 2:
              return CupertinoTabView(builder: (c) => CoursesScreen());
              break;
            case 3:
              return CupertinoTabView(builder: (c) => SettingsScreen());
              break;
          }
        },
      ),
    );
  }
}
