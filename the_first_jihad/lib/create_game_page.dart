import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:the_first_jihad/game.dart';
import 'package:the_first_jihad/main.dart';

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
# The First Jihad
### The Rise of Islam 632 - 750

The First Jihad is a solitaire board game by award-
winning designers Ben Madison (Jeff Davis,
Margaret Thatcher's War, Nubia, Gorbachev,
N: The Napoleonic Wars, The White Tribe, and
more) and Wes Erni, simulating the rise of the first
Arab Caliphate, which spread the new religion of
Islam across wide areas of the Middle East, Africa,
Asia and Europe. The player controls the forces of
fourteen empires and kingdoms against the
invading Arab (Muslim) armies, with the aim of
pushing these invaders back before they are
successful in driving all the player’s armies to the
edges of the world and converting his
populations to Islam.
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
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Game',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.advanced,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Standard')),
                      DropdownMenuItem<bool>(value: true, child: Text('Finite')),
                    ],
                    onChanged: (bool? advanced) {
                      setState(() {
                        if (advanced != null) {
                          _options.advanced = advanced;
                        }
                      });
                    },
                    validator: (bool? finiteLifetimes) {
                      if (finiteLifetimes == null) {
                        return 'Please select Lifetimes option';
                      }
                      return null;
                    },
                  ),
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
