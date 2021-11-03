import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../game_provider.dart';
import './question_creator_screen.dart';

class GameCreatorScreen extends StatefulWidget {
  static const route = '/game_creator_screen';
  const GameCreatorScreen({Key? key}) : super(key: key);

  @override
  _GameCreatorScreenState createState() => _GameCreatorScreenState();
}

class _GameCreatorScreenState extends State<GameCreatorScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text('Games',textAlign: TextAlign.center, style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.amberAccent,
        ),),
        backgroundColor: CupertinoColors.tertiaryLabel,
      ),
      body: Column(

        children: [_buildListCreator(), SizedBox(height: 40),

           Expanded(child: _buildGame())],

      ),
    );
  }

  Widget _buildListCreator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        color: Colors.amberAccent,
        elevation: 10, borderRadius: BorderRadius.circular(12),
        child: TextField(
          controller: textController,
          decoration: const InputDecoration(
            prefixIcon : Icon(
              Icons.add_box_rounded,
              color: Colors.black,
              size: 30,),
              labelText: 'Add a game', labelStyle: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,),  contentPadding: EdgeInsets.all(20),),


          onEditingComplete: addGame,
        ),
      ),
    );
  }

  void addGame() {
    final text = textController.text;

    final controller = GameProvider.of(context);
    controller.addNewGame(text);

    textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
  }

  Widget _buildGame() {
    final games = GameProvider.of(context).games;

    if (games.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      const Icon(
      Icons.note,
        size: 100,
        color: Colors.black,
      ),
          //  Image(
          //   image: AssetImage('assets/space-1.jpg'),
          // ),


          Text(
            'You do not have any games yet.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Dismissible(
            key: ValueKey(game),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              final controller = GameProvider.of(context);
              controller.deleteGame(game);
              setState(() {});
            },
            child: ListTile(
              title: Text(game.name),
              subtitle: Text(game.numberOfTasksMessage()),

              onTap: () {
                //Navigator.of(context).pushNamed(QuestionCreatorScreen.route, arguments: game);
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) => GameProvider(child: MaterialApp(home: QuestionCreatorScreen(game: game)))));
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => QuestionCreatorScreen(game: game)));
              },
            ));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}
