import 'package:flutter/material.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/timer_record_actions.dart';
import 'package:focus_timer/presentation/screens/timer_ui_helpers.dart';

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

class RecentTimerRecordCard extends StatelessWidget {
  final FocusTimeData record;
  final TimerNotifier timerNotifier;
  final TimerStartCallback onStart;
  final List<TaskList> sourceGroups;
  final Future<void> Function()? onChanged;

  const RecentTimerRecordCard({
    super.key,
    required this.record,
    required this.timerNotifier,
    required this.onStart,
    this.sourceGroups = const [],
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sourceLabel = timerRecordSourceLabel(record);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showTimerRecordActions(
          context: context,
          record: record,
          timerNotifier: timerNotifier,
          onStart: onStart,
          sourceGroups: sourceGroups,
          onChanged: onChanged,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  timerIconForType(record.type),
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '上次计时',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      record.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        timerLabelForType(record.type),
                        formatShortDuration(record.durationMs),
                        formatRecordTimeRange(record),
                        if (sourceLabel.isNotEmpty) sourceLabel,
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '继续',
                onPressed: () => continueFromTimerRecord(
                  context: context,
                  record: record,
                  onStart: onStart,
                ),
                icon: const Icon(Icons.play_arrow),
              ),
              IconButton(
                tooltip: '更多操作',
                onPressed: () => showTimerRecordActions(
                  context: context,
                  record: record,
                  timerNotifier: timerNotifier,
                  onStart: onStart,
                  sourceGroups: sourceGroups,
                  onChanged: onChanged,
                ),
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodayTimerRecordsList extends StatelessWidget {
  final List<FocusTimeData> records;
  final TimerNotifier timerNotifier;
  final TimerStartCallback onStart;
  final List<TaskList> sourceGroups;
  final Future<void> Function()? onChanged;

  const TodayTimerRecordsList({
    super.key,
    required this.records,
    required this.timerNotifier,
    required this.onStart,
    this.sourceGroups = const [],
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: records
          .map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TodayTimerRecordTile(
                record: record,
                timerNotifier: timerNotifier,
                onStart: onStart,
                sourceGroups: sourceGroups,
                onChanged: onChanged,
                colorScheme: colorScheme,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TodayTimerRecordTile extends StatelessWidget {
  final FocusTimeData record;
  final TimerNotifier timerNotifier;
  final TimerStartCallback onStart;
  final List<TaskList> sourceGroups;
  final Future<void> Function()? onChanged;
  final ColorScheme colorScheme;

  const _TodayTimerRecordTile({
    required this.record,
    required this.timerNotifier,
    required this.onStart,
    required this.sourceGroups,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final sourceLabel = timerRecordSourceLabel(record);
    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showTimerRecordActions(
          context: context,
          record: record,
          timerNotifier: timerNotifier,
          onStart: onStart,
          sourceGroups: sourceGroups,
          onChanged: onChanged,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                timerIconForType(record.type),
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        timerLabelForType(record.type),
                        formatRecordTimeRange(record),
                        if (sourceLabel.isNotEmpty) sourceLabel,
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatShortDuration(record.durationMs),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: '更多操作',
                onPressed: () => showTimerRecordActions(
                  context: context,
                  record: record,
                  timerNotifier: timerNotifier,
                  onStart: onStart,
                  sourceGroups: sourceGroups,
                  onChanged: onChanged,
                ),
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
