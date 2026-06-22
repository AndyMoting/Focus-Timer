part of 'stats_screen.dart';

Future<bool> _confirmDeleteRecord(
  BuildContext context,
  WidgetRef ref,
  FocusTimeData record,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('删除记录'),
      content: Text('确定删除“${record.name}”吗？'),
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
  if (confirmed != true) return false;
  await ref.read(timerRepositoryProvider).deleteRecord(record.id);
  await _refreshStats(ref);
  if (!context.mounted) return true;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('已删除记录')));
  return true;
}

Future<void> _refreshStats(WidgetRef ref) async {
  ref.invalidate(statsSnapshotProvider);
  ref.invalidate(heatmapDataProvider);
  await ref.read(timerProvider.notifier).refreshTodayData();
}

Future<void> _saveRecordEdits({
  required WidgetRef ref,
  required FocusTimeData record,
  required _RecordEditFields fields,
  required String name,
  String? note,
  String? evidenceUri,
}) async {
  final evidence = _evidenceMetadataForEdit(record, evidenceUri);
  await ref
      .read(timerRepositoryProvider)
      .updateRecord(
        record.id,
        FocusTimeCompanion(
          dayNum: drift.Value(fields.dayNum),
          type: drift.Value(fields.selectedType),
          state: const drift.Value(AppConstants.stateStop),
          startTime: drift.Value(fields.startTime.millisecondsSinceEpoch),
          endTime: drift.Value(fields.endTime.millisecondsSinceEpoch),
          durationMs: drift.Value(fields.durationMs),
          scheduledTime: drift.Value(fields.durationMs),
          name: drift.Value(name),
          note: drift.Value(_emptyToNull(note)),
          evidenceUri: drift.Value(evidence.uri),
          evidenceDisplayName: drift.Value(evidence.displayName),
          evidenceRelativePath: drift.Value(evidence.relativePath),
          evidenceMimeType: drift.Value(evidence.mimeType),
          updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
  await _refreshStats(ref);
}

Future<void> _saveManualEntry({
  required WidgetRef ref,
  required _RecordEditFields fields,
  required String name,
  String? note,
  String? evidenceUri,
}) async {
  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final evidence = _evidenceMetadataForNewEntry(evidenceUri);
  await ref
      .read(timerRepositoryProvider)
      .saveTimer(
        FocusTimeCompanion.insert(
          dayNum: fields.dayNum,
          type: fields.selectedType,
          state: AppConstants.stateStop,
          startTime: fields.startTime.millisecondsSinceEpoch,
          endTime: drift.Value(fields.endTime.millisecondsSinceEpoch),
          durationMs: drift.Value(fields.durationMs),
          scheduledTime: drift.Value(fields.durationMs),
          name: name,
          note: drift.Value(_emptyToNull(note)),
          evidenceUri: drift.Value(evidence.uri),
          evidenceDisplayName: drift.Value(evidence.displayName),
          evidenceRelativePath: drift.Value(evidence.relativePath),
          evidenceMimeType: drift.Value(evidence.mimeType),
          createdAt: nowMs,
          updatedAt: nowMs,
        ),
      );
  await _refreshStats(ref);
}

String? _emptyToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

_EvidenceMetadata _evidenceMetadataForEdit(
  FocusTimeData record,
  String? evidenceUri,
) {
  final uri = _emptyToNull(evidenceUri);
  if (uri == null) return const _EvidenceMetadata();
  if (uri == record.evidenceUri) {
    return _EvidenceMetadata(
      uri: uri,
      displayName: record.evidenceDisplayName,
      relativePath: record.evidenceRelativePath,
      mimeType: record.evidenceMimeType,
    );
  }
  return _evidenceMetadataForNewEntry(uri);
}

_EvidenceMetadata _evidenceMetadataForNewEntry(String? evidenceUri) {
  final uri = _emptyToNull(evidenceUri);
  if (uri == null) return const _EvidenceMetadata();
  return _EvidenceMetadata(
    uri: uri,
    displayName: _fileNameFromUri(uri),
    mimeType: _mimeTypeFromUri(uri),
  );
}

String? _fileNameFromUri(String uri) {
  final decoded = Uri.decodeFull(uri);
  final last = decoded.split(RegExp(r'[/\\]')).last.trim();
  if (last.isEmpty || last == decoded) return null;
  return last.split('?').first.trim();
}

String? _mimeTypeFromUri(String uri) {
  final lower = uri.toLowerCase();
  if (lower.endsWith('.mp4') || lower.contains('.mp4?')) return 'video/mp4';
  if (lower.endsWith('.mov') || lower.contains('.mov?')) {
    return 'video/quicktime';
  }
  if (lower.endsWith('.webm') || lower.contains('.webm?')) return 'video/webm';
  return null;
}

class _EvidenceMetadata {
  final String? uri;
  final String? displayName;
  final String? relativePath;
  final String? mimeType;

  const _EvidenceMetadata({
    this.uri,
    this.displayName,
    this.relativePath,
    this.mimeType,
  });
}
