import 'package:flutter/material.dart';

Future<TimeOfDay?> showAppTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  String title = '选择时间',
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return _AppTimePickerSheet(initialTime: initialTime, title: title);
    },
  );
}

class _AppTimePickerSheet extends StatefulWidget {
  final TimeOfDay initialTime;
  final String title;

  const _AppTimePickerSheet({required this.initialTime, required this.title});

  @override
  State<_AppTimePickerSheet> createState() => _AppTimePickerSheetState();
}

class _AppTimePickerSheetState extends State<_AppTimePickerSheet> {
  late int _hour;
  late int _minute;
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _hour);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${_twoDigits(_hour)}:${_twoDigits(_minute)}',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _WheelLabel(
                        label: '时',
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 44),
                    Expanded(
                      child: _WheelLabel(
                        label: '分',
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 198,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.56,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.18),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _TimeWheel(
                              controller: _hourController,
                              itemCount: 24,
                              selectedItem: _hour,
                              onSelectedItemChanged: (value) {
                                setState(() => _hour = value);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 44,
                            child: Center(
                              child: Text(
                                ':',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _TimeWheel(
                              controller: _minuteController,
                              itemCount: 60,
                              selectedItem: _minute,
                              onSelectedItemChanged: (value) {
                                setState(() => _minute = value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('取消'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => Navigator.pop(
                        context,
                        TimeOfDay(hour: _hour, minute: _minute),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('确定'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WheelLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _WheelLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _TimeWheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedItem;
  final ValueChanged<int> onSelectedItemChanged;

  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.selectedItem,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 46,
      diameterRatio: 1.35,
      perspective: 0.002,
      physics: const FixedExtentScrollPhysics(),
      overAndUnderCenterOpacity: 0.42,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final selected = index == selectedItem;
          return Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              style: (textTheme.titleLarge ?? const TextStyle()).copyWith(
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                fontSize: selected ? 24 : 19,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0,
              ),
              child: Text(_twoDigits(index)),
            ),
          );
        },
      ),
    );
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
