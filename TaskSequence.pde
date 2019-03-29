class TaskSequence extends Task {
  Task[] tasks;

  TaskSequence(Blackboard bb, Task[] tl) {
    this.blackboard = bb;
    this.tasks = tl;
  }

  boolean execute() {
    for (int i = 0; i < tasks.length; i++) {
      if (!tasks[i].execute()) {
        return false;
      }
    }

    return true;
  }
}