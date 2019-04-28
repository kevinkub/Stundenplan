import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stundenplan/model.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void checkTokenInClipboard() async {
    final data = await Clipboard.getData('text/plain');
    handlePotentialToken(data.text);
  }

  void handlePotentialToken(String input) {
    final regex = RegExp(r"[a-f0-9]{32}");
    final match = regex.firstMatch(input);
    if (null != match) {
      ScopedModel.of<AppModel>(context).setToken(match.group(0));
      return;
    }
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return PlatformAlertDialog(
          title: PlatformText("Fehler. Token konnte nicht gefunden werden."),
          actions: <Widget>[
            PlatformDialogAction(
              child: PlatformText("Schließen"),
              onPressed: () => Navigator.pop(context, 'Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Authentifizierung erforderlich"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  'assets/authentication.svg',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                padding: EdgeInsets.all(64),
              ),
              Text(
                  "Willkommen in der Stundenplan-App für FHDW und bib. Um deinen Stundenplan anzeigen zu können, benötigt die App einen sogenannten Zugriffstoken."),
              Text(
                  "Um den Token auf diesem Gerät zu generieren, wähle \"Token generieren\", folge der Anleitung im Intranet und kopiere den Link \"persönlichen iCal-Feed\". Kehre danach zu dieser Anwendung zurück und wähle \"Token importieren\"."),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    PlatformButton(
                      child: PlatformText("Token generieren"),
                      onPressed: () {
                        launch('https://intranet.fhdw.de/ical-access');
                      },
                    ),
                    PlatformButton(
                      child: PlatformText("Token importieren"),
                      onPressed: () {
                        checkTokenInClipboard();
                      },
                    ),
                  ],
                ),
              ),
              Text(
                  "Alternativ kannst du auch die Seite https://intranet.fhdw.de/ical-access bzw. https://intranet.bib.de/ical-access mit einem anderen Gerät öffnen und den Token generieren. Anschließend kannst du den QR-Code scannen und bist ebenfalls angemeldet."),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: PlatformButton(
                  child: PlatformText("QR-Code scannen"),
                  onPressed: () {
                    new QRCodeReader().scan().then((value) {
                      handlePotentialToken(value);
                    });
                  },
                ),
              ),
              Text(
                  "Falls etwas nicht funktionieren sollte, kannst du mich gerne kontaktieren."),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: PlatformButton(
                  child: PlatformText("Entwickler kontaktieren"),
                  onPressed: () => launch('ma' +
                      'ilt' +
                      'o:stunde' +
                      'nplan-app' +
                      '@' +
                      'kekub.de?subject=Stundenplan-App%20Feedback&body=Hallo%20Kevin,'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
