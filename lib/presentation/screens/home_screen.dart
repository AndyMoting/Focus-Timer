import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/timer_screen.dart';
import 'package:focus_timer/presentation/screens/group_list_screen.dart';
import 'package:focus_timer/presentation/screens/profile_screen.dart';
import 'package:focus_timer/presentation/screens/stats_screen.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

final homeTabIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(homeTabIndexProvider);
    final timerState = ref.watch(timerProvider);
    final hasActiveTimer = timerState.state != AppConstants.stateStop;
    final hasAutoOpenedTimer = useRef(false);
    final hasRescheduledReminders = useRef(false);

    useEffect(() {
      if (hasRescheduledReminders.value) return null;
      hasRescheduledReminders.value = true;
      Future.microtask(() {
        ref.read(groupListProvider.notifier).rescheduleFutureReminders();
      });
      return null;
    }, const []);

    useEffect(() {
      if (!hasActiveTimer || hasAutoOpenedTimer.value || tabIndex == 1) {
        return null;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || hasAutoOpenedTimer.value) return;
        hasAutoOpenedTimer.value = true;
        ref.read(homeTabIndexProvider.notifier).state = 1;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已恢复正在进行的计时'),
            duration: Duration(seconds: 1),
          ),
        );
      });
      return null;
    }, [hasActiveTimer]);

    final tabs = const [
      _TabItem(icon: Icons.checklist, label: '待办'),
      _TabItem(icon: Icons.timer, label: '计时'),
      _TabItem(icon: Icons.bar_chart, label: '统计'),
      _TabItem(icon: Icons.person, label: '我的'),
    ];

    final screens = const [
      GroupListScreen(),
      TimerScreen(),
      StatsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: tabIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (i) {
          hasAutoOpenedTimer.value = true;
          ref.read(homeTabIndexProvider.notifier).state = i;
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: tabs.map((t) {
          final isTimerTab = t.label == '计时';
          final icon = Icon(t.icon);
          return NavigationDestination(
            icon: isTimerTab && hasActiveTimer ? Badge(child: icon) : icon,
            selectedIcon: isTimerTab && hasActiveTimer
                ? Badge(child: Icon(t.icon))
                : Icon(t.icon),
            label: t.label,
          );
        }).toList(),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
