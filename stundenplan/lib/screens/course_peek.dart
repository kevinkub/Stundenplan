import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/model.dart';

class CalendarPeekPicker extends StatefulWidget {
  @override
  _CalendarPeekPickerState createState() => _CalendarPeekPickerState();
}

class _CalendarPeekPickerState extends State<CalendarPeekPicker> {
  var calendarNames = new List<String>();
  var filteredCalendarNames = new List<String>();

  @override
  void initState() {
    ScopedModel.of<AppModel>(context).getAvailableCalendars().then((value) {
      if (this.mounted) {
        setState(() {
          calendarNames = value;
          filteredCalendarNames = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Kurs wählen"),
      ),
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 246, 246, 1),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.lightBackgroundGray,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Styles.searchBackground,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          ExcludeSemantics(
                            child: Icon(
                              CupertinoIcons.search,
                              color: Styles.searchIconColor,
                            ),
                          ),
                          Expanded(
                            child: CupertinoTextField(
                              onChanged: (str) {
                                setState(() {
                                  filteredCalendarNames = calendarNames
                                      .where((name) => name.startsWith(str))
                                      .toList();
                                });
                              },
                              autofocus: true,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              autocorrect: false,
                              style: Styles.searchText,
                              cursorColor: Styles.searchCursorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ScopedModelDescendant<AppModel>(
                    builder: (context, child, model) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          model.setPeek(filteredCalendarNames[index]);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(filteredCalendarNames[index])
                              ],
                            ),
                            height: 54,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: CupertinoColors.lightBackgroundGray,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: filteredCalendarNames.length,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class Styles {
  static const searchBackground = Color(0xffe0e0e0);
  static const TextStyle searchText = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1.0),
    fontFamily: 'NotoSans',
    fontSize: 14.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static const Color searchCursorColor = Color.fromRGBO(0, 122, 255, 1.0);
  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1.0);
}
