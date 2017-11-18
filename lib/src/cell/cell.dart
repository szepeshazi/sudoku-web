import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:sudoku_core/sudoku_core.dart';

@Component(
    selector: 'cell',
    templateUrl: 'cell.html',
    styleUrls: const ['cell.css'],
    directives: const [materialDirectives, NgFor, NgIf],
    providers: const [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class CellComponent {

  SudokuCell _cell;
  bool _highlight = false;
  ChangeDetectorRef _changeDetectionRef;

  CellComponent(this._changeDetectionRef);

  @Input()
  set cell(SudokuCell newValue) {
    _cell = newValue;
    _changeDetectionRef.markForCheck();
  }

  SudokuCell get cell => _cell;

  @Input()
  set highlight(bool newValue) {
    if (newValue != _highlight) {
      _highlight = newValue;
      _changeDetectionRef.markForCheck();
    }
  }

  bool get highlight => _highlight;

  final List<int> cellIndex = const [0, 1, 2];
  static const int cellSize = 3;

  String getCandidate(int i, int j) =>
      cell.candidates.firstWhere((cd) => cd == (i* cellSize + j + 1), orElse: () => null)?.toString() ?? '_';
}
