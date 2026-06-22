import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/countdown_provider.dart';
import 'package:focus_timer/presentation/providers/daily_log_provider.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/presentation/providers/heatmap_provider.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_settings_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:focus_timer/shared/services/data_restore_service.dart';

enum ExportScope {
  all('全部数据', '待办、计划、计时、打卡、统计设置和视频索引', Icons.archive_outlined),
  todos('导出待办', '分组、任务、计划模式和日倒计时', Icons.checklist_outlined),
  timers('导出计时', '计时记录、运行会话、统计设置和视频索引', Icons.timer_outlined),
  dailyLogs('导出打卡', '起床、睡觉和后续习惯打卡记录', Icons.fact_check_outlined);

  final String title;
  final String description;
  final IconData icon;

  const ExportScope(this.title, this.description, this.icon);

  String get fileToken => switch (this) {
    ExportScope.all => 'all',
    ExportScope.todos => 'todos',
    ExportScope.timers => 'timers',
    ExportScope.dailyLogs => 'daily_logs',
  };

  bool get includesTodos =>
      this == ExportScope.all || this == ExportScope.todos;

  bool get includesTimers =>
      this == ExportScope.all || this == ExportScope.timers;

  bool get includesDailyLogs =>
      this == ExportScope.all || this == ExportScope.dailyLogs;
}

class DataExportScreen extends ConsumerStatefulWidget {
  const DataExportScreen({super.key});

  @override
  ConsumerState<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends ConsumerState<DataExportScreen> {
  ExportScope? _exportingScope;
  bool _importChecking = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('导出数据'), centerTitle: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _ExportIntro(colorScheme: colorScheme),
            const SizedBox(height: 16),
            for (final scope in ExportScope.values) ...[
              _ExportScopeCard(
                scope: scope,
                isLoading: _exportingScope == scope,
                enabled: _exportingScope == null,
                onTap: () => _export(scope),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            _ImportPlaceholderCard(
              enabled: _exportingScope == null && !_importChecking,
              isLoading: _importChecking,
              onTap: _pickImportFiles,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export(ExportScope scope) async {
    setState(() => _exportingScope = scope);
    try {
      final result = await _buildAndWriteExport(ref, scope);
      if (!mounted) return;
      if (result == null) {
        _showSnack('导出失败：无法写入 Download/Focus Timer/Exports');
        return;
      }
      _showExportResult(context, result);
    } catch (error) {
      if (mounted) _showSnack('导出失败：$error');
    } finally {
      if (mounted) setState(() => _exportingScope = null);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _pickImportFiles() async {
    setState(() => _importChecking = true);
    try {
      final files = await BackgroundTimerService().pickJsonFiles();
      if (!mounted) return;
      if (files.isEmpty) {
        _showSnack('未选择 JSON 文件');
        return;
      }
      final service = DataRestoreService(ref.read(databaseProvider));
      final previews = files
          .map((file) => service.previewJson(file.displayName, file.content))
          .toList();
      _showImportPreviewResult(files, previews);
    } finally {
      if (mounted) setState(() => _importChecking = false);
    }
  }

  void _showImportPreviewResult(
    List<PickedTextFileResult> files,
    List<ImportPreviewResult> previews,
  ) {
    final canRestore = previews.any((preview) => preview.ok);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            Text(
              '恢复预检',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text('恢复会追加写入本机数据，并尽量去重；任务、计划和计时关联会自动重映射，不会覆盖现有数据。'),
            const SizedBox(height: 12),
            for (final preview in previews) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  preview.ok ? Icons.check_circle_outline : Icons.error_outline,
                ),
                title: Text(preview.fileName),
                subtitle: Text(preview.message),
              ),
              const Divider(height: 1),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('先不恢复'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: canRestore
                        ? () async {
                            Navigator.pop(sheetContext);
                            await _restoreImportFiles(files);
                          }
                        : null,
                    child: const Text('追加恢复'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _restoreImportFiles(List<PickedTextFileResult> files) async {
    setState(() => _importChecking = true);
    try {
      final result = await DataRestoreService(
        ref.read(databaseProvider),
      ).restoreJsonFiles(files);
      if (!mounted) return;
      _refreshAfterRestore();
      _showRestoreResult(result);
    } catch (error) {
      if (mounted) _showSnack('恢复失败：$error');
    } finally {
      if (mounted) setState(() => _importChecking = false);
    }
  }

  void _refreshAfterRestore() {
    ref.invalidate(groupListProvider);
    ref.invalidate(countdownProvider);
    ref.invalidate(appAppearanceProvider);
    ref.invalidate(taskListProvider);
    ref.invalidate(allTaskListProvider);
    ref.invalidate(taskPlanProvider);
    ref.invalidate(timerSettingsProvider);
    ref.invalidate(timerProvider);
    ref.invalidate(statsSnapshotProvider);
    ref.invalidate(heatmapDataProvider);
    ref.invalidate(dailyLogSnapshotProvider);
  }

  void _showRestoreResult(DataRestoreBatchResult result) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('恢复完成'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.summary),
            const SizedBox(height: 12),
            for (final file in result.files)
              Text('${file.ok ? '✓' : '×'} ${file.fileName}：${file.message}'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

class _ExportIntro extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ExportIntro({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder_copy_outlined, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '导出的 JSON 会保存到 Download/Focus Timer/Exports。视频打卡文件保存在 Download/Focus Timer/Videos，JSON 内会包含 videoEvidence 索引；起床、睡觉会作为 dailyLogs 打卡记录导出。',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportScopeCard extends StatelessWidget {
  final ExportScope scope;
  final bool isLoading;
  final bool enabled;
  final VoidCallback onTap;

  const _ExportScopeCard({
    required this.scope,
    required this.isLoading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(scope.icon, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scope.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      scope.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportPlaceholderCard extends StatelessWidget {
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _ImportPlaceholderCard({
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.settings_backup_restore_outlined,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '恢复数据',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '选择一个或多个导出 JSON，先做恢复预检',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.file_open_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExportWriteResult {
  final ExportScope scope;
  final SharedFileResult file;
  final int videoEvidenceCount;
  final int dailyLogCount;

  const ExportWriteResult({
    required this.scope,
    required this.file,
    required this.videoEvidenceCount,
    required this.dailyLogCount,
  });
}

Future<ExportWriteResult?> _buildAndWriteExport(
  WidgetRef ref,
  ExportScope scope,
) async {
  final db = ref.read(databaseProvider);
  await ref.read(dailyLogRepositoryProvider).migrateLegacySleepTimerRecords();
  final exportedAt = DateTime.now();
  final fileName =
      'focus_timer_${scope.fileToken}_${DateFormat('yyyyMMdd_HHmmss').format(exportedAt)}.json';
  final focusTimes = scope.includesTimers
      ? await db.select(db.focusTime).get()
      : <FocusTimeData>[];
  final dailyLogs = scope.includesDailyLogs
      ? await db.select(db.dailyLogs).get()
      : <DailyLog>[];
  final payload = await _buildPayload(
    ref,
    scope,
    exportedAt,
    focusTimes,
    dailyLogs,
  );
  const encoder = JsonEncoder.withIndent('  ');
  final output = await BackgroundTimerService().writeExportJson(
    displayName: fileName,
    content: encoder.convert(payload),
  );
  if (output == null) return null;
  return ExportWriteResult(
    scope: scope,
    file: output,
    videoEvidenceCount: focusTimes.where(_hasVideoEvidence).length,
    dailyLogCount: dailyLogs.length,
  );
}

Future<Map<String, Object?>> _buildPayload(
  WidgetRef ref,
  ExportScope scope,
  DateTime exportedAt,
  List<FocusTimeData> focusTimes,
  List<DailyLog> dailyLogs,
) async {
  final db = ref.read(databaseProvider);
  final payload = <String, Object?>{
    'app': AppConstants.appName,
    'version': AppConstants.appVersion,
    'databaseVersion': AppConstants.databaseVersion,
    'exportScope': scope.fileToken,
    'exportedAt': exportedAt.toIso8601String(),
    'storage': const {
      'root': 'Download/Focus Timer',
      'exports': 'Download/Focus Timer/Exports',
      'videos': 'Download/Focus Timer/Videos',
    },
  };
  final appearanceFile = await appearanceSettingsFile();
  if (await appearanceFile.exists()) {
    try {
      payload['appearanceSettings'] = jsonDecode(
        await appearanceFile.readAsString(),
      );
    } catch (_) {}
  }

  if (scope.includesTodos) {
    final countdown = ref.read(countdownProvider);
    payload.addAll({
      'dayCountdown': {
        'eventName': countdown.eventName,
        'targetDate': countdown.targetDate?.toIso8601String(),
        'targetDateMs': countdown.targetDate?.millisecondsSinceEpoch,
      },
      'taskLists': (await db.select(db.taskLists).get())
          .map((item) => item.toJson())
          .toList(),
      'tasks': (await db.select(db.tasks).get())
          .map((item) => item.toJson())
          .toList(),
      'taskPlans': (await db.select(db.taskPlans).get())
          .map((item) => item.toJson())
          .toList(),
      'taskPlanSettings': (await db.select(db.taskPlanSettings).get())
          .map((item) => item.toJson())
          .toList(),
    });
  }

  if (scope.includesTimers) {
    final timerSettings = await ref.read(timerSettingsProvider.future);
    payload.addAll({
      'timerSettings': timerSettings.toJson(),
      'statsSettings': (await db.select(db.statsSettings).get())
          .map((item) => item.toJson())
          .toList(),
      'focusTimes': focusTimes.map((item) => item.toJson()).toList(),
      'activeTimerSessions': (await db.select(db.activeTimerSession).get())
          .map((item) => item.toJson())
          .toList(),
      'videoEvidence': focusTimes
          .where(_hasVideoEvidence)
          .map(_videoEvidenceJson)
          .toList(),
    });
  }

  if (scope.includesDailyLogs) {
    payload.addAll({'dailyLogs': dailyLogs.map(_dailyLogJson).toList()});
  }

  return payload;
}

bool _hasVideoEvidence(FocusTimeData record) {
  return _hasText(record.evidenceUri) ||
      _hasText(record.evidenceDisplayName) ||
      _hasText(record.evidenceRelativePath);
}

Map<String, Object?> _videoEvidenceJson(FocusTimeData record) {
  return {
    'recordId': record.id,
    'recordName': record.name,
    'type': record.type,
    'dayNum': record.dayNum,
    'startTime': record.startTime,
    'startTimeIso': DateTime.fromMillisecondsSinceEpoch(
      record.startTime,
    ).toIso8601String(),
    'durationMs': record.durationMs,
    'taskId': record.taskId,
    'listId': record.listId,
    'planId': record.planId,
    'uri': record.evidenceUri,
    'displayName': record.evidenceDisplayName,
    'relativePath': record.evidenceRelativePath,
    'mimeType': record.evidenceMimeType,
    'note': record.note,
  };
}

Map<String, Object?> _dailyLogJson(DailyLog log) {
  final loggedAt = DateTime.fromMillisecondsSinceEpoch(log.loggedAt);
  return {
    ...log.toJson(),
    'typeLabel': _dailyLogTypeLabel(log.type),
    'loggedAtIso': loggedAt.toIso8601String(),
  };
}

String _dailyLogTypeLabel(int type) {
  return switch (type) {
    AppConstants.dailyLogWake => '起床',
    AppConstants.dailyLogSleep => '睡觉',
    _ => '打卡',
  };
}

bool _hasText(String? value) => value?.trim().isNotEmpty ?? false;

void _showExportResult(BuildContext context, ExportWriteResult result) {
  final output = result.file;
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('${result.scope.title}完成'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('已保存到 Download/Focus Timer/Exports。'),
          const SizedBox(height: 12),
          Text('文件名：${output.displayName}'),
          if (result.scope.includesTimers) ...[
            const SizedBox(height: 6),
            Text('视频凭证索引：${result.videoEvidenceCount} 条'),
          ],
          if (result.scope.includesDailyLogs) ...[
            const SizedBox(height: 6),
            Text('打卡记录：${result.dailyLogCount} 条'),
          ],
          const SizedBox(height: 12),
          const Text('内容 URI：'),
          const SizedBox(height: 6),
          SelectableText(
            output.uri,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(
                text:
                    '${output.relativePath}/${output.displayName}\n${output.uri}',
              ),
            );
            if (ctx.mounted) Navigator.pop(ctx);
          },
          child: const Text('复制位置'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('知道了'),
        ),
      ],
    ),
  );
}
