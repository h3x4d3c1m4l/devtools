import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day07Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 7;
  
  @override
  String getSolution(String input) {
    List<String> terminalInputOutput = input.splitLines().toList(growable: false);

    // parse terminal input/output to file system structure
    List<_Folder> folders = [];
    _Folder? currentFolder;
    _Folder? rootFolder;
    for (String ioLine in terminalInputOutput) {
      if (ioLine.startsWith('\$ cd ..')) {
        // go back one folder
        currentFolder = currentFolder!.parent;
      } else if (ioLine.startsWith('\$ cd ')) {
        // go inside folder
        _Folder newFolder = _Folder(currentFolder, ioLine.substring(5), []);
        folders.add(newFolder);
        if (currentFolder != null) {
          currentFolder.children.add(newFolder);
        }
        currentFolder = newFolder;
        rootFolder ??= newFolder;
      } else if (ioLine.startsWith('\$ ls')) {
        // list folder contents
      } else {
        // show contents of current folder
        var splitLine = ioLine.split(' ');
        if (splitLine[0] == 'dir') {
          currentFolder!.children.add(_Folder(currentFolder, splitLine[1], []));
        } else {
          currentFolder!.children.add(_File(currentFolder, splitLine[1], int.parse(splitLine[0])));
        }
      }
    }
    
    // part 1
    int totalFolderSize = folders
        .where((folder) => folder.size <= 100000)
        .sumBy((folder) => folder.size);

    // part 2
    int spaceNeeded = 30000000 - (70000000 - rootFolder!.size);
    int largeEnoughFolderSize = folders.where((folder) => folder.size >= spaceNeeded).minBy((folder) => folder.size);

    return 'Total folder size: $totalFolderSize\nLarge enough folder size: $largeEnoughFolderSize';
  }

}

class _Folder extends _FileSystemObject {

  final List<_FileSystemObject> children;

  _Folder(super.parent, super.name, this.children);

  @override
  int get size => children.sumBy((folder) => folder.size);

}

class _File extends _FileSystemObject {

  final int _size;

  _File(super.parent, super.name, int size): _size = size;

  @override
  int get size => _size;

}

abstract class _FileSystemObject {

  const _FileSystemObject(this.parent, this.name);

  final _Folder? parent;
  final String name; 

  int get size;

}
