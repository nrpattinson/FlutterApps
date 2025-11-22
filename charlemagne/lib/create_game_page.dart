import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:charlemagne/game.dart';
import 'package:charlemagne/main.dart';

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
# Charlemagne, Master of Europe

The death of Carloman in 771 left his twenty-nine year old brother
Charles in control of the Frankish Empire. What Charles did with that
power over the course of the next forty-plus years is the stuff of legend.
His unparalleled achievements in warfare, diplomacy, administration, and
culture led to the sobriquet Carolus Magnus: Charles the Great:
Charlemagne, King of the Franks and of the Lombards, and Emperor of
the Romans.

In this solitaire strategy game, you assume the Frankish throne, and seek
to duplicate—or exceed—Charlemagne’s singular genius, while hopefully
avoiding some of his mistakes, such as the famous defeat at Roncevaux
(immortalized in the Song of Roland). As you conquer new territory and
incorporate it into your empire, you'll need to contend with rebels and
palace intriguers. Building public works and patronizing the Carolingian
Renaissance will increase your prestige and wealth. Along the way you'll
need to win the support of the papacy, buy off Viking marauders, convert
the pagans in Saxony, contend with incursions from Moorish Spain (Al‐Andalus),
and maintain detente with the Byzantine Empire.

Like its spiritual predecessor *Agricola, Master of Britain*, this game
models the consent of the governed (or lack thereof) with a series of
three opaque containers, the contents of which secretly change in
reaction to the actions you take. Do something that people like, and the
populace leans friendly. Do something they don’t, and they lean in the
other direction, inviting rebellions from within and invasions from without.
Over the course of your long reign, these subtle adjustments will pile up,
resulting in a game state that reacts to you and reflects the character and
effectiveness of your rule. This makes it a solitaire gaming experience in
which your decisions matter. You’re not fighting against the vagaries of an
event deck, trying to outsmart a braindead AI, or finding loopholes in a
flowchart. Your job is to govern a vast and fractious empire with a savvy
combination of wisdom and ruthlessness.
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
