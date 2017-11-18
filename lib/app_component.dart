import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:sudoku_core/sudoku_core.dart';
import 'package:sudoku_web/src/board/board.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [materialDirectives, BoardComponent],
    providers: const [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class AppComponent {
  SudokuBoard board = new SudokuBoard();

  AppComponent() {
    List<List<SudokuCell>> transformedRows =
        hard.map((row) => row.map((value) => new SudokuCell()..value = value)).toList();
    board.rows = transformedRows;
  }
}
