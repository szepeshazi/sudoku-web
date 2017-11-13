import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:sudoku_core/sudoku_core.dart';
import 'package:sudoku_web/src/cell/cell.dart';

@Component(
    selector: 'board',
    templateUrl: 'board.html',
    styleUrls: const ['board.css'],
    directives: const [materialDirectives, NgFor, NgIf, CellComponent],
    providers: const [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class BoardComponent {
  SudokuBoard _board;

  bool ready = false;

  ChangeDetectorRef _changeDetectionRef;

  BoardComponent(this._changeDetectionRef);

  @Input()
  set board(SudokuBoard newValue) {
    _board = newValue;
    var rules = new SudokuRules(_board);
    var eliminated = 0;
    for (var location in _board.asMap.keys) {
      List<EliminationResult> eliminations = rules.evaluate(location, useAdvancedRules: false);
      if ((eliminations ?? const []).isNotEmpty) {
        for (var elimination in eliminations) {
          SudokuCell cell = _board.elementAt(location);
          cell.removeCandidate(elimination.value);
          eliminated++;
          if (cell.value != null) {
            _board.cleanUp(location);
          }
        }
      }
    }
    ready = true;
    _changeDetectionRef.markForCheck();
    anim();
  }

  SudokuBoard get board => _board;

  bool state = false;

  bool isHighlighted(int i, int j) => (state && i == 5 && j == 5);

  Future anim() async {
    Completer completer = new Completer<bool>();
    new Timer(new Duration(seconds: 1), () => completer.complete(true));
    await completer.future;
    state = true;
    _changeDetectionRef.markForCheck();
  }
}
