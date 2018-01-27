import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:sudoku_core/sudoku_core.dart';
import 'package:sudoku_web/src/board/board.dart';

@Component(
    selector: 'game',
    templateUrl: 'game.html',
    styleUrls: const ['game.css'],
    directives: const [
      NgFor,
      NgIf,
      BoardComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialSpinnerComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class GameComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  SudokuBoard board;
  List<EliminationResult> steps;
  EliminationResult currentStep;
  EliminationResult undoCurrentStep;
  Timer gameTimer;

  int currentStepIndex = -1;
  bool inProgress = true;
  bool isPlaying = false;

  GameComponent(this._changeDetectorRef);

  @override
  void ngOnInit() {
    board = new SudokuBoard.fromLiteral(easy);
    SudokuBoard solvedBoard = new SudokuBoard.fromLiteral(easy);

    _changeDetectorRef.markForCheck();

    var game = new SudokuGame();
    steps = game.solve(solvedBoard);
    _changeDetectorRef.markForCheck();
    inProgress = false;
  }


  void back() {
    if (isPlaying) {
      isPlaying = false;
      gameTimer?.cancel();
    }
    if (currentStepIndex >= 0) {
      undoCurrentStep = steps[currentStepIndex--];
      currentStep = null;
      _changeDetectorRef.markForCheck();
    }
  }

  void forward() {
    if (isPlaying) {
      isPlaying = false;
      gameTimer?.cancel();
    }
    if (++currentStepIndex < steps.length) {
      currentStep = steps[currentStepIndex];
      undoCurrentStep = null;
      _changeDetectorRef.markForCheck();
    }
  }

  void pause() {
    isPlaying = false;
    gameTimer?.cancel();
  }

  void play() {
    isPlaying = true;
    gameTimer = new Timer.periodic((new Duration(seconds: 1)), (_) {
      if (++currentStepIndex < steps.length) {
        currentStep = steps[currentStepIndex];
        undoCurrentStep = null;
        _changeDetectorRef.markForCheck();
      } else {
        gameTimer.cancel();
      }
    });
  }
}
