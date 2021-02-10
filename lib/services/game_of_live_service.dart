import 'dart:async';

import 'package:game_of_life/services/cellModel.dart';

class GameOfLiveService {
  final int _worldSize;
  bool _isPlayToggle;

  final List<List<CellModel>> _worldTiles;

  final StreamController<List<List<CellModel>>> _controller$ =
      StreamController<List<List<CellModel>>>();

  final StreamController<bool> _playToggle$ = StreamController<bool>();

  StreamSubscription<dynamic> _streamSubscription;

  GameOfLiveService(int worldSize)
      : _worldSize = worldSize,
        _worldTiles = new List(worldSize) {
    _isPlayToggle = true;
    _playToggle$.add(_isPlayToggle);
  }

  Stream<bool> get playToggle$ => _playToggle$.stream;
  Stream<List<List<CellModel>>> get worldTiles$ => _controller$.stream;

  void initWorld() {
    _setRandomWorld();
  }

  void closeSimulation() {
    _controller$.close();
    _streamSubscription.cancel();
  }

  CellModel getCellModel(int col, int row) => _worldTiles[col][row];

  void startWorldIteration() {
    if (_isPlayToggle) {
      _runWorldIterationPeriod();
    } else {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }

    _isPlayToggle = !_isPlayToggle;
    _playToggle$.add(_isPlayToggle);
  }

  void _runWorldIterationPeriod() {
    Stream period = Stream.periodic(Duration(milliseconds: 100));
    _streamSubscription = period.listen((data) => _runWorldIteration());
  }

  void _runWorldIteration() {
    var worldTiles = _checkIfCellLives();
    _controller$.add(worldTiles);
  }

  void _setRandomWorld() {
    for (var i = 0; i < _worldSize; i++) {
      _worldTiles[i] = List();
      List<CellModel> cells = List.generate(
        _worldSize,
        (row) => CellModel.setRandomStatus(),
      );
      _worldTiles[i].addAll(cells);
    }
    _controller$.add(_worldTiles);
  }

  List<List<CellModel>> _checkIfCellLives() {
    List<List<CellModel>> auxWorldTiles = List.from(_worldTiles);
    auxWorldTiles.asMap().forEach((colIndex, rowArray) => {
          rowArray.asMap().forEach((rowIndex, cell) =>
              cell.isAlive = _checkNeighbour(rowIndex, colIndex))
        });
    return auxWorldTiles;
  }

  bool _checkNeighbour(colPosition, rowPosition) {
    List<int> rowLimits = _getLimits(rowPosition);
    List<int> colLimits = _getLimits(colPosition);

    CellModel currentCell = _worldTiles[colPosition][rowPosition];

    var totalNeighbourAlive = 0;

    for (int i = colLimits[0]; i < colLimits[1] + 1; i++) {
      for (int j = rowLimits[0]; j < rowLimits[1] + 1; j++) {
        if (_worldTiles[i][j].isAlive && _worldTiles[i][j] != currentCell) {
          totalNeighbourAlive++;
        }
      }
    }

    bool newCellState = currentCell.isAlive;
    if (currentCell.isAlive) {
      if (totalNeighbourAlive < 2 || totalNeighbourAlive > 3) {
        newCellState = false;
      }
    } else {
      if (totalNeighbourAlive == 3) {
        newCellState = true;
      }
    }

    return newCellState;
  }

  List<int> _getLimits(positionInMatrix) {
    var startIndex = positionInMatrix - 1 < 0 ? 0 : positionInMatrix - 1;
    var endIndex = positionInMatrix + 1 > _worldSize - 1
        ? _worldSize - 1
        : positionInMatrix + 1;
    return [startIndex, endIndex];
  }
}
