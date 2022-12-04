abstract class Solver<TInput, TOutput> {

  String get dartCodeFilename;

  TOutput getSolution(TInput input);

}
