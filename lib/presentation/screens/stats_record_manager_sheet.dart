part of 'stats_screen.dart';

Future<void> _showRecordManagerSheet(
  BuildContext context,
  WidgetRef ref,
  FocusTimeData record,
) async {
  final nameController = TextEditingController(text: record.name);
  final noteController = TextEditingController(text: record.note ?? '');
  final evidenceController = TextEditingController(
    text: record.evidenceUri ?? '',
  );
  final fields = _initialRecordEditFields(record);

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
                            '编辑记录',
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
                                    final picked = await showAppTimePicker(
                                      context: context,
                                      title: '开始时间',
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
                          OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showAppTimePicker(
                                context: context,
                                title: '结束时间',
                                initialTime: fields.endTimeOfDay,
                              );
                              if (picked == null || !context.mounted) return;
                              setState(() {
                                fields.endTimeOfDay = picked;
                                fields.updateDurationFromEndTime();
                              });
                            },
                            icon: const Icon(Icons.flag_outlined),
                            label: Text(
                              '结束时间 ${fields.endTimeOfDay.format(context)}',
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int>(
                            initialValue: _durationMenuValue(
                              fields.durationMinutes,
                            ),
                            decoration: const InputDecoration(
                              labelText: '时长',
                              border: OutlineInputBorder(),
                            ),
                            items: _durationMenuItems(fields.durationMinutes),
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
                              hintText: '本地视频 URI，可清空',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: 8,
                              alignment: WrapAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    final output =
                                        await BackgroundTimerService()
                                            .pickVideoFile();
                                    if (output == null) return;
                                    setState(() {
                                      evidenceController.text = output.uri;
                                    });
                                  },
                                  icon: const Icon(Icons.video_file_outlined),
                                  label: const Text('选择视频'),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      evidenceController.text.trim().isEmpty
                                      ? null
                                      : () async {
                                          final opened =
                                              await BackgroundTimerService()
                                                  .openFile(
                                                    uri: evidenceController.text
                                                        .trim(),
                                                    mimeType:
                                                        record
                                                            .evidenceMimeType ??
                                                        'video/mp4',
                                                    title:
                                                        record
                                                            .evidenceDisplayName ??
                                                        record.name,
                                                  );
                                          if (!context.mounted || opened) {
                                            return;
                                          }
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('无法播放这个视频'),
                                            ),
                                          );
                                        },
                                  icon: const Icon(Icons.play_circle_outline),
                                  label: const Text('播放'),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    evidenceController.clear();
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: const Icon(Icons.link_off_outlined),
                                  label: const Text('清除'),
                                ),
                              ],
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

                              await _saveRecordEdits(
                                ref: ref,
                                record: record,
                                fields: fields,
                                name: name,
                                note: noteController.text,
                                evidenceUri: evidenceController.text,
                              );
                              if (!sheetContext.mounted) return;
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已更新记录')),
                              );
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('保存修改'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final deleted = await _confirmDeleteRecord(
                                sheetContext,
                                ref,
                                record,
                              );
                              if (deleted && sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('删除记录'),
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
