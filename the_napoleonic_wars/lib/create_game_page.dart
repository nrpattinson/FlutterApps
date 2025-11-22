import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:the_napoleonic_wars/game.dart';
import 'package:the_napoleonic_wars/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  Scenario? _scenario = Scenario.year1792;

  static const gameDescription = '''
# N: The Napoleonic Wars

N: The Napoleonic Wars is a high level, grand strategic
solitaire game on the turbulent decades from 1792 to 1815,
when Europe was convulsed by the French Revolution and
the wars of French Emperor Napoléon I. You play the
monarchist “coalitions” of Europe – led by Britain – fighting
to put down the ‘Corsican ogre’ and restore peace, order, and
a bit of the Divine Right of Kings to the Continent. N is not a
detailed, tactical historical simulation, but is designed as a
fun, challenging game illustrating the general course of the
wars and their salient historical themes. N is the second title
in my British Wars Trilogy, and is based on Don’t Tread on Me,
my game of the American Revolution (White Dog Games,
2014/15). If you have played DTOM, then many of N’s
mechanics will be familiar. Each of the 16 Turns takes about
10 minutes to play (longer for beginners). There are two
shorter scenarios (see other booklet) if you don’t want to fight
out the entire three-decade grand campaign.
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
                  DropdownButtonFormField<Scenario>(
                    decoration: const InputDecoration(
                      labelText: 'Scenario',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _scenario,
                    items: Scenario.values.map((Scenario scenario) {
                      return DropdownMenuItem<Scenario>(
                        value: scenario,
                        child: Text(scenario.longDesc));
                      }).toList(),
                    onChanged: (Scenario? scenario) {
                      setState(() {
                        _scenario = scenario;
                      });
                    },
                    validator: (Scenario? scenario) {
                      if (scenario == null) {
                        return 'Please select a Scenario';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          appState.newGame(_scenario!, GameOptions());
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
