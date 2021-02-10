import 'package:flutter/material.dart';

import 'package:game_of_life/services/cellModel.dart';
import 'package:game_of_life/components/worldWidget.dart';
import 'package:game_of_life/services/game_of_live_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game of life',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GameOfLiveService _gameOfLiveService;

  @override
  void initState() {
    super.initState();
    _gameOfLiveService = GameOfLiveService(20);
    _gameOfLiveService.initWorld();
  }

  void _runWorldSimulation() {
    _gameOfLiveService.startWorldIteration();
  }

  void _resetWorld() {
    _gameOfLiveService.initWorld();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<List<List<CellModel>>>(
                stream: _gameOfLiveService.worldTiles$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return WorldWitget(
                      worldTiles: snapshot.data,
                      worldSize: snapshot.data.length,
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: _resetWorld,
                child: Icon(Icons.auto_fix_high),
              ),
            ),
            StreamBuilder<bool>(
                stream: _gameOfLiveService.playToggle$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: _runWorldSimulation,
                        child: Icon(snapshot.data == true
                            ? Icons.play_arrow
                            : Icons.stop_circle_outlined),
                      ),
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
