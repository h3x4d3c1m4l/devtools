import 'package:characters/characters.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day09Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 9;

  @override
  String getSolution(String input) {
    List<String> fileSystem = input.trim().characters.mapIndexed((i, c) => List.filled(int.parse(c), i.isEven ? (i ~/ 2).toString(): '.')).flattened.toList();

    // Part 1
    for (int i = fileSystem.length - 1; i >= 0; i--) {
      if (fileSystem[i] == '.') continue;

      bool done = false;
      for (int j = 0; j < fileSystem.length; j++) {
        if (i == j - 1) {
          done = true;
          break;
        }

        if (fileSystem[j] == '.') {
          fileSystem[j] = fileSystem[i];
          fileSystem[i] = '.';
          break;
        }
      }

      if (done) break;
    }
    int checksumPart1 = _calculateChecksum(fileSystem);

    // Part 2 (Note: It's slow, e.g. takes about 1m30 on Apple M2 Pro in debug mode)
    List<(int?, int)> fileSystemParts = input.trim().characters.mapIndexed((i, c) => i.isEven ? (i ~/ 2, int.parse(c)) : (null, int.parse(c))).toList();
    for (int i = fileSystemParts.length - 1; i >= 0; i--) {
      if (fileSystemParts[i] case (null, _)) continue;

      for (int j = 0; j < i; j++) {
        if (fileSystemParts[j] case (null, int emptySpaceLength)) {

          if (emptySpaceLength >= fileSystemParts[i].$2) {
            int fileLength = fileSystemParts[i].$2;
            fileSystemParts[j] = fileSystemParts[i];
            fileSystemParts[i] = (null, fileSystemParts[i].$2);
            if (emptySpaceLength > fileLength) {
              fileSystemParts.insert(j + 1, (null, emptySpaceLength - fileLength));
              i++;
            }
            break;
          }
        }
      }
    }
    fileSystem = fileSystemParts.expand((part) => part.$1 == null ? List.filled(part.$2, '.') : List.filled(part.$2, part.$1!.toString())).toList();
    int checksumPart2 = _calculateChecksum(fileSystem);

    return 'Checksum part 1: $checksumPart1, checksum part 2: $checksumPart2';
  }

  int _calculateChecksum(List<String> fileSystem) {
    int checksum = 0;
    for (int i = 0; i < fileSystem.length; i++) {
      if (fileSystem[i] == '.') continue;
      checksum += i * int.parse(fileSystem[i]);
    }
    return checksum;
  }

}
