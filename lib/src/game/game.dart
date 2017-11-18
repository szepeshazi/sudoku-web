import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:sudoku_core/sudoku_core.dart';
import 'package:sudoku_web/src/board/board.dart';

@Component(
    selector: 'game',
    templateUrl: 'game.html',
    styleUrls: const ['game.css'],
    directives: const [NgFor, NgIf, BoardComponent, MaterialButtonComponent, MaterialSpinnerComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class GameComponent implements OnInit {

  final ChangeDetectorRef _changeDetectorRef;

  SudokuBoard board;
  List<List<EliminationResult>> steps;
  bool inProgress = true;

  GameComponent(this._changeDetectorRef);

  @override
  void ngOnInit() {

    board = createFromLiteral(hard);
    SudokuBoard solvedBoard = createFromLiteral(hard);

    _changeDetectorRef.markForCheck();

    var game = new SudokuGame();
    final steps = game.solve(solvedBoard);
    _changeDetectorRef.markForCheck();
    inProgress = false;
  }

  SudokuBoard createFromLiteral(List<List<int>> boardDefinition) {
    SudokuBoard thisBoard = new SudokuBoard();

    List<List<SudokuCell>> transformedRows =
    hard.map((row) => row.map((value) => new SudokuCell()..value = value)).toList();
    thisBoard.rows = transformedRows;

    return thisBoard;
  }

}
