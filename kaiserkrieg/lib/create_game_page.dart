import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kaiserkrieg/game.dart';
import 'package:kaiserkrieg/main.dart';

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
# Kaiserkrieg!
### The Great War 1914-1918

“Kaiserkrieg!” (‘Emperor’s War!’) is a strategic solitaire game of
the First World War of 1914-1918. As the player, you control the
Central Powers (“CP”; Germany, AustriaHungary, Turkey and
Bulgaria). The game’s automatic systems direct the efforts of the
Entente Powers (“EP”; France, Britain, Russia, Italy, Serbia, the
United States, and their minor allies) who are trying to defeat you.
As in many of Ben Madison's games, you play the “bad guys.”  

The heart of the game is its depiction of the ground war, which
saw the battlefield deaths of some ten million soldiers.
Kaiserkrieg’s treatment can be traced back to Darin Leviloff’s
inspired Israeli Independence (2008) and the “States of Siege”
system it started. The evolutionary leap in Kaiserkrieg! is the
shift from the old ‘horizontal’ States of Siege model – where
enemy forces converge on your central position along clearly
defined lines of advance – to a new ‘vertical’ model where
enemy forces mass in separate regions around you, to eventually
achieve an advantage in size that threatens your overall position.
This adaptation allows Leviloff’s original concept to more closely
simulate the trench warfare realities of World War I on the
continental level.

The game also depicts the epic naval struggle of pro-German
blockade runners trying to evade fleets of British cruisers. Many
historians identify the failure to outwit the British naval blockade
as the main reason for Germany’s defeat in the war.

The ‘sideshow’ war in the Near East, where Germany’s Ottoman
Turkish ally was assailed by Russia and the British Empire –
including a massive army of Indian troops – is also simulated.
This theater also includes East Africa, where a German-led Black
African army (the Askari) held out against Indian and British
Empire forces even after the Germans in Europe had
surrendered!

The game is an uber-strategic view of the conflict. Some aspects
are dramatically simplified to make it playable and to emphasize
the “cool stuff” of World War I, like Zeppelins, trenches, and U-
boats. Kaiserkrieg! is not a detailed historical simulation, but a
fun and challenging game covering the salient themes of the
actual conflict.
''';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final rootWidget = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                      labelText: 'British Cruiser Commissioning',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.historicalCruisers,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Random')),
                      DropdownMenuItem<bool>(value: true, child: Text('Historical')),
                    ],
                    onChanged: (bool? historicalCruisers) {
                      setState(() {
                        if (historicalCruisers != null) {
                          _options.historicalCruisers = historicalCruisers;
                        }
                      });
                    },
                    validator: (bool? historicalCruisers) {
                      if (historicalCruisers == null) {
                        return 'Please select British Cruisers option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'The Hundred Days',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.theHundredDays,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('One Turn Chit')),
                      DropdownMenuItem<bool>(value: true, child: Text('Two Turn Chits')),
                    ],
                    onChanged: (bool? theHundredDays) {
                      setState(() {
                        if (theHundredDays != null) {
                          _options.theHundredDays = theHundredDays;
                        }
                      });
                    },
                    validator: (bool? theHundredDays) {
                      if (theHundredDays == null) {
                        return 'Please select The Hundred Days option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Indians Attack Askari',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.indiansTwoRolls,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('One Roll')),
                      DropdownMenuItem<bool>(value: true, child: Text('Two Rolls')),
                    ],
                    onChanged: (bool? indiansTwoRolls) {
                      setState(() {
                        if (indiansTwoRolls != null) {
                          _options.indiansTwoRolls = indiansTwoRolls;
                        }
                      });
                    },
                    validator: (bool? indiansTwoRolls) {
                      if (indiansTwoRolls == null) {
                        return 'Please select Indians Attack Askari option';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          appState.newGame(Scenario.campaign, _options);
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
