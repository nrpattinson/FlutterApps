import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:the_white_tribe/game.dart';
import 'package:the_white_tribe/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  Scenario? _scenario = Scenario.standard;
  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# The White Tribe
## Rhodesia’s War, 1966–1980

*The White Tribe* is a strategic solitaire (one
player) game on the 1966-1980 civil war in the
African nation of Rhodesia (today called Zimbabwe).
Published by White Dog Games and designed by R. Ben
Madison, it is the second game in Ben Madison’s Cold
War Trilogy series. The player plays the forces of
the White minority government (and its Portuguese
and South African allies) against the “ZANU” and
“ZAPU” guerrilla forces which eventually won the war
with Chinese and Soviet aid. The game focuses on
domestic and international politics as much as it
does on the military conflict itself. Players should
be aware that they are a tiny country fighting a war
in a world beyond their control.
 
It’s not a detailed historical simulation, but is
designed as a fun, challenging game that illustrates
the general strategic course of the conflict and
highlights important historical themes.
 
*The White Tribe* is a unique SOLITAIRE game with
military and political aspects. You play the White
government of Rhodesia, besieged by a Black
guerrilla army, using your potent armed forces to
hold it back while you try to persuade your
colonialist voters to compromise and move to a
system of Black majority rule. The balance of
military and political factors makes for an
intriguing and very different sort of game; you'll
fight guerrillas, fight elections, and even pass
bills with the same level of tension! Advancing
generous policy positions, to win over African
public opinion, can endanger you with the
European voters you depend on for power. At the same
time, you have to persuade foreign states that your
reforms are moving forward -- they have different
visions for Rhodesia than you do, and they can bring
you down with economic sanctions or military
strikes. And looming over you are the unstable
Portuguese, whose empire in Mozambique is vital
to your strategic safety! Your aim is to build a
government based on justice and equality, while
holding off extremists on every side using all your
military and political tools.
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
                          appState.newGame(_scenario!, _options);
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
