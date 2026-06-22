part of 'stats_screen.dart';

Future<void> _showChartManager(BuildContext context, WidgetRef ref) async {
  final current =
      ref.read(visibleStatsChartsProvider).valueOrNull ??
      [
        StatsChartId.heatmap,
        StatsChartId.pie,
        StatsChartId.dailyLog,
        StatsChartId.timeline,
      ];
  final draftOrder = [
    ...current,
    ...StatsChartId.values.where((chart) => !current.contains(chart)),
  ];
  final visible = current.toSet();

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
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
                    '图表管理',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '拖动调整统计页顺序，关闭后不在统计页显示。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    itemCount: draftOrder.length,
                    onReorderItem: (oldIndex, newIndex) {
                      setState(() {
                        final chart = draftOrder.removeAt(oldIndex);
                        draftOrder.insert(newIndex, chart);
                      });
                    },
                    itemBuilder: (context, index) {
                      final chart = draftOrder[index];
                      final enabled = visible.contains(chart);
                      return _ChartManagerTile(
                        key: ValueKey(chart),
                        index: index,
                        chart: chart,
                        enabled: enabled,
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              visible.add(chart);
                              return;
                            }
                            if (visible.length <= 1) return;
                            visible.remove(chart);
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      final selected = draftOrder
                          .where((chart) => visible.contains(chart))
                          .toList();
                      await ref
                          .read(visibleStatsChartsProvider.notifier)
                          .save(selected);
                      if (!sheetContext.mounted) return;
                      Navigator.pop(sheetContext);
                    },
                    child: const Text('完成'),
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

class _ChartManagerTile extends StatelessWidget {
  final int index;
  final StatsChartId chart;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _ChartManagerTile({
    super.key,
    required this.index,
    required this.chart,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(_chartIcon(chart), color: colorScheme.primary),
        title: Text(_chartTitle(chart)),
        subtitle: Text(_chartSubtitle(chart)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(value: enabled, onChanged: onChanged),
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.drag_handle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _chartIcon(StatsChartId chart) {
  return switch (chart) {
    StatsChartId.heatmap => Icons.grid_view_outlined,
    StatsChartId.pie => Icons.pie_chart_outline,
    StatsChartId.dailyLog => Icons.fact_check_outlined,
    StatsChartId.timeline => Icons.timeline,
  };
}

String _chartTitle(StatsChartId chart) {
  return switch (chart) {
    StatsChartId.heatmap => '热力图',
    StatsChartId.pie => '饼图',
    StatsChartId.dailyLog => '打卡',
    StatsChartId.timeline => '时间轴',
  };
}

String _chartSubtitle(StatsChartId chart) {
  return switch (chart) {
    StatsChartId.heatmap => '查看每日专注分布',
    StatsChartId.pie => '按类型比较时间占比',
    StatsChartId.dailyLog => '记录起床、睡觉和习惯打卡',
    StatsChartId.timeline => '查看和编辑计时记录',
  };
}
