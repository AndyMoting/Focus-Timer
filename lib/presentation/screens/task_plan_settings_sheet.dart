part of 'task_plan_screen.dart';

Future<void> _showSettingsSheet(BuildContext context, WidgetRef ref) async {
  final current =
      ref.read(taskPlanSettingsProvider).valueOrNull ??
      TaskPlanSettingsValue.defaults;
  var draft = current;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '时段设置',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TimePickTile(
                    label: '开始时间',
                    minute: draft.startMinute,
                    onPick: () async {
                      final picked = await _pickMinute(
                        context,
                        draft.startMinute,
                        includeEnd: false,
                      );
                      if (picked == null) return;
                      setState(() {
                        draft = draft.copyWith(startMinute: picked);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _TimePickTile(
                    label: '结束时间',
                    minute: draft.endMinute,
                    onPick: () async {
                      final picked = await _pickMinute(
                        context,
                        draft.endMinute,
                        includeEnd: true,
                        minMinute: draft.startMinute + draft.slotMinutes,
                      );
                      if (picked == null) return;
                      setState(() {
                        draft = draft.copyWith(endMinute: picked);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '分段',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TaskPlanSettingsValue.allowedSlotMinutes.map((
                      minutes,
                    ) {
                      return ChoiceChip(
                        label: Text(_slotLabel(minutes)),
                        selected: draft.slotMinutes == minutes,
                        onSelected: (_) {
                          setState(() {
                            draft = draft.copyWith(slotMinutes: minutes);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () async {
                      await ref
                          .read(taskPlanSettingsProvider.notifier)
                          .save(draft);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

List<int> _hourMarks({required bool includeEnd}) {
  final end = includeEnd ? 24 : 23;
  return [for (var hour = 0; hour <= end; hour++) hour * 60];
}

Future<int?> _pickMinute(
  BuildContext context,
  int initialMinute, {
  required bool includeEnd,
  int minMinute = 0,
}) async {
  final values = _hourMarks(
    includeEnd: includeEnd,
  ).where((minute) => minute >= minMinute).toList();
  if (values.isEmpty) return null;
  final safeInitial = values.contains(initialMinute)
      ? initialMinute
      : values.first;
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: values.length,
          itemBuilder: (context, index) {
            final value = values[index];
            final selected = value == safeInitial;
            return ListTile(
              title: Text(_minuteLabel(value)),
              trailing: selected ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(sheetContext, value),
            );
          },
        ),
      );
    },
  );
}

String _slotLabel(int minutes) {
  if (minutes < 60) return '$minutes 分钟';
  return '${minutes ~/ 60} 小时';
}

String _minuteLabel(int minute) {
  if (minute == 24 * 60) return '24:00';
  final hour = minute ~/ 60;
  final rest = minute % 60;
  return '${hour.toString().padLeft(2, '0')}:'
      '${rest.toString().padLeft(2, '0')}';
}
