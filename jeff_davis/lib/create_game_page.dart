import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jeff_davis/game.dart';
import 'package:jeff_davis/main.dart';

class CreateGamePage extends StatefulWidget {

  const CreateGamePage({super.key});

  @override
  CreateGamePageState createState() {
    return CreateGamePageState();
  }

}

class CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();

  final GameOptions _options = GameOptions();

  static const gameDescription = '''
# Jeff Davis
## The Confederacy at War
*Jeff Davis: The Confederacy at War* is a solitaire board
war game designed by Charles S. Roberts Award-winner
R. Ben Madison. You play President Jefferson Davis,
managing the Confederate government and the Southern
war effort. Your choices help determine the fate of great
armies and the titanic struggle between Lee and Grant as
well as peripheral or more dispersed campaigns like
Morgan’s Ohio raid and Indian Territory. Decide
which famous generals are worthy of scarce artillery and
ironclads resources, while you unleash bushwhackers
behind Union lines and rush reinforcements into battle on
your rickety rail network. Back in Richmond, you’ll push
the Confederate Congress to enact your reforms and
overcome the inefficiency of States’ Rights as you defend
key cities vital to your political survival. Dispatch your
cabinet members as economic troubleshooters to prop up
agriculture, industry and infrastructure for the war effort.
Slavery is a major factor in your economy, but you will
pay for most of your actions through the cat-and-mouse
game of blockade running. Choose which armies to
supply or if to invade the North as you calculate where
the next Union hammer might fall. Can you hold out long
enough to trigger British and French intervention? Re-
fight the Civil War as Jeff Davis!
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          appState.newGame(Scenario.standard, _options);
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
