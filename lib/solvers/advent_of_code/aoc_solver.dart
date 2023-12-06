import 'package:h3x_devtools/solvers/solver.dart';
import 'package:h3x_devtools/storage.dart';
import 'package:http/http.dart' as http;

abstract class AdventOfCodeSolver extends Solver<String, String> {

  int get dayNumber;
  int get yearNumber;

  @override
  String get challengeUrl => 'https://adventofcode.com/$yearNumber/day/$dayNumber';

  @override
  String get solverCodeFilename => 'day_${dayNumber.toString().padLeft(2, '0')}_solver.dart';

  @override
  String get solverCodeGitHubUrl => 'https://github.com/h3x4d3c1m4l/devtools/tree/main/lib/solvers/advent_of_code/$yearNumber/$solverCodeFilename';

  Future<String> getPuzzleInput() async {
    // First check if the input is already cached
    final input = readAdventOfCodeInput(yearNumber, dayNumber);
    if (input != null) return input;
    
    // It seems it isn't, let's try to download it
    final inputUrl = Uri.https('adventofcode.com', '$yearNumber/day/$dayNumber/input');
    final sessionCookieValue = await getAdventOfCodeSession();
    final httpResponse = await http.read(inputUrl, headers: {'Cookie': 'session=$sessionCookieValue'});

    // Persist to cache
    await storeAdventOfCodeInput(yearNumber, dayNumber, httpResponse);

    return httpResponse;
  }

}
