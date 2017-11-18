import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:sudoku_web/src/game/game.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [GameComponent],
    providers: const [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class AppComponent { }
