class TaskNot extends Task {
  Task task;

  TaskNot(Blackboard bb, Task t) {
    this.blackboard = bb;
    this.task = t;
  }

  boolean execute() {
    return !task.execute();
  }
}