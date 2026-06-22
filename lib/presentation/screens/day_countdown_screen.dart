import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/presentation/providers/countdown_provider.dart';

part 'day_countdown_widgets.dart';
part 'day_countdown_dialog.dart';

class DayCountdownScreen extends HookConsumerWidget {
  const DayCountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countdownState = ref.watch(countdownProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('日倒计时'), centerTitle: true),
      body: Center(
        child: countdownState.targetDate == null
            ? _DayCountdownEmptyState(
                colorScheme: colorScheme,
                onCreate: () =>
                    _showCountdownEditDialog(context, ref, countdownState),
              )
            : _DayCountdownContent(
                state: countdownState,
                colorScheme: colorScheme,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'countdown_edit',
        onPressed: () => _showCountdownEditDialog(context, ref, countdownState),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
