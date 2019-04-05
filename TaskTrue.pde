class TaskTrue extends Task {
  Task task;

  TaskTrue(Blackboard bb, Task t) {
    this.blackboard = bb;
    this.task = t;
  }

  boolean execute() {
    task.execute();
    return true;
  }
}