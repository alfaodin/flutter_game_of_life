import 'package:flutter/material.dart';

import 'package:game_of_life/services/cellModel.dart';

class CellWidget extends StatelessWidget {
  final CellModel cellModel;

  const CellWidget({@required this.cellModel});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(.5),
        decoration: BoxDecoration(
          color: cellModel.isAlive ? Colors.amber[600] : Colors.blue[50],
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
