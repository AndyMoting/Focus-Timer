import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';
import 'package:focus_timer/presentation/screens/data_export_screen.dart';
import 'package:focus_timer/presentation/screens/day_countdown_screen.dart';
import 'package:focus_timer/presentation/screens/timer_settings_screen.dart';
import 'package:focus_timer/presentation/screens/trash_screen.dart';
import 'package:focus_timer/presentation/screens/video_evidence_screen.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/permission_service.dart';

part 'profile_widgets.dart';
part 'profile_theme_sheets.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 24),
          _buildProfileHeader(colorScheme),
          const SizedBox(height: 32),
          _buildProfileSection(context, '设置', [
            _buildProfileItem(
              Icons.palette_outlined,
              '主题色',
              () => _showThemePicker(context, ref),
            ),
            _buildProfileItem(
              Icons.dark_mode_outlined,
              '显示模式',
              () => _showThemeModePicker(context, ref),
              subtitle: themeModeLabel(themeMode),
            ),
            _buildProfileItem(
              Icons.notifications_outlined,
              '通知权限',
              () => _openNotificationSettings(context),
              subtitle: '系统未弹授权时可手动打开',
            ),
            _buildProfileItem(
              Icons.timer_outlined,
              '计时设置',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimerSettingsScreen()),
              ),
              subtitle: '新一天、提醒、常亮',
            ),
          ]),
          const Divider(),
          _buildProfileSection(context, '提醒', [
            _buildProfileItem(
              Icons.event_outlined,
              '日倒计时',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DayCountdownScreen()),
              ),
              subtitle: '置顶日期和倒数提醒',
            ),
          ]),
          const Divider(),
          _buildProfileSection(context, '数据', [
            _buildProfileItem(
              Icons.download_outlined,
              '导出数据',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DataExportScreen()),
              ),
              subtitle: '导出全部、待办或计时 JSON',
            ),
            _buildProfileItem(
              Icons.video_file_outlined,
              '视频凭证',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoEvidenceScreen()),
              ),
              subtitle: '查看视频文件位置和记录索引',
            ),
            _buildProfileItem(
              Icons.restore_from_trash_outlined,
              '回收站',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrashScreen()),
              ),
            ),
          ]),
          const Divider(),
          _buildProfileSection(context, '其他', [
            _buildProfileItem(
              Icons.info_outline,
              '关于',
              () => _showAbout(context),
              subtitle: '本地优先的专注与待办工具',
            ),
          ]),
        ],
      ),
    );
  }
}

Future<void> _openNotificationSettings(BuildContext context) async {
  await PermissionService.openNotificationSettings();
  if (!context.mounted) return;
  _showProfileSnack(context, '如果系统没有弹出授权，请在设置里手动打开通知');
}

void _showAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: AppConstants.appName,
    applicationVersion: AppConstants.appVersion,
    applicationIcon: const Icon(Icons.timer_outlined, size: 36),
    children: const [
      Text('本地优先的专注计时、待办和统计工具。当前版本优先打磨 Android APK 与离线使用体验。'),
    ],
  );
}

void _showProfileSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
  );
}
