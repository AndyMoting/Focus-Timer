part of 'group_list_screen.dart';

void _openPlanMode(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const TaskPlanScreen()),
  );
}

void _openCountdown(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const DayCountdownScreen()),
  );
}

void _openTrash(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const TrashScreen()),
  );
}
