import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/model.dart';
import 'package:stundenplan/screens/course_peek.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          return CupertinoTabView(builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text("Einstellungen"),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Support",
                                    style: Theme.of(context).textTheme.title),
                                SizedBox(
                                  height: 10,
                                ),
                                CupertinoButton.filled(
                                  child: Text("Entwickler kontaktieren"),
                                  onPressed: () => launch('ma' +
                                      'ilt' +
                                      'o:stunde' +
                                      'nplan-app' +
                                      '@' +
                                      'kekub.de?subject=Stundenplan-App%20Feedback&body=Hallo%20Kevin,'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Card(
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Einstellungen",
                                    style: Theme.of(context).textTheme.title),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Letzte Aktualisierung: " +
                                    model.lastRefreshText),
                                SizedBox(
                                  height: 20,
                                ),
                                CupertinoButton.filled(
                                  child: Text("Daten aktualisieren"),
                                  onPressed: () => model.setup(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CupertinoButton.filled(
                                  child: Text("Token zurücksetzen"),
                                  onPressed: () => model.setToken(""),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Card(
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Kursauswahl",
                                    style: Theme.of(context).textTheme.title),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "Mit der Kursauswahl-Funktion, kannst du den Stundenplan eines Dozenten oder anderen Kurses einsehen."),
                                SizedBox(
                                  height: 20,
                                ),
                                Builder(
                                  builder: (context) {
                                    if (model.isInPeekMode()) {
                                      return CupertinoButton.filled(
                                        child: Text("Zurücksetzen"),
                                        onPressed: () {
                                          model.setPeek(null);
                                        },
                                      );
                                    } else {
                                      return CupertinoButton.filled(
                                        child: Text("Kurs wählen"),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  CalendarPeekPicker(),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
