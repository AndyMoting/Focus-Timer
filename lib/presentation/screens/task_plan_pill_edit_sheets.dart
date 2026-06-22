part of 'task_plan_screen.dart';

void _showPlanDurationSheet(BuildContext context, _PlannedTaskPill pill) {
  final durationController = TextEditingController(
    text: pill.plan.durationMinutes.toString(),
  );
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
      return AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '设定目标',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '计划时长（分钟）',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () async {
                    final duration =
                        int.tryParse(durationController.text.trim()) ??
                        pill.plan.durationMinutes;
                    await pill.onUpdatePlanDuration(pill.plan, duration);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('保存'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).whenComplete(durationController.dispose);
}

Future<void> _pickPlanDate(BuildContext context, _PlannedTaskPill pill) async {
  final currentDate = app_date.DateUtils.dateFromDayNum(pill.plan.dayNum);
  final picked = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (picked == null) return;
  await pill.onMovePlanToDay(
    pill.plan,
    picked.difference(DateTime(1970)).inDays,
  );
}

String _formatPlanDateTime(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.year}.$month.$day $hour:$minute';
}
