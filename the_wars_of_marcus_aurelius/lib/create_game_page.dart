import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:the_wars_of_marcus_aurelius/game.dart';
import 'package:the_wars_of_marcus_aurelius/main.dart';

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
# The Wars of Marcus Aurelius

170CE. Plague ravages the Empire. With the Legions depleted by disease
and spread thin across the endless frontier, opportunistic Germanic tribes
and fierce Sarmatian raiders strike across the Danube deep into Imperial
territory. To face this threat, the Emperor Marcus Aurelius, an untested
commander who has never set foot outside of Italy, must transform
himself from an introspective philosopher into a cunning warrior and
fearless leader.

This debut game from filmmaker and designer Robert DeLeskie was
created for BoardGameGeek's annual Wargame PNP Contest, where it
was crowned the Overall Winner. Additionally it won all but one of the
other categories in which it competed, including Best Rules, Most Original
Concept, Best Solitaire Game, Best Strategic Scale Game, and Best
Short/Quick/Small Game.

Working with Hollandspiele's development team and playtesters, Mr.
DeLeskie has expanded upon his original design, resulting in a richer and
more varied decision space that rewards repeated plays and multiple
strategies.
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
