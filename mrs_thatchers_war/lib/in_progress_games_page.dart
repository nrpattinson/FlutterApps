import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mrs_thatchers_war/db.dart';
import 'package:mrs_thatchers_war/main.dart';

class InProgressGamesPage extends StatefulWidget {

  const InProgressGamesPage({super.key});

  @override
  InProgressGamesPageState createState() {
    return InProgressGamesPageState();
  }

}

class InProgressGamesPageState extends State<InProgressGamesPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return FutureBuilder(
      future: GameDatabase.instance.fetchGameInProgressList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
        return DataTable(
          columns: const [
            //DataColumn(label: Text('Scenario')),
            //DataColumn(label: Text('Options')),
            DataColumn(label: Text('Begun')),
            DataColumn(label: Text('Last Move')),
            DataColumn(label: Text('Turn')),
            DataColumn(label: Text('Resume')),
            DataColumn(label: Text('Duplicate')),
            DataColumn(label: Text('Delete'))
          ],
          rows: data
            .map((e) => DataRow(
              cells: [
                //DataCell(Text(Scenario.values[e['scenario'] as int].desc)),
                //DataCell(Text(GameOptions.fromJson(jsonDecode(e['optionsJson'])).desc)),
                DataCell(Text(DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(e['startTime'] as int)))),
                DataCell(Text(DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(e['updateTime'] as int)))),
                DataCell(Text(e['stage'] as String)),
                DataCell(IconButton(
                  iconSize: 24,
                  icon: const Icon(Icons.start),
                  onPressed: () {
                    appState.resumeGame(e['gameId'] as int);
                  },
                )),
                DataCell(IconButton(
                  iconSize: 24,
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    appState.duplicateGame(e['gameId'] as int);
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
