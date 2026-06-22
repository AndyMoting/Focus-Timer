import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/models/task_plan_settings.dart';

class DeletedTaskSnapshot {
  final Task task;
  final List<TaskPlan> plans;

  const DeletedTaskSnapshot({required this.task, required this.plans});
}

abstract class TaskRepository {
  // 任务 CRUD
  Future<int> createTask(TasksCompanion task);
  Future<List<Task>> getTasksByList(int listId);
  Future<List<Task>> getTasksByActiveLists();
  Future<void> updateTask(TasksCompanion task);
  Future<int> cloneTask(int id, {int? targetListId});
  Future<void> moveTaskToList(int id, int targetListId, int sortOrder);
  Future<DeletedTaskSnapshot?> deleteTask(int id);
  Future<void> restoreDeletedTask(DeletedTaskSnapshot snapshot);
  Future<List<Task>> getFutureReminderTasks({int? nowMs});
  Future<void> completeTask(int id);
  Future<void> uncompleteTask(int id);
  Future<void> completeAllActiveTasks();
  Future<int> applyDailyReset(int todayDayNum);
  Future<void> reorderTasks(int listId, List<int> taskIdsInOrder);

  // 分组管理
  Future<int> createList(TaskListsCompanion list);
  Future<List<TaskList>> getActiveLists();
  Future<List<TaskList>> getDeletedLists();
  Future<int> countTasksByList(int listId);
  Future<void> updateList(TaskListsCompanion list);
  Future<void> reorderLists(List<int> listIdsInOrder);
  Future<void> softDeleteList(int id);
  Future<List<int>> softDeleteEmptyLists();
  Future<List<int>> softDeleteAllLists();
  Future<void> restoreList(int id);
  Future<void> permanentDeleteList(int id);

  // 计划模式
  Future<int> createPlan(TaskPlansCompanion plan);
  Future<List<TaskPlan>> getPlansByListAndDay(int listId, int dayNum);
  Future<List<TaskPlan>> getPlansByDay(int dayNum);
  Future<List<TaskPlan>> getPlansByTask(int taskId, {int limit = 20});
  Future<void> movePlan(int id, int startMinute, int sortOrder);
  Future<void> updatePlan(TaskPlansCompanion plan);
  Future<void> deletePlan(int id);
  Future<void> clearPlansByListAndDay(int listId, int dayNum);
  Future<void> clearPlansByDay(int dayNum);
  Future<void> copyPlans({
    int? listId,
    required int fromDayNum,
    required int toDayNum,
  });
  Future<TaskPlanSettingsValue> getPlanSettings();
  Future<void> savePlanSettings(TaskPlanSettingsValue settings);
}
