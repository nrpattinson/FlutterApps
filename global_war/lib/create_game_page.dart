import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:global_war/game.dart';
import 'package:global_war/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }
}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  Scenario? _scenario = Scenario.campaign;

  static const gameDescription = '''
# Global War
### World War II Worldwide 1939-1945

A grand strategic war game on a small scale, **GLOBAL
WAR: World War II Worldwide 1939-1945** lets you
fight all of World War II in one three hour sitting!
Smaller scenarios can be played in less time.

You will fight epic carrier battles in the Pacific while
Panzer armies roll across the Eastern Front. Use
wartime leaders like Churchill and Stalin to achieve
your military goals from Western Europe and Russia
to Ethiopia, China, and Southeast Asia. Build fleets of
convoys to outwit German U-Boats, as you support
armed partisan resistance. Employ the unique skills
of generals like Patton, Montgomery, MacArthur, and
Zhukov to defy the fascist aggressors. Wage the Battle
of Britain in a struggle for control of the skies. Task
your scientists to develop A-Bombs. Conduct bombing
missions to batter Axis morale and industrial capacity,
as Axis offensives put your own morale to the test. Hit
the beaches at Normandy, and fight epic battles at
Stalingrad, Imphal, and Guadalcanal, to determine the
fate of the globe - for this is **GLOBAL WAR**!
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
