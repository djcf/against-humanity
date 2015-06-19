// Custom settings and variables
module.exports.appConfig = {
  numberOfAnswersBeforeChoosingBest : 4, // Every n times the user answers a question, we let them ask another one.
  minAnswersPerQuestion : 4, // should be 4
  substituteNumberOfAIAnswersIfNumberOfHumanAnswersIsFewerThan: 2, // will substitute AI answers if user has this number of human ones
  singleUserMode : true // In single user mode, the user can answer their own questions and questions are recycled.
};