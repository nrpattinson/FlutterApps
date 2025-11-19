import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:solitaire_caesar/game.dart';
import 'package:solitaire_caesar/main.dart';

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
  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# Solitaire Caesar
## The Rise and Fall of the Roman Empire

Command Roman legions to build an empire that will last forever!

Carry the Roman eagle into uncivilized provinces.

Struggle to preserve the empire against invading barbarian tribes.

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
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Barbarian Numbers',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.smootherBarbarianNumbers,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Standard')),
                      DropdownMenuItem<bool>(value: true, child: Text('Smoother')),
                    ],
                    onChanged: (bool? smootherBarbarianNumbers) {
                      setState(() {
                        if (smootherBarbarianNumbers != null) {
                          _options.smootherBarbarianNumbers = smootherBarbarianNumbers;
                        }
                      });
                    },
                    validator: (bool? smootherBarbarianNumbers) {
                      if (smootherBarbarianNumbers == null) {
                        return 'Please select Barbarian Numbers option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'The Emperor',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.emperor,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Ignored')),
                      DropdownMenuItem<bool>(value: true, child: Text('Represented')),
                    ],
                    onChanged: (bool? emperor) {
                      setState(() {
                        if (emperor != null) {
                          _options.emperor = emperor;
                        }
                      });
                    },
                    validator: (bool? emperor) {
                      if (emperor == null) {
                        return 'Please select The Emperor option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Skilled General',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.skilledGeneral,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Ignored')),
                      DropdownMenuItem<bool>(value: true, child: Text('Represented')),
                    ],
                    onChanged: (bool? skilledGeneral) {
                      setState(() {
                        if (skilledGeneral != null) {
                          _options.skilledGeneral = skilledGeneral;
                        }
                      });
                    },
                    validator: (bool? skilledGeneral) {
                      if (skilledGeneral == null) {
                        return 'Please select Skilled General option';
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
