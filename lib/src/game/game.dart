import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_progress/material_progress.dart';
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
      MaterialSpinnerComponent,
      MaterialProgressComponent
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
  int progress = 0;
  bool inProgress = true;
  bool isPlaying = false;

  @ViewChild('dragButton')
  ElementRef dragButton;

  GameComponent(this._changeDetectorRef);

  @override
  void ngOnInit() {
    board = new SudokuBoard.fromLiteral(hard);
    SudokuBoard solvedBoard = new SudokuBoard.fromLiteral(hard);

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
    updateProgress();
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
    updateProgress();
  }

  void pause() {
    isPlaying = false;
    gameTimer?.cancel();
  }

  void play() {
    isPlaying = true;
    gameTimer = new Timer.periodic((new Duration(milliseconds: 100)), (_) {
      if (++currentStepIndex < steps.length) {
        currentStep = steps[currentStepIndex];
        undoCurrentStep = null;
        _changeDetectorRef.markForCheck();
      } else {
        isPlaying = false;
        gameTimer.cancel();
      }
    updateProgress();
    });
  }

  void updateProgress() {
    progress = ((currentStepIndex + 1) / (steps?.length ?? 1) * 100).toInt();
    var offset = (progress * 520 / 100 - 12).toInt();
    dragButton.nativeElement.style.left = "${offset}px";
  }

  String get currentStepReason {
    String reason;
    if (currentStep == null) return '';
    if (currentStep.reason == EliminationRule.valueInSameRow) {
      reason = '${currentStep.value} can\'t be at this location as it is already present in the same row.';
    }
    if (currentStep.reason == EliminationRule.valueInSameColumn) {
      reason = '${currentStep.value} can\'t be at this location as it is already present in the same column.';
    }
    if (currentStep.reason == EliminationRule.valueInSameSection) {
      reason = '${currentStep.value} can\'t be at this location as it is already present in the same 3x3 section.';
    }
    if (currentStep.reason == EliminationRule.isOtherSingleCandidateInSection) {
      reason = '${currentStep.value} isOtherSingleCandidateInSection';
    }
    if (currentStep.reason == EliminationRule.valueLockedByOtherSection) {
      reason = '${currentStep.value} valueLockedByOtherSection';
    }
    return reason;
  }
}
