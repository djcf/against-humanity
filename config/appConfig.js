// Custom settings and variables
module.exports.appConfig = {
  numberOfAnswersBeforeChoosingBest : 1, // Every n times the user answers a question, we let them ask another one.
  minAnswersPerQuestion : 1, // should be 4
  singleUserMode : true, // In single user mode, the user can answer their own questions and questions are recycled.

  winsUntilLoginPrompt: 4 // A.k.a. "win mode" for this simple POC. Number of times the user must "win" until this step. TODO: More OO.
};