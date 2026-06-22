import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/group_detail_screen.dart';
import 'package:focus_timer/presentation/screens/timer_record_dialogs.dart';
import 'package:focus_timer/presentation/screens/timer_ui_helpers.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';

typedef TimerStartCallback =
    void Function({
      required int type,
      required String name,
      required int targetDurationMs,
      String? note,
      int? taskId,
      int? listId,
      int? planId,
      String? evidenceUri,
      String? evidenceDisplayName,
      String? evidenceRelativePath,
      String? evidenceMimeType,
    });

Future<void> showTimerRecordActions({
  required BuildContext context,
  required FocusTimeData record,
  required TimerNotifier timerNotifier,
  required TimerStartCallback onStart,
  List<TaskList> sourceGroups = const [],
  Future<void> Function()? onChanged,
}) async {
  final sourceLabel = timerRecordSourceLabel(record);
  final action = await showModalBottomSheet<TimerRecordAction>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              record.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              [
                timerLabelForType(record.type),
                formatShortDuration(record.durationMs),
                formatRecordTimeRange(record),
                if (sourceLabel.isNotEmpty) sourceLabel,
              ].join(' · '),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('继续计时'),
            onTap: () =>
                Navigator.pop(sheetContext, TimerRecordAction.continueTimer),
          ),
          if (record.listId != null || record.taskId != null)
            ListTile(
              leading: const Icon(Icons.link_outlined),
              title: const Text('来源'),
              subtitle: Text(sourceLabel.isEmpty ? '关联待办' : sourceLabel),
              onTap: () =>
                  Navigator.pop(sheetContext, TimerRecordAction.openSource),
            ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('重命名'),
            onTap: () => Navigator.pop(sheetContext, TimerRecordAction.rename),
          ),
          ListTile(
            leading: const Icon(Icons.schedule_outlined),
            title: const Text('修改时长'),
            onTap: () =>
                Navigator.pop(sheetContext, TimerRecordAction.changeDuration),
          ),
          if (_hasVideoEvidence(record))
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('播放视频凭证'),
              onTap: () =>
                  Navigator.pop(sheetContext, TimerRecordAction.playEvidence),
            ),
          if (_hasVideoEvidence(record))
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('复制视频位置'),
              onTap: () =>
                  Navigator.pop(sheetContext, TimerRecordAction.copyEvidence),
            ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('删除记录'),
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () => Navigator.pop(sheetContext, TimerRecordAction.delete),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (!context.mounted || action == null) return;

  switch (action) {
    case TimerRecordAction.continueTimer:
      continueFromTimerRecord(
        context: context,
        record: record,
        onStart: onStart,
      );
    case TimerRecordAction.openSource:
      _openRecordSource(context, record, sourceGroups, sourceLabel);
    case TimerRecordAction.rename:
      final name = await _showRenameRecordDialog(context, record);
      if (!context.mounted || name == null) return;
      await timerNotifier.renameRecord(record.id, name);
      await onChanged?.call();
      if (context.mounted) _showSnack(context, '已重命名');
    case TimerRecordAction.changeDuration:
      final durationMs = await _showDurationEditDialog(context, record);
      if (!context.mounted || durationMs == null) return;
      await timerNotifier.updateRecordDuration(record.id, durationMs);
      await onChanged?.call();
      if (context.mounted) _showSnack(context, '已修改时长');
    case TimerRecordAction.playEvidence:
      await _playEvidence(context, record);
    case TimerRecordAction.copyEvidence:
      await _copyEvidence(context, record);
    case TimerRecordAction.delete:
      final confirmed = await _confirmDeleteRecord(context, record);
      if (!context.mounted || confirmed != true) return;
      await timerNotifier.deleteRecord(record.id);
      await onChanged?.call();
      if (context.mounted) _showSnack(context, '已删除记录');
  }
}

void _openRecordSource(
  BuildContext context,
  FocusTimeData record,
  List<TaskList> sourceGroups,
  String sourceLabel,
) {
  final listId = record.listId;
  if (listId == null) {
    _showSnack(context, sourceLabel.isEmpty ? '这条记录没有来源信息' : sourceLabel);
    return;
  }
  final group = sourceGroups.where((item) => item.id == listId).firstOrNull;
  if (group == null) {
    _showSnack(context, '来源分组不存在或已删除');
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => GroupDetailScreen(group: group)),
  );
}

bool _hasVideoEvidence(FocusTimeData record) {
  return record.evidenceUri?.trim().isNotEmpty ?? false;
}

Future<void> _playEvidence(BuildContext context, FocusTimeData record) async {
  final uri = record.evidenceUri?.trim();
  if (uri == null || uri.isEmpty) return;
  final opened = await BackgroundTimerService().openFile(
    uri: uri,
    mimeType: record.evidenceMimeType ?? 'video/mp4',
    title: record.evidenceDisplayName ?? record.name,
  );
  if (context.mounted && !opened) _showSnack(context, '无法播放这个视频');
}

Future<void> _copyEvidence(BuildContext context, FocusTimeData record) async {
  final parts = [
    if ((record.evidenceRelativePath ?? '').trim().isNotEmpty)
      record.evidenceRelativePath!.trim(),
    if ((record.evidenceDisplayName ?? '').trim().isNotEmpty)
      record.evidenceDisplayName!.trim(),
    if ((record.evidenceUri ?? '').trim().isNotEmpty)
      record.evidenceUri!.trim(),
  ];
  await Clipboard.setData(ClipboardData(text: parts.join('\n')));
  if (context.mounted) _showSnack(context, '已复制视频位置');
}

void continueFromTimerRecord({
  required BuildContext context,
  required FocusTimeData record,
  required TimerStartCallback onStart,
}) {
  onStart(
    type: record.type,
    name: record.name,
    targetDurationMs: record.scheduledTime ?? 0,
    note: record.note,
    taskId: record.taskId,
    listId: record.listId,
    planId: record.planId,
    evidenceUri: record.evidenceUri,
    evidenceDisplayName: record.evidenceDisplayName,
    evidenceRelativePath: record.evidenceRelativePath,
    evidenceMimeType: record.evidenceMimeType,
  );
  _showSnack(context, '已继续计时');
}

Future<String?> _showRenameRecordDialog(
  BuildContext context,
  FocusTimeData record,
) async {
  return showDialog<String>(
    context: context,
    builder: (_) => RenameRecordDialog(initialName: record.name),
  );
}

Future<int?> _showDurationEditDialog(
  BuildContext context,
  FocusTimeData record,
) async {
  return showDialog<int>(
    context: context,
    builder: (_) => DurationEditDialog(initialDurationMs: record.durationMs),
  );
}

Future<bool?> _confirmDeleteRecord(BuildContext context, FocusTimeData record) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('删除计时记录'),
      content: Text('确定删除「${record.name}」吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
