import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sword_of_orthodoxy/game.dart';
import 'package:sword_of_orthodoxy/main.dart';

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
# Sword of Orthodoxy
### The Rise and Fall of Byzantium - AD 421-1453

*Constantinople!* The name is legendary if you make it
so! As barbarians sack the West, the Eastern Roman Empire
lives on from that Queen of Cities under your command from
421 AD to the end of the 15th century. You are the Basileus
(Emperor), and no aspect of life escapes your rule in *Sword of
Orthodoxy* - the Rise and Fall of Byzantium.

In this thousand year epic of heroism, betrayal, faith, and
intrigue, you build enduring monuments like the Theodosian
Walls and Hagia Sophia Cathedral. Juggle factions, riots,
rogue Crusaders, and greedy aristocrats, all while mutilating
the noses of your political rivals! Send Orthodox Patriarchs
to convert Kyiv and the Bulgars, and liberate isolated
monasteries vital to your culture. Enact reforms and build
hospitals and universities to jumpstart the Renaissance.
Command brilliant generals like Belisarius to build your empire
from Spain to Mesopotamia, as you fight off historic enemies
from Persia to the Ottomans in this strategic solitaire board
war game of the rise and fall of Byzantium, designed by
Charles S. Roberts Award winnder R. Ben Madison.
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
            width: 400.0,
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
                      labelText: 'Red Die Advances',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.redRandomBarbarians,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Ignored')),
                      DropdownMenuItem<bool>(value: true, child: Text('Enabled')),
                    ],
                    onChanged: (bool? redRandomBarbarians) {
                      setState(() {
                        if (redRandomBarbarians != null) {
                          _options.redRandomBarbarians = redRandomBarbarians;
                        }
                      });
                    },
                    validator: (bool? redRandomBarbarians) {
                      if (redRandomBarbarians == null) {
                        return 'Please select Red Die Random Advances option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Islam Event',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.islamEvent,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Ignored')),
                      DropdownMenuItem<bool>(value: true, child: Text('Enabled')),
                    ],
                    onChanged: (bool? islamEvent) {
                      setState(() {
                        if (islamEvent != null) {
                          _options.islamEvent = islamEvent;
                        }
                      });
                    },
                    validator: (bool? islamEvent) {
                      if (islamEvent == null) {
                        return 'Please select Islam Event option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Circled Events',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.circledEvents,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Ignored')),
                      DropdownMenuItem<bool>(value: true, child: Text('Enabled')),
                    ],
                    onChanged: (bool? circledEvents) {
                      setState(() {
                        if (circledEvents != null) {
                          _options.circledEvents = circledEvents;
                        }
                      });
                    },
                    validator: (bool? circledEvents) {
                      if (circledEvents == null) {
                        return 'Please select Circled Events option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Military and Political Events',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.separateMilitaryPoliticalEvents,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Combined Roll')),
                      DropdownMenuItem<bool>(value: true, child: Text('Separate Rolls')),
                    ],
                    onChanged: (bool? separateMilitaryPoliticalEvents) {
                      setState(() {
                        if (separateMilitaryPoliticalEvents != null) {
                          _options.separateMilitaryPoliticalEvents = separateMilitaryPoliticalEvents;
                        }
                      });
                    },
                    validator: (bool? separateMilitaryPoliticalEvents) {
                      if (separateMilitaryPoliticalEvents == null) {
                        return 'Please select Military and Political Events option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Ecumenical Council Timing',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.controlEcumenicalCouncils,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Random')),
                      DropdownMenuItem<bool>(value: true, child: Text('Controlled')),
                    ],
                    onChanged: (bool? controlEcumenicalCouncils) {
                      setState(() {
                        if (controlEcumenicalCouncils != null) {
                          _options.controlEcumenicalCouncils = controlEcumenicalCouncils;
                        }
                      });
                    },
                    validator: (bool? controlEcumenicalCouncils) {
                      if (controlEcumenicalCouncils == null) {
                        return 'Please select Ecumenical Council Timing option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Justinian and Civil War',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.justinianCivilWar,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('No Civil War')),
                      DropdownMenuItem<bool>(value: true, child: Text('Civil War Possible')),
                    ],
                    onChanged: (bool? justinianCivilWar) {
                      setState(() {
                        if (justinianCivilWar != null) {
                          _options.justinianCivilWar = justinianCivilWar;
                        }
                      });
                    },
                    validator: (bool? justinianCivilWar) {
                      if (justinianCivilWar == null) {
                        return 'Please select Justinian and Civil War option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Pope Removed',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.italyImportant,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('East–West Schism')),
                      DropdownMenuItem<bool>(value: true, child: Text('East–West Schism and Italy Lost')),
                    ],
                    onChanged: (bool? italyImportant) {
                      setState(() {
                        if (italyImportant != null) {
                          _options.italyImportant = italyImportant;
                        }
                      });
                    },
                    validator: (bool? italyImportant) {
                      if (italyImportant == null) {
                        return 'Please select Pope Removed option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Patriarchs',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.historicalPatriarchs,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Random')),
                      DropdownMenuItem<bool>(value: true, child: Text('Historical')),
                    ],
                    onChanged: (bool? historicalPatriarchs) {
                      setState(() {
                        if (historicalPatriarchs != null) {
                          _options.historicalPatriarchs = historicalPatriarchs;
                        }
                      });
                    },
                    validator: (bool? historicalPatriarchs) {
                      if (historicalPatriarchs == null) {
                        return 'Please select Patriarchs option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Seljuk Colonization',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.anatolianPlateau,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('All Paths')),
                      DropdownMenuItem<bool>(value: true, child: Text('Persian Path')),
                    ],
                    onChanged: (bool? anatolianPlateau) {
                      setState(() {
                        if (anatolianPlateau != null) {
                          _options.anatolianPlateau = anatolianPlateau;
                        }
                      });
                    },
                    validator: (bool? anatolianPlateau) {
                      if (anatolianPlateau == null) {
                        return 'Please select Seljuk Colonization option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<bool>(
                    decoration: const InputDecoration(
                      labelText: 'Armenian Revolt',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: false,
                    value: _options.armeniansAndOttomans,
                    items: const [
                      DropdownMenuItem<bool>(value: false, child: Text('Always Succeeds')),
                      DropdownMenuItem<bool>(value: true, child: Text('Success Subject to Die Rolls')),
                    ],
                    onChanged: (bool? armeniansAndOttomans) {
                      setState(() {
                        if (armeniansAndOttomans != null) {
                          _options.anatolianPlateau = armeniansAndOttomans;
                        }
                      });
                    },
                    validator: (bool? armeniansAndOttomans) {
                      if (armeniansAndOttomans == null) {
                        return 'Please select Armenian Revolt option';
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
