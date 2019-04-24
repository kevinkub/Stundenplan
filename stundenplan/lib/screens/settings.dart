import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/model.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return CupertinoTabView(builder: (context) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Einstellungen"),
          ),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    elevation: 12,
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
                    elevation: 12,
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
                          Text("Letzte Aktualisierung: " + model.lastRefreshText),
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
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
