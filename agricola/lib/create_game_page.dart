import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:agricola/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  static const gameDescription = '''
# Agricola, Master of Britain

It is the year of Vespasian and Titus - the sixth such ordinary consulship that Titus
shared with his imperial father. The civil war of a decade ago is but a memory, and
the Flavians have restored peace and order to all corners of the empire, save one. The
people of Britannia remain fiercely resistant to the will of their Roman masters, and
the emperor has charged YOU with the seemingly impossible task of bringing them
to heel.

 *Agricola: Master of Britain* is a solitaire game of governance and conquest. To
master the delicate political situation, you will need the right blend of military force,
administration, bribery, and diplomacy. Every action you take matters, changing how
the native populace feels about you and yout rule. But you’ll never know exactly
who’s with you or against you.

Building the right armies, and taking the right actions at the right time is key to your
success. But the Flavians — and particularly the hated Domitian — expect greater and
greater results with each campaign season. You’ll need to meet and exceed them if
you want to duplicate Agricola’s achievement.
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          appState.newGame();
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
