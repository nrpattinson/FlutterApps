import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:china_inc/game.dart';
import 'package:china_inc/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  Scenario? _scenario = Scenario.from1644CeTo1735Ce;
  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# China, Inc.
### Qing & GMD 1644–1949

***China, Inc.*** is a solitaire game of the history of China from the founding of the
Qing Dynasty in 1644 to the end of the Chinese Civil War of 1949. After establishing
itself in their native Manchuria, the Qing Dynasty conquered China, Mongolia,
Xinjiang, and Tibet until it becomes the largest, richest, most populous empire in the
world. The Qing Emperors became increasingly detached from reality in the
Forbidden City, in the power of the palace eunuchs while China was ravaged by
internal rebellions and threatened by foreign invasion. The dynasty staggered on
until 1912 when it was replaced by the Republic of China led by the Guomindang
(Chinese Nationalist Party).

Chinese Statesmen represent emperors, presidents, governors, rebels, and have
Military, Administration, Reform, and Intrigue abilities. Each has a special ability,
allowing them to defeat their historic enemies, assassinate rivals, and influence
foreign affairs. The map is made up of provinces grouped into ten commands, each
with a governor who collects taxes, fights wars, and increases Chinese cultural
dominance, but may assassinate the emperor or launch a rebellion. Victory is
decided by increasing Prestige through annexing provinces, defeating wars, and
establishing the Mandate of Heaven across Asia. Cavalry, Banner, militia, and fleets
are used to fight wars and garrison provinces, expanding direct control, and creating
vassal provinces as buffer states. Enemy leaders and wars move from province to
province encouraging revolts, increasing unrest, reducing income until they are
defeated. Unequal Treaties imposed by foreign powers deprive China of provinces,
prestige, and cash as they expand their colonial empires. Each turn represents 5–10
years, with 10 turns in each scenario. The four scenarios start in 1644, 1735, 1820,
and 1889 and may be combined into campaign games. Players should average 3 to 4
hours per scenario.
''';

  static const credits = '''
### Designed by Philip Jelley
### Graphics by Philip Jelley
### Programming © 2025 Nigel Pattinson
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
                      labelText: 'Dismiss Militia',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.dismissMilitiaCount,
                    items: const [
                      DropdownMenuItem<int>(value: 2, child: Text('2 (Standard)')),
                      DropdownMenuItem<int>(value: 3, child: Text('3 (Harder)')),
                    ],
                    onChanged: (int? dismissMilitiaCount) {
                      setState(() {
                        if (dismissMilitiaCount != null) {
                          _options.dismissMilitiaCount = dismissMilitiaCount;
                        }
                      });
                    },
                    validator: (int? dismissMilitiaCount) {
                      if (dismissMilitiaCount == null) {
                        return 'Please select number of Militia to Dismiss for a Loss';
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
          Column(
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.asset('assets/images/thumbnail.png', height: 528, width: 408),
                ),
              ),
              const MarkdownBody(data: credits),
            ],
          ),
        ],
      ),
    );

    return rootWidget;
  }
}
