import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:the_mission/game.dart';
import 'package:the_mission/main.dart';

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
# THE MISSION: Early Christianity from the Crucifixion to the Crusades

 *The Mission* is a “grand strategy” solitaire game by Ben
Madison (Gorbachev, N, The White Tribe, The First Jihad, and
more)  covering almost 1,300 years of Christian history. While
the secular world of empires and politics plays out around
you, your apostles and missionaries spread the faith,
translating the Bible and converting areas of the map
to Christianity. Each turn covers several decades. The flow of
play teaches players about the expansion and doctrinal battles
of early Christianity while you build institutions like
universities, hospitals, and monasteries to educate, heal, and
inspire the societies you touch.

Internally, heresies and schisms in the Church will try to
thwart your plans while external forces threaten you. Pressing
against you are barbarian hordes, some of which you may
convert. And when the armies of Islam arrive, the game
changes from one of missionary outreach to one of survival,
as Christian communities hunker down under siege during the
long Dark Ages. Perhaps you will rise again in a blaze of
glory as Christendom finally fights back, using the Crusades
and the Spanish Reconquista to recover lost provinces!

Beginners and experienced gamers will find this an
intriguing and very different kind of game. While certainly a
war of ideas, it is still very much a war game, where victory
depends upon managing scarce resources (including Holy
Relics!) and making shrewd strategic decisions to benefit the
Church. The Mission is a power-politics overview of the Early
Church from its beginnings through the Crusades, but one
that never loses sight of the importance of church-building
and pastoral ministry.
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
