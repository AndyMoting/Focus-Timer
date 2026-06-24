import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:focus_timer/presentation/providers/timer_settings_provider.dart';
import 'package:focus_timer/presentation/screens/app_time_picker_sheet.dart';

class TimerSettingsScreen extends ConsumerWidget {
  const TimerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(timerSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('计时设置'), centerTitle: false),
      body: SafeArea(
        child: settingsAsync.when(
          data: (settings) => _TimerSettingsContent(settings: settings),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('设置加载失败：$error')),
        ),
      ),
    );
  }
}

class _TimerSettingsContent extends ConsumerWidget {
  final TimerSettingsValue settings;

  const _TimerSettingsContent({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _SettingsSection(
          title: '时间',
          children: [
            ListTile(
              leading: const Icon(Icons.today_outlined),
              title: const Text('新一天开始时间'),
              subtitle: Text(_formatMinute(settings.dayStartMinute)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickDayStart(context, ref, settings),
            ),
            ListTile(
              leading: const Icon(Icons.notification_important_outlined),
              title: const Text('提前提醒'),
              subtitle: Text(
                settings.earlyReminderMinutes <= 0
                    ? '关闭'
                    : '结束前 ${settings.earlyReminderMinutes} 分钟',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickEarlyReminder(context, ref, settings),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsSection(
          title: '提醒',
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text('完成通知'),
              subtitle: const Text('计时结束时发送本地通知'),
              value: settings.completionNotification,
              onChanged: (value) =>
                  _save(ref, settings.copyWith(completionNotification: value)),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_outlined),
              title: const Text('通知声音'),
              value: settings.soundEnabled,
              onChanged: settings.completionNotification
                  ? (value) =>
                        _save(ref, settings.copyWith(soundEnabled: value))
                  : null,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration_outlined),
              title: const Text('震动'),
              value: settings.vibrationEnabled,
              onChanged: settings.completionNotification
                  ? (value) =>
                        _save(ref, settings.copyWith(vibrationEnabled: value))
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsSection(
          title: '运行页',
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.screen_lock_portrait_outlined),
              title: const Text('屏幕常亮'),
              subtitle: const Text('计时运行时保持屏幕亮起'),
              value: settings.keepScreenOn,
              onChanged: (value) =>
                  _save(ref, settings.copyWith(keepScreenOn: value)),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('时钟样式'),
              subtitle: Text(_clockStyleLabel(settings.clockStyle)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickClockStyle(context, ref, settings),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDayStart(
    BuildContext context,
    WidgetRef ref,
    TimerSettingsValue settings,
  ) async {
    final picked = await showAppTimePicker(
      context: context,
      title: '新一天开始时间',
      initialTime: TimeOfDay(
        hour: settings.dayStartMinute ~/ 60,
        minute: settings.dayStartMinute % 60,
      ),
    );
    if (picked == null) return;
    await _save(
      ref,
      settings.copyWith(dayStartMinute: picked.hour * 60 + picked.minute),
    );
  }

  Future<void> _pickEarlyReminder(
    BuildContext context,
    WidgetRef ref,
    TimerSettingsValue settings,
  ) async {
    final value = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0, 1, 3, 5, 10, 15]
              .map(
                (minutes) => ListTile(
                  leading: Icon(
                    settings.earlyReminderMinutes == minutes
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(minutes == 0 ? '关闭' : '结束前 $minutes 分钟'),
                  onTap: () => Navigator.pop(context, minutes),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (value == null) return;
    await _save(ref, settings.copyWith(earlyReminderMinutes: value));
  }

  Future<void> _pickClockStyle(
    BuildContext context,
    WidgetRef ref,
    TimerSettingsValue settings,
  ) async {
    final value = await showModalBottomSheet<TimerClockStyle>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TimerClockStyle.values
              .map(
                (style) => ListTile(
                  leading: Icon(_clockStyleIcon(style)),
                  title: Text(_clockStyleLabel(style)),
                  subtitle: Text(_clockStyleDescription(style)),
                  trailing: settings.clockStyle == style
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => Navigator.pop(context, style),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (value == null) return;
    await _save(ref, settings.copyWith(clockStyle: value));
  }

  Future<void> _save(WidgetRef ref, TimerSettingsValue settings) async {
    await ref.read(timerSettingsProvider.notifier).save(settings);
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ),
        Material(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

String _formatMinute(int minuteOfDay) {
  final hour = (minuteOfDay ~/ 60).toString().padLeft(2, '0');
  final minute = (minuteOfDay % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _clockStyleLabel(TimerClockStyle style) {
  return switch (style) {
    TimerClockStyle.ring => '环形',
    TimerClockStyle.digital => '数字',
    TimerClockStyle.flip => '翻页感',
    TimerClockStyle.bar => '进度条',
    TimerClockStyle.minimal => '极简',
  };
}

String _clockStyleDescription(TimerClockStyle style) {
  return switch (style) {
    TimerClockStyle.ring => '保留进度环，适合番茄和倒计时',
    TimerClockStyle.digital => '大数字居中，界面更安静',
    TimerClockStyle.flip => '分块数字，更接近桌面时钟',
    TimerClockStyle.bar => '横向进度更直观，适合常亮放桌面',
    TimerClockStyle.minimal => '只保留时间和名称，低干扰',
  };
}

IconData _clockStyleIcon(TimerClockStyle style) {
  return switch (style) {
    TimerClockStyle.ring => Icons.donut_large_outlined,
    TimerClockStyle.digital => Icons.timer_outlined,
    TimerClockStyle.flip => Icons.view_agenda_outlined,
    TimerClockStyle.bar => Icons.linear_scale_outlined,
    TimerClockStyle.minimal => Icons.horizontal_rule,
  };
}
