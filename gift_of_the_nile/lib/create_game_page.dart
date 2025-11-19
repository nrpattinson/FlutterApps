import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gift_of_the_nile/game.dart';
import 'package:gift_of_the_nile/main.dart';

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
# Gift of the Nile
### The Rise & Fall of Ancient Egypt

**GIFT OF THE NILE** is a solitaire game where you play the
Pharaohs of Ancient Egypt’s many successive ruling dynasties
beginning in 2686 BC.

The goal of the game is to build a prosperous, victorious
Egyptian Empire. On a map of Northeast Africa, you will annex
the various “Sepats” (chiefdoms) that you encounter. As you
build enduring monuments like the Pyramids and the Valley of
the Kings, hostile foreign powers like Kush, Persia, and the
Hittites will aim to push you back to your Nile Valley heartland
and threaten your vast capital city at Men-Nefer (better known
as Memphis).

All the while, you must civilize the country by building temples
to the Gods of Egypt like Isis, Osiris, and Amun-Ra – or suffer
their wrath!

In the end, incest and debauchery threaten the Ptolemaic Greek
dynasty that produced Cleopatra and you must defeat the
brutal and efficient Romans.

Your place in history will depend on your empire-building skills,
as well as on a little bit of luck!
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
                      labelText: 'Late Period Iron',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.latePeriodIron,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('No possibility of Iron')),
                      DropdownMenuItem<bool>(value: true, child: Text('Possibility of Iron')),
                    ],
                    onChanged: (bool? latePeriodIron) {
                      setState(() {
                        if (latePeriodIron != null) {
                          _options.latePeriodIron = latePeriodIron;
                        }
                      });
                    },
                    validator: (bool? latePeriodIron) {
                      if (latePeriodIron == null) {
                        return 'Please select Late Period Iron option';
                      }
                      return null;
                    },
                  ),
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
