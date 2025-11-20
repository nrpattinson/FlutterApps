import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_caesar/db.dart';
import 'package:solitaire_caesar/game.dart';
import 'package:solitaire_caesar/main.dart';

class CompletedGamesPage extends StatefulWidget {

  const CompletedGamesPage({super.key});

  @override
  CompletedGamesPageState createState() {
    return CompletedGamesPageState();
  }

}

class CompletedGamesPageState extends State<CompletedGamesPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return FutureBuilder(
      future: GameDatabase.instance.fetchGameCompletedList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
        return DataTable(
          columns: const [
            //DataColumn(label: Text('Scenario')),
            DataColumn(label: Text('Options')),
            DataColumn(label: Text('Begun')),
            DataColumn(label: Text('Ended')),
            DataColumn(label: Text('Dynasty')),
            DataColumn(label: Text('Replay')),
            DataColumn(label: Text('Delete'))
          ],
          rows: data
            .map((e) => DataRow(
              cells: [
                //DataCell(Text(Scenario.values[e['scenario'] as int].desc)),
                DataCell(Text(GameOptions.fromJson(jsonDecode(e['optionsJson'])).desc)),
                DataCell(Text(DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(e['startTime'] as int)))),
                DataCell(Text(DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(e['finishTime'] as int)))),
                DataCell(Text(e['stage'] as String)),
                DataCell(IconButton(
                  iconSize: 24,
                  icon: const Icon(Icons.start),
                  onPressed: () {
                    appState.replayCompletedGame(e['gameId'] as int);
                  },
                )),
                DataCell(IconButton(
                  iconSize: 24,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    appState.deleteGame(e['gameId'] as int);
                  },
                )),
              ],
            ))
            .toList(),
        );
      },
    );
  }
}
