// Behavior tree task
abstract public class Task {
  Blackboard blackboard;
  // Executes task and returns if it succeeded
  abstract boolean execute();
}
