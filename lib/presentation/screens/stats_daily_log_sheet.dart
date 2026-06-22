part of 'stats_screen.dart';

Future<void> _showDailyLogSheet(
  BuildContext context,
  WidgetRef ref,
  DailyLog log,
) async {
  var selectedType = log.type;
  var selectedDate = DateTime.fromMillisecondsSinceEpoch(log.loggedAt);
  var selectedTime = TimeOfDay.fromDateTime(selectedDate);
  final noteController = TextEditingController(text: log.note ?? '');

  try {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            return AnimatedPadding(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '编辑打卡',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            initialValue: selectedType,
                            decoration: const InputDecoration(
                              labelText: '类型',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: AppConstants.dailyLogWake,
                                child: Text('起床'),
                              ),
                              DropdownMenuItem(
                                value: AppConstants.dailyLogSleep,
                                child: Text('睡觉'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => selectedType = value);
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked == null || !context.mounted) {
                                      return;
                                    }
                                    setState(() {
                                      selectedDate = DateTime(
                                        picked.year,
                                        picked.month,
                                        picked.day,
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: Text(_formatDate(selectedDate)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                    );
                                    if (picked == null || !context.mounted) {
                                      return;
                                    }
                                    setState(() => selectedTime = picked);
                                  },
                                  icon: const Icon(Icons.schedule),
                                  label: Text(selectedTime.format(context)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: noteController,
                            minLines: 2,
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              labelText: '备注',
                              hintText: '可记录状态或补充说明',
                              border: OutlineInputBorder(),
                            ),
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          const SizedBox(height: 18),
                          FilledButton.icon(
                            onPressed: () async {
                              final loggedAt = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              await ref
                                  .read(dailyLogNotifierProvider.notifier)
                                  .updateLog(
                                    log: log,
                                    type: selectedType,
                                    loggedAt: loggedAt,
                                    note: noteController.text,
                                  );
                              ref.invalidate(statsSnapshotProvider);
                              if (!sheetContext.mounted) return;
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已更新打卡')),
                              );
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('保存修改'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('删除打卡'),
                                  content: const Text('确定删除这条打卡记录吗？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: const Text('取消'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      child: const Text('删除'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed != true) return;
                              await ref
                                  .read(dailyLogNotifierProvider.notifier)
                                  .deleteLog(log.id);
                              ref.invalidate(statsSnapshotProvider);
                              if (!sheetContext.mounted) return;
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已删除打卡')),
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('删除打卡'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  } finally {
    noteController.dispose();
  }
}
