import 'package:flutter/material.dart';

import 'package:game_of_life/services/cellModel.dart';
import 'package:game_of_life/components/cellWidget.dart';

class WorldWitget extends StatelessWidget {
  final int worldSize;
  final List<List<CellModel>> worldTiles;

  const WorldWitget({
    @required this.worldSize,
    @required this.worldTiles,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        child: _generateWord(),
      ),
    );
  }

  Widget _generateWord() {
    return Column(
      children: List.generate(
        worldSize,
        (col) => Expanded(
          child: Row(
            children: List.generate(
              worldSize,
              (row) => CellWidget(
                cellModel: worldTiles[col][row],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
