abstract class Solver<TInput, TOutput> {

  String get challengeUrl;

  String get solverCodeFilename;

  String get solverCodeGitHubUrl;

  TOutput getSolution(TInput input);

}
