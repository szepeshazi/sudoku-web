import 'dart:async';
import 'package:angular/angular.dart';
import 'package:sudoku_core/sudoku_core.dart';
import 'package:sudoku_web/src/cell/cell.dart';

@Component(
    selector: 'board',
    templateUrl: 'board.html',
    styleUrls: const ['board.css'],
    directives: const [NgFor, NgIf, CellComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class BoardComponent {
  final ChangeDetectorRef _changeDetectionRef;
  SudokuBoard _board;

  BoardComponent(this._changeDetectionRef);

  @Input()
  set board(SudokuBoard newValue) {
    _board = newValue;
    _changeDetectionRef.markForCheck();
  }

  SudokuBoard get board => _board;

  EliminationResult _currentStep;
  List<CellLocation> relatedCells;

  @Input()
  set currentStep(EliminationResult newValue) {
    _currentStep = newValue;
    relatedCells = _currentStep.offendingLocations;
    board.elementAt(_currentStep.location).removeCandidate(_currentStep.value);
    _changeDetectionRef.markForCheck();
    new Timer(new Duration(milliseconds: 800), () {
      _currentStep = null;
      relatedCells = null;
      _changeDetectionRef.markForCheck();
    });
  }

  bool isHighlighted(int i, int j) => (i == _currentStep?.location?.y && j == _currentStep?.location?.x);

  bool isRelated(int i, int j) =>
      (relatedCells ?? const <CellLocation>[]).isNotEmpty && relatedCells.any((cell) => i == cell.y && j == cell.x);
}
