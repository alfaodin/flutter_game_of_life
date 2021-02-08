import 'dart:math';

class CellModel {
  bool _isAlive;

  CellModel.setRandomStatus() : this._isAlive = new Random().nextInt(10) >= 5;

  bool get isAlive => _isAlive;

  set isAlive(isAlive) => _isAlive = isAlive;
}
