part of 'group_list_screen.dart';

int _countCompletedSince(List<Task> tasks, DateTime start) {
  return tasks.where((task) {
    final completedAt = task.completedAt;
    if (completedAt == null) return false;
    final date = DateTime.fromMillisecondsSinceEpoch(completedAt);
    return !date.isBefore(start);
  }).length;
}

int _countCompletedBetween(List<Task> tasks, DateTime start, DateTime end) {
  return tasks.where((task) {
    final completedAt = task.completedAt;
    if (completedAt == null) return false;
    final date = DateTime.fromMillisecondsSinceEpoch(completedAt);
    return !date.isBefore(start) && date.isBefore(end);
  }).length;
}

String _formatTimelineDay(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day ${_weekdayLabel(date.weekday)}';
}

String _formatDateTime(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}.$month.$day ${_formatTime(timestampMs)}';
}

String _formatTime(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _formatShortDay(int dayNum) {
  final date = DateTime(1970).add(Duration(days: dayNum));
  return '${date.month}/${date.day}';
}

String _weekdayLabel(int weekday) {
  return switch (weekday) {
    DateTime.monday => '周一',
    DateTime.tuesday => '周二',
    DateTime.wednesday => '周三',
    DateTime.thursday => '周四',
    DateTime.friday => '周五',
    DateTime.saturday => '周六',
    _ => '周日',
  };
}
