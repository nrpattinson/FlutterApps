import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:aurelian/game.dart';
import 'package:aurelian/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  static const gameDescription = '''
# Aurelian, Restorer of the World

The Roman Empire is broken. The crisis of the third century—a decades‐long
fever dream of civil war, plague, and economic ruin—stretched it
thinner and thinner, until finally, inevitably, it splintered. The Palmyrene
Empire to the east, the Gallic Empire to the west, and sandwiched
between them, the remnants of the Roman Empire. Deprived of its richest
provinces and stuck in a series of endless wars along the frontier, it
seemed destined, at last, to fall. But in 270, when the emperor died,
troops along the Danube did what troops along the Danube always did,
and demanded that their commander take the purple. His name was
Lucius Domitius Aurelianus, and over the course of his short reign, he
would do the impossible: he would put this broken world back together
again.

**Aurelian, Restorer of the World** is a solitaire game from Tom Russell, the
designer of *Agricola, Master of Britain* and *Charlemagne, Master of
Europe*. Like those titles, three cups are used to represent shifting
attitudes toward Aurelian's rule; actions you take will move chits from one
cup to another. This game is shorter and faster than the two previous
games, lasting a maximum of six turns. It's also more difficult. Beyond
marching around the map, quelling revolts, and smacking down usurpers,
you must manage monies, maintain a strong defensive line along the
Danube, make war against Germanic tribes, build up city defenses, and
spread the cult of Sol Invictus. You do not have nearly enough time or
resources to do all of these things equally well and will need to make
hard choices. If you succeed, you will earn the title afforded to Aurelian by
the senate: Restitutor Orbis, “Restorer of the World”.
''';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final rootWidget = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 50.0),
          const SizedBox(
            width: 500.0,
            child: MarkdownBody(data: gameDescription),
          ),
          const SizedBox(width: 40.0),
          SizedBox(
            width: 300.0,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          appState.newGame(Scenario.standard, GameOptions());
                        }
                      },
                      child: const Text('Create Game'),
                    ),
                  )
                ],
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset('assets/images/thumbnail.png', height: 528, width: 408),
            ),
          ),
        ],
      ),
    );

    return rootWidget;
  }
}
