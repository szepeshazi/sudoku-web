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
  List<EliminationResult> _step;

  BoardComponent(this._changeDetectionRef);

  @Input()
  set board(SudokuBoard newValue) {
    _board = newValue;
    _changeDetectionRef.markForCheck();
    anim();
  }

  SudokuBoard get board => _board;

  @Input()
  set step(List<EliminationResult> eliminations) {
    _step = eliminations;
  }

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
