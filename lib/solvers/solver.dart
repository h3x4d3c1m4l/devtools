abstract class Solver<TInput, TOutput> {

  String get problemUrl;

  String get solverCodeFilename;

  TOutput getSolution(TInput input);

}
