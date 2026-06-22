import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

part 'trash_widgets.dart';
part 'trash_actions.dart';

class TrashScreen extends HookConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashAsync = ref.watch(trashProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('回收站'), centerTitle: true),
      body: trashAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return TrashEmptyState(colorScheme: colorScheme);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final group = groups[index];
              final tasksAsync = ref.watch(taskListProvider(group.id));
              return TrashGroupCard(
                group: group,
                tasksAsync: tasksAsync,
                colorScheme: colorScheme,
                onRestore: () =>
                    ref.read(trashProvider.notifier).restoreGroup(group.id),
                onDeleteForever: () =>
                    _confirmDeleteForever(context, ref, group.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('加载失败')),
      ),
    );
  }
}
