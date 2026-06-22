import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

final _videoEvidenceRecordsProvider =
    FutureProvider.autoDispose<List<FocusTimeData>>((ref) async {
      final db = ref.watch(databaseProvider);
      final records =
          await (db.select(db.focusTime)
                ..where(
                  (table) => table.type.equals(AppConstants.typeVideoStudy),
                )
                ..orderBy([
                  (table) => drift.OrderingTerm.desc(table.startTime),
                ]))
              .get();
      return records.where(_hasEvidence).toList();
    });

class VideoEvidenceScreen extends ConsumerWidget {
  const VideoEvidenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(_videoEvidenceRecordsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('视频凭证'), centerTitle: false),
      body: SafeArea(
        child: recordsAsync.when(
          data: (records) {
            if (records.isEmpty) {
              return _VideoEvidenceEmpty(colorScheme: colorScheme);
            }
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(_videoEvidenceRecordsProvider);
                await ref.read(_videoEvidenceRecordsProvider.future);
              },
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: records.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _VideoEvidenceTile(
                  record: records[index],
                  colorScheme: colorScheme,
                  onOpen: () => _openVideoEvidence(context, records[index]),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '视频凭证加载失败：$error',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoEvidenceTile extends StatelessWidget {
  final FocusTimeData record;
  final ColorScheme colorScheme;
  final VoidCallback onOpen;

  const _VideoEvidenceTile({
    required this.record,
    required this.colorScheme,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final start = DateTime.fromMillisecondsSinceEpoch(record.startTime);
    final uri = record.evidenceUri?.trim();
    final displayName = record.evidenceDisplayName?.trim();
    final relativePath = record.evidenceRelativePath?.trim();
    final mimeType = record.evidenceMimeType?.trim();
    final locationText = [
      if (relativePath?.isNotEmpty ?? false) relativePath,
      if (displayName?.isNotEmpty ?? false) displayName,
    ].join('/');
    final copyText = [
      if (locationText.isNotEmpty) locationText,
      if (uri?.isNotEmpty ?? false) uri,
      if (mimeType?.isNotEmpty ?? false) mimeType,
    ].join('\n');

    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.videocam_outlined, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    record.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '播放',
                  onPressed: (uri?.isNotEmpty ?? false) ? onOpen : null,
                  icon: const Icon(Icons.play_circle_outline),
                ),
                TextButton.icon(
                  onPressed: copyText.isEmpty
                      ? null
                      : () async {
                          await Clipboard.setData(
                            ClipboardData(text: copyText),
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('已复制视频凭证位置'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('复制'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${app_date.DateUtils.formatDate(start)} ${_formatTime(start)}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (record.note?.trim().isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                record.note!.trim(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            _EvidenceInfoLine(
              icon: Icons.folder_outlined,
              label: '目录',
              value: relativePath?.isNotEmpty ?? false
                  ? relativePath!
                  : 'Download/Focus Timer/Videos',
              colorScheme: colorScheme,
            ),
            if (displayName?.isNotEmpty ?? false) ...[
              const SizedBox(height: 6),
              _EvidenceInfoLine(
                icon: Icons.movie_outlined,
                label: '文件',
                value: displayName!,
                colorScheme: colorScheme,
              ),
            ],
            if (mimeType?.isNotEmpty ?? false) ...[
              const SizedBox(height: 6),
              _EvidenceInfoLine(
                icon: Icons.info_outline,
                label: '类型',
                value: mimeType!,
                colorScheme: colorScheme,
              ),
            ],
            if (uri?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              SelectableText(
                uri!,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

Future<void> _openVideoEvidence(
  BuildContext context,
  FocusTimeData record,
) async {
  final uri = record.evidenceUri?.trim();
  if (uri == null || uri.isEmpty) return;
  final opened = await BackgroundTimerService().openFile(
    uri: uri,
    mimeType: record.evidenceMimeType ?? 'video/mp4',
    title: record.evidenceDisplayName ?? record.name,
  );
  if (!context.mounted || opened) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('无法播放这个视频')));
}

class _EvidenceInfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _EvidenceInfoLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label：',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

bool _hasEvidence(FocusTimeData record) {
  return (record.evidenceUri?.trim().isNotEmpty ?? false) ||
      (record.evidenceDisplayName?.trim().isNotEmpty ?? false) ||
      (record.evidenceRelativePath?.trim().isNotEmpty ?? false);
}

class _VideoEvidenceEmpty extends StatelessWidget {
  final ColorScheme colorScheme;

  const _VideoEvidenceEmpty({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_file_outlined,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              '暂无视频凭证',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '使用计时页的视频打卡后，文件会保存到 Download/Focus Timer/Videos，并在这里显示索引。',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
