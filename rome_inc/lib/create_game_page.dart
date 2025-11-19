import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rome_inc/game.dart';
import 'package:rome_inc/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }
}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  Scenario? _scenario = Scenario.from27BceTo70Ce;
  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# Rome, Inc.
### From Augustus to Diocletian

***ROME, INC.*** by designer Philip Jelley, is a solitaire game of the Roman
Empire. The premise is that the player runs the operations of the Roman
Empire like a business, but with a bit more blood, bread and circuses. After
hostile takeovers of such competitors, like Carthage, Greece and Gaul,
Rome has been incorporated into an empire, ready to monopolize the
ancient world. But this requires the efforts of many, some who might be in it
for themselves. As the player, you are not “the Emperor” - you select and
replace emperors, and all the statesmen under him.

***ROME, INC.*** begins with the “startup” of the Roman Empire under Augustus
in 27 BCE to Diocletian in 286 CE. You’ll control the workings of the empire
throughout, although you can pick four distinct “starting points” (27 BCE, 70
CE, 138 CE and 222 CE) and run scenarios of any length you like, depending
on your corporate acumen and endurance. Each turn represented 5-10
years, with 10 turns in each of the four scenarios.

Historical statesmen are rated for their military and administrative talents,
popularity, and skill at intrigue, and each has a special ability. Every turn
sees crises and challenges that the player must deal with - much like a
modern CEO. Increase “stock” by expanding the empire and triumphing
over enemies, like the “barbarians at the gate” or internal agitators. But can
your management maintain a good *Return on Investment*?

The map consists of provinces grouped into military commands such as
Britannia and Syria, each commanded by a governor. Provinces may be
controlled by barbarians, allies or insurgents, which can be conquered and
developed into peaceful tax-payers. Beyond these are the homelands from
where barbarian wars and enemy leaders pillage their way from province to
province until defeated.

You decide where to allocate resources (capital spending), raise new forces
(hiring), undertake prestige projects (public relations), pleasing the mob
(shareholders), or even setting aside a reserve for a rainy decade or two.
You’ll need to blend military expansion with careful administration, as well
as intrigue, making the most of what you have each turn, just like any
modern-day business.

***ROME, INC.*** will give you a new perception of how war is a cost, business is
a benefit, and empire is somewhere in between. It’s up to you to find a
balance.
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
            child: MarkdownBody(
              data: gameDescription),
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
