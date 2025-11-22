import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:black_skin_black_shirt/game.dart';
import 'package:black_skin_black_shirt/main.dart';

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
# Black Skin Black Shirt
## Ethiopia vs. Fascist Italy 1935–37
**Black Skin Black Shirt: Ethiopia vs Fascist Italy 1935–1937** is an historical board game from Ben Madison,
designer of Byzantium, Global War, The Mission, N, Kaiserkrieg, Don't Tread on Me, and other popular games.
The game simulates the 1935–1937 war between Ethiopia and Fascist Italy that presaged the titanic conflict
we know as World War Two. Take charge of Ethiopia’s defenses and call up troops as Mussolini’s Italy
attempts to enlarge its empire at your expense. Turn the tide of history against Fascism in this exciting,
easy‐to‐play, solitaire board game.
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
                          appState.newGame(Scenario.standard, _options);
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
