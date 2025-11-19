import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:empire_of_grass/game.dart';
import 'package:empire_of_grass/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# Empire of Grass
## The Conquests of Genghis Khan

**Empire of Grass: The Conquests of Genghis Khan** is a
solitaire game about the Mongol invasions of large portions of
Eurasia in the thirteenth century under the great Genghis Khan.
You play the role of the Mongol Khan, attempting, like him, to
create the greatest steppe empire the world has ever known—
The Empire of Grass.

You and an initial force of horsemen start in Mongolia. Using
this small but fierce Mongolian army, you must attempt to
conquer vast areas of the Eurasian continent (represented by
the 37 area cards) thus creating an empire. To do this,
you must attempt to capture or raze rich foreign cities, defeat
large enemy armies, and recruit additional populations into
your growing realm. Along the way, various random events will
affect your strategies and decisions. Meanwhile, press enemies
determined to resist your rule hard as there is limited time until
the Khan—great as you may turn out to be, you are still mortal—
passes to The Afterlife, and the game will end.
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
            width: 350.0,
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
                          appState.newGame(_options);
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
