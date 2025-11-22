import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stilicho/game.dart';
import 'package:stilicho/main.dart';

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
# Stilicho: Last of the Romans

The Goths are marching on Rome! In Gaul, Vandals and Alans pour across
the Rhine. Meanwhile, a usurper from distant Britannia has raised his
standard. The survival of the Western Empire depends on one man:
Flavius Stilicho, barbarian general, commander-in-chief of the armies of
Rome, and defacto ruler of the West.

*Stilicho: Last of the Romans* is the long-anticipated follow-up to
designer Robert DeLeskie's popular and challenging solitaire game
*Wars of Marcus Aurelius*. The brain-boiling card angst and nail-
biting combats that made that game so compelling are back, along with
some new wrinkles that make for a more challenging and nuanced
decision space. For example, the Surge mechanism that caused so many
gamers to invent new curse words is now more nefarious, with each
enemy card having specific surge effects. Rome's enemies sometimes
bump into each other, resulting in enemy-on-enemy battles. Regions
might go into revolt, garrisons might defect to the banner of the
pretender Constantine III, and the wily courtier Olympius might turn the
emperor Honorius against you.

No wonder the historical Stilicho only lasted until turn 3! If you want to
win, you'll have to last much longer than that, all while taking on tougher
and more resilient enemies than poor Marcus had to face, and with less
resources at your disposal. Will you prevent the sack of Rome and the fall
of the Western Empire?
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
