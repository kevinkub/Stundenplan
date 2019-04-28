import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/model.dart';
import 'package:stundenplan/screens/course_peek.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget buildButton(String text, Function onPressed) {
    return PlatformWidget(
      ios: (context) {
        return CupertinoButton.filled(
          child: PlatformText(text),
          onPressed: onPressed,
        );
      },
      android: (context) {
        return PlatformButton(
          child: PlatformText(text),
          onPressed: onPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: PlatformText("Einstellungen"),
          ),
          body: SafeArea(
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
                            PlatformText("Support",
                                style: Theme.of(context).textTheme.title),
                            SizedBox(
                              height: 10,
                            ),
                            buildButton(
                              "Entwickler kontaktieren",
                              () => launch('ma' +
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
                            PlatformText("Einstellungen",
                                style: Theme.of(context).textTheme.title),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Letzte Aktualisierung: " +
                                model.lastRefreshText),
                            SizedBox(
                              height: 20,
                            ),
                            buildButton(
                              "Daten aktualisieren",
                              () => model.setup(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            buildButton(
                              "Token zurücksetzen",
                              () => model.setToken(""),
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
                            PlatformText("Kursauswahl",
                                style: Theme.of(context).textTheme.title),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                "Mit der Kursauswahl-Funktion kannst du den Stundenplan eines Dozenten oder anderen Kurses einsehen."),
                            SizedBox(
                              height: 20,
                            ),
                            Builder(
                              builder: (context) {
                                if (model.isInPeekMode()) {
                                  return buildButton(
                                    "Zurücksetzen",
                                    () => model.setPeek(null),
                                  );
                                } else {
                                  return buildButton(
                                    "Kurs wählen",
                                    () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
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
      },
    );
  }
}
