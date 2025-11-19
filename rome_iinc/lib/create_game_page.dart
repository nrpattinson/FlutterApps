import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rome_iinc/game.dart';
import 'package:rome_iinc/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  Scenario? _scenario = Scenario.from286CeTo363Ce;
  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# Rome, IInc.
### From Diocletian to Heraclius

***ROME, IInc.*** is a game of the Late Roman Empire (the period from
Diocletian to Heraclius) for one player, or two co-operating players. A sequel
to the popular ***ROME, Inc.*** you again will be running the Roman Empire like
a business, but this time the barbarians are well and truly at the gates.
Together the players operate behind the scenes, promoting and removing
emperors, governors, and the occasional pope.

When corporate axeman Diocletian terminated his predecessor in the finest
traditions of ***ROME, Inc.***, no one expected a complete rebranding
operation. Realizing that something new was needed to revive the flagging
fortunes of a corporate dinosaur he made his friend Maximinus co-CEO in a
new east-west operation, ***ROME, IInc.*** Players can accept the challenge
solo, or share control of the empire with a partner, one in the East, and the
other in the West.

Together or alone, you control the mechanics of a failing empire, choosing
five distinct “starting points” (286 CE, 363 CE, 425 CE, 497 CE and 565 CE)
and run scenarios lasting 10-50 turns, depending on your corporate acumen
and endurance. Each turn represents 5-10 years, with 10 turns in each of
the five scenarios. If you already own ***ROME, Inc.*** you can extend the game
into ***ROME, IInc.*** for a truly epic 90 turn game charting the rise and fall of
history’s greatest empire.

Historical statesmen are not only rated for their abilities as a commander,
administrator, and intriguer, but their devotion to the Christian Orthodoxy,
and each has a special ability to give him an edge. Every turn sees crises
and challenges that the players must deal with, to expand, or sometimes
simply to survive.
''';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final rootWidget = FittedBox(
      fit: BoxFit.scaleDown,
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
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Events',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.eventCountModifier,
                    items: const [
                      DropdownMenuItem<int>(value: -1, child: Text('-1 (Easier)')),
                      DropdownMenuItem<int>(value: 0, child: Text('Standard')),
                      DropdownMenuItem<int>(value: 1, child: Text('+1 (Harder)')),
                    ],
                    onChanged: (int? eventCountModifier) {
                      setState(() {
                        if (eventCountModifier != null) {
                          _options.eventCountModifier = eventCountModifier;
                        }
                      });
                    },
                    validator: (int? eventCountModifier) {
                      if (eventCountModifier == null) {
                        return 'Please select number of Events modifier';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Tax Rolls',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.taxRollModifier,
                    items: const [
                      DropdownMenuItem<int>(value: -1, child: Text('-1 (Easier)')),
                      DropdownMenuItem<int>(value: 0, child: Text('Standard')),
                      DropdownMenuItem<int>(value: 1, child: Text('+1 (Harder)')),
                    ],
                    onChanged: (int? taxRollModifier) {
                      setState(() {
                        if (taxRollModifier != null) {
                          _options.taxRollModifier = taxRollModifier;
                        }
                      });
                    },
                    validator: (int? taxRollModifier) {
                      if (taxRollModifier == null) {
                        return 'Please select Tax Rolls modifier';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'War Rolls',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.warRollModifier,
                    items: const [
                      DropdownMenuItem<int>(value: -1, child: Text('-1 (Easier)')),
                      DropdownMenuItem<int>(value: 0, child: Text('Standard')),
                      DropdownMenuItem<int>(value: 1, child: Text('+1 (Harder)')),
                    ],
                    onChanged: (int? warRollModifier) {
                      setState(() {
                        if (warRollModifier != null) {
                          _options.warRollModifier = warRollModifier;
                        }
                      });
                    },
                    validator: (int? warRollModifier) {
                      if (warRollModifier == null) {
                        return 'Please select War Rolls modifier';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Dismiss Auxilia',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.dismissAuxiliaCount,
                    items: const [
                      DropdownMenuItem<int>(value: 2, child: Text('2 (Standard)')),
                      DropdownMenuItem<int>(value: 3, child: Text('3 (Harder)')),
                    ],
                    onChanged: (int? dismissAuxiliaCount) {
                      setState(() {
                        if (dismissAuxiliaCount != null) {
                          _options.dismissAuxiliaCount = dismissAuxiliaCount;
                        }
                      });
                    },
                    validator: (int? dismissAuxiliaCount) {
                      if (dismissAuxiliaCount == null) {
                        return 'Please select number of Auxilia to Dismiss for a Loss';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Tribute',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.tributeAmount,
                    items: const [
                      DropdownMenuItem<int>(value: 10, child: Text('10 (Standard)')),
                      DropdownMenuItem<int>(value: 15, child: Text('15 (Harder)')),
                    ],
                    onChanged: (int? tributeAmount) {
                      setState(() {
                        if (tributeAmount != null) {
                          _options.tributeAmount = tributeAmount;
                        }
                      });
                    },
                    validator: (int? tributeAmount) {
                      if (tributeAmount == null) {
                        return 'Please select Tribute amount for a Loss';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Lifetimes',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.finiteLifetimes,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Standard')),
                      DropdownMenuItem<bool>(value: true, child: Text('Finite')),
                    ],
                    onChanged: (bool? finiteLifetimes) {
                      setState(() {
                        if (finiteLifetimes != null) {
                          _options.finiteLifetimes = finiteLifetimes;
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
