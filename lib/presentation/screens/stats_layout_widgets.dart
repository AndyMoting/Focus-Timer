part of 'stats_screen.dart';

class _StatsContent extends StatelessWidget {
  final StatsSnapshot snapshot;
  final List<StatsChartId> visibleCharts;
  final ColorScheme colorScheme;
  final VoidCallback onPreviousRange;
  final VoidCallback onNextRange;
  final VoidCallback onManualEntry;
  final ValueChanged<int> onDailyCheckIn;
  final ValueChanged<FocusTimeData> onRecordTap;
  final ValueChanged<DailyLog> onDailyLogTap;

  const _StatsContent({
    required this.snapshot,
    required this.visibleCharts,
    required this.colorScheme,
    required this.onPreviousRange,
    required this.onNextRange,
    required this.onManualEntry,
    required this.onDailyCheckIn,
    required this.onRecordTap,
    required this.onDailyLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final range = snapshot.range;
    final chartWidgets = visibleCharts
        .map((chart) => _buildChartSection(chart))
        .whereType<Widget>()
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 136),
      children: [
        _RangeNavigator(
          label: _rangeLabel(range),
          onPrevious: onPreviousRange,
          onNext: onNextRange,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _SummaryPanel(snapshot: snapshot, colorScheme: colorScheme),
        const SizedBox(height: 12),
        _TaskLinkPanel(snapshot: snapshot, colorScheme: colorScheme),
        for (var i = 0; i < chartWidgets.length; i++) ...[
          SizedBox(height: i == 0 ? 22 : 24),
          chartWidgets[i],
        ],
      ],
    );
  }

  Widget? _buildChartSection(StatsChartId chart) {
    return switch (chart) {
      StatsChartId.heatmap => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: '热力图',
            icon: Icons.grid_view_outlined,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          _DailyHeatmap(
            snapshot: snapshot,
            colorScheme: colorScheme,
            onRecordTap: onRecordTap,
            onDailyLogTap: onDailyLogTap,
          ),
          const SizedBox(height: 12),
          _HeatLegend(colorScheme: colorScheme),
        ],
      ),
      StatsChartId.pie => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: '饼图',
            icon: Icons.pie_chart_outline,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          _PieSection(snapshot: snapshot, colorScheme: colorScheme),
        ],
      ),
      StatsChartId.dailyLog => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: '打卡',
            icon: Icons.fact_check_outlined,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          _DailyLogPanel(
            snapshot: snapshot,
            colorScheme: colorScheme,
            onCheckIn: onDailyCheckIn,
          ),
        ],
      ),
      StatsChartId.timeline => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: '时间轴',
            icon: Icons.timeline,
            action: TextButton.icon(
              onPressed: onManualEntry,
              icon: const Icon(Icons.add),
              label: const Text('补录'),
            ),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          _TimelineSection(
            snapshot: snapshot,
            colorScheme: colorScheme,
            onRecordTap: onRecordTap,
            onDailyLogTap: onDailyLogTap,
          ),
        ],
      ),
    };
  }

  String _rangeLabel(StatsDateRange range) {
    return switch (range.type) {
      StatsRangeType.day => _formatDate(range.start),
      StatsRangeType.week =>
        '${_formatDate(range.start)} - ${_formatDate(range.end)}',
      StatsRangeType.month => '${range.start.year}年${range.start.month}月',
      StatsRangeType.year => '${range.start.year}年',
      StatsRangeType.custom =>
        '${_formatDate(range.start)} - ${_formatDate(range.end)}',
    };
  }
}

class _TaskLinkPanel extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;

  const _TaskLinkPanel({required this.snapshot, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final taskDurations = snapshot.durationByTaskName.entries.take(4).toList();
    final listDurations = snapshot.durationByListName.entries.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.hub_outlined, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '待办联动',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Text(
                '${snapshot.linkedFocusRecords.length} 条关联记录',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: '完成',
                  value:
                      '${snapshot.completedTaskCountInRange}/${snapshot.taskCountInRange}',
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: '完成率',
                  value: '${(snapshot.completionRate * 100).round()}%',
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: '逾期',
                  value: '${snapshot.overdueTaskCount} 个',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: '关联耗时',
                  value: _formatDurationMs(snapshot.linkedFocusMs),
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: '重点完成',
                  value: '${snapshot.focusTaskCompletedCountInRange} 个',
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: '计划命中',
                  value: '${snapshot.planHitRecordCount} 次',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          if (snapshot.plannedFocusRecordCount > 0) ...[
            const SizedBox(height: 12),
            _PlanHitBar(snapshot: snapshot, colorScheme: colorScheme),
          ],
          if (snapshot.linkedEstimatedTaskMs > 0 ||
              snapshot.estimatedTaskMs > 0) ...[
            const SizedBox(height: 12),
            _EstimateActualBar(snapshot: snapshot, colorScheme: colorScheme),
          ],
          if (taskDurations.isNotEmpty || listDurations.isNotEmpty) ...[
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 520;
                final taskList = _AttributionList(
                  title: '按待办',
                  entries: taskDurations,
                  colorScheme: colorScheme,
                );
                final groupList = _AttributionList(
                  title: '按分组',
                  entries: listDurations,
                  colorScheme: colorScheme,
                );
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: taskList),
                      const SizedBox(width: 14),
                      Expanded(child: groupList),
                    ],
                  );
                }
                return Column(
                  children: [taskList, const SizedBox(height: 12), groupList],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanHitBar extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;

  const _PlanHitBar({required this.snapshot, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final ratio = snapshot.planHitRate.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '计划 vs 实际',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              '${snapshot.planHitRecordCount}/${snapshot.plannedFocusRecordCount} · ${(ratio * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: ratio,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class _EstimateActualBar extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;

  const _EstimateActualBar({required this.snapshot, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final estimateMs = snapshot.linkedEstimatedTaskMs > 0
        ? snapshot.linkedEstimatedTaskMs
        : snapshot.estimatedTaskMs;
    final actualMs = snapshot.linkedFocusMs;
    final ratio = estimateMs <= 0
        ? 0.0
        : (actualMs / estimateMs).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '预计 vs 实际',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              '${_formatDurationMs(actualMs)} / ${_formatDurationMs(estimateMs)}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: ratio,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class _AttributionList extends StatelessWidget {
  final String title;
  final List<MapEntry<String, int>> entries;
  final ColorScheme colorScheme;

  const _AttributionList({
    required this.title,
    required this.entries,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _AttributionShell(
        title: title,
        colorScheme: colorScheme,
        child: Text(
          '暂无关联',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final maxMs = entries.fold<int>(
      0,
      (max, entry) => math.max(max, entry.value),
    );
    return _AttributionShell(
      title: title,
      colorScheme: colorScheme,
      child: Column(
        children: [
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AttributionRow(
                name: entry.key,
                durationMs: entry.value,
                maxMs: maxMs,
                colorScheme: colorScheme,
              ),
            ),
        ],
      ),
    );
  }
}

class _AttributionShell extends StatelessWidget {
  final String title;
  final Widget child;
  final ColorScheme colorScheme;

  const _AttributionShell({
    required this.title,
    required this.child,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _AttributionRow extends StatelessWidget {
  final String name;
  final int durationMs;
  final int maxMs;
  final ColorScheme colorScheme;

  const _AttributionRow({
    required this.name,
    required this.durationMs,
    required this.maxMs,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxMs <= 0 ? 0.0 : (durationMs / maxMs).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDurationMs(durationMs),
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 5,
            value: ratio,
            backgroundColor: colorScheme.surfaceContainerLow,
          ),
        ),
      ],
    );
  }
}

class _FloatingRangeControl extends StatelessWidget {
  final StatsRangeType selected;
  final ValueChanged<StatsRangeType> onChanged;
  final VoidCallback onCustomRange;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ColorScheme colorScheme;

  const _FloatingRangeControl({
    required this.selected,
    required this.onChanged,
    required this.onCustomRange,
    required this.onPrevious,
    required this.onNext,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        elevation: 10,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RangeIconButton(
                tooltip: '上一段',
                icon: Icons.chevron_left,
                onPressed: onPrevious,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 4),
              for (final type in StatsRangeType.values) ...[
                _RangePill(
                  label: _rangeTypeLabel(type),
                  selected: selected == type,
                  onTap: type == StatsRangeType.custom
                      ? onCustomRange
                      : () => onChanged(type),
                  colorScheme: colorScheme,
                ),
                if (type != StatsRangeType.values.last)
                  const SizedBox(width: 4),
              ],
              const SizedBox(width: 4),
              _RangeIconButton(
                tooltip: '下一段',
                icon: Icons.chevron_right,
                onPressed: onNext,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _rangeTypeLabel(StatsRangeType type) {
    return switch (type) {
      StatsRangeType.day => '日',
      StatsRangeType.week => '周',
      StatsRangeType.month => '月',
      StatsRangeType.year => '年',
      StatsRangeType.custom => '自定',
    };
  }
}

class _RangePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _RangePill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? colorScheme.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: SizedBox(
          width: 52,
          height: 42,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RangeIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const _RangeIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: Icon(icon),
      color: colorScheme.onSurfaceVariant,
    );
  }
}

class _RangeNavigator extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ColorScheme colorScheme;

  const _RangeNavigator({
    required this.label,
    required this.onPrevious,
    required this.onNext,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: '上一段',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        IconButton(
          tooltip: '下一段',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;

  const _SummaryPanel({required this.snapshot, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              label: '总专注',
              value: _formatDurationMs(snapshot.totalFocusMs),
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            child: _StatTile(
              label: '记录',
              value: '${snapshot.focusRecordCount} 次',
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            child: _StatTile(
              label: '日均',
              value: _formatDurationMs(snapshot.averageDailyFocusMs),
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyLogPanel extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;
  final ValueChanged<int> onCheckIn;

  const _DailyLogPanel({
    required this.snapshot,
    required this.colorScheme,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final wake = snapshot.anchorWakeLog;
    final sleep = snapshot.anchorSleepLog;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.fact_check_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '作息打卡',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Text(
                '本段 ${snapshot.wakeLogCount + snapshot.sleepLogCount} 条',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: '起床',
                    value: '${snapshot.wakeLogCount} 次',
                    colorScheme: colorScheme,
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    label: '睡觉',
                    value: '${snapshot.sleepLogCount} 次',
                    colorScheme: colorScheme,
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    label: '覆盖',
                    value: '${snapshot.dailyLogActiveDays} 天',
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DailyLogStatusTile(
                  icon: Icons.wb_sunny_outlined,
                  title: '起床',
                  value: wake == null
                      ? '未打卡'
                      : _formatTime(
                          DateTime.fromMillisecondsSinceEpoch(wake.loggedAt),
                        ),
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DailyLogStatusTile(
                  icon: Icons.bedtime_outlined,
                  title: '睡觉',
                  value: sleep == null
                      ? '未打卡'
                      : _formatTime(
                          DateTime.fromMillisecondsSinceEpoch(sleep.loggedAt),
                        ),
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => onCheckIn(AppConstants.dailyLogWake),
                  icon: const Icon(Icons.wb_sunny_outlined),
                  label: const Text('起床'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => onCheckIn(AppConstants.dailyLogSleep),
                  icon: const Icon(Icons.bedtime_outlined),
                  label: const Text('睡觉'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyLogStatusTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final ColorScheme colorScheme;

  const _DailyLogStatusTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? action;
  final ColorScheme colorScheme;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.action,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        ?action,
      ],
    );
  }
}
