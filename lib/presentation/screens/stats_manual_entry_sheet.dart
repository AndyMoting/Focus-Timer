part of 'stats_screen.dart';

Future<void> _showManualEntrySheet(
  BuildContext context,
  WidgetRef ref, {
  FocusTimeData? record,
}) async {
  if (record != null) {
    await _showRecordManagerSheet(context, ref, record);
    return;
  }

  final nameController = TextEditingController(text: '补录专注');
  final noteController = TextEditingController();
  final evidenceController = TextEditingController();
  final fields = _initialManualEntryFields();

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
                            '补录记录',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: '名称',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int>(
                            initialValue: fields.selectedType,
                            decoration: const InputDecoration(
                              labelText: '类型',
                              border: OutlineInputBorder(),
                            ),
                            items: _recordTypeMenuItems(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => fields.selectedType = value);
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
                                      initialDate: fields.selectedDate,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked == null || !context.mounted) {
                                      return;
                                    }
                                    setState(() {
                                      fields.selectedDate = DateTime(
                                        picked.year,
                                        picked.month,
                                        picked.day,
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: Text(_formatDate(fields.selectedDate)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: fields.selectedTime,
                                    );
                                    if (picked == null || !context.mounted) {
                                      return;
                                    }
                                    setState(() {
                                      fields.selectedTime = picked;
                                      fields.updateEndTimeFromDuration();
                                    });
                                  },
                                  icon: const Icon(Icons.schedule),
                                  label: Text(
                                    fields.selectedTime.format(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int>(
                            initialValue: fields.durationMinutes,
                            decoration: const InputDecoration(
                              labelText: '时长',
                              border: OutlineInputBorder(),
                            ),
                            items: const [5, 10, 15, 25, 30, 45, 60, 90, 120]
                                .map(
                                  (minutes) => DropdownMenuItem(
                                    value: minutes,
                                    child: Text('$minutes 分钟'),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                fields.durationMinutes = value;
                                fields.updateEndTimeFromDuration();
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: noteController,
                            minLines: 2,
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              labelText: '备注',
                              hintText: '记录心得、状态或补充说明',
                              border: OutlineInputBorder(),
                            ),
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: evidenceController,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: '视频凭证',
                              hintText: '可粘贴系统相机返回的本地 URI',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () async {
                                final output = await BackgroundTimerService()
                                    .pickVideoFile();
                                if (output == null) return;
                                evidenceController.text = output.uri;
                              },
                              icon: const Icon(Icons.video_file_outlined),
                              label: const Text('选择视频'),
                            ),
                          ),
                          const SizedBox(height: 18),
                          FilledButton.icon(
                            onPressed: () async {
                              final name = nameController.text.trim();
                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('请输入名称')),
                                );
                                return;
                              }

                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(sheetContext);
                              await _saveManualEntry(
                                ref: ref,
                                fields: fields,
                                name: name,
                                note: noteController.text,
                                evidenceUri: evidenceController.text,
                              );
                              if (!sheetContext.mounted) return;
                              navigator.pop();
                              messenger.showSnackBar(
                                const SnackBar(content: Text('已补录记录')),
                              );
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('保存'),
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
    nameController.dispose();
    noteController.dispose();
    evidenceController.dispose();
  }
}
