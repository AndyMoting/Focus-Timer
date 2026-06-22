import 'package:flutter/material.dart';

enum TimerRecordAction {
  continueTimer,
  openSource,
  rename,
  changeDuration,
  playEvidence,
  copyEvidence,
  delete,
}

class DurationEditDialog extends StatefulWidget {
  final int initialDurationMs;

  const DurationEditDialog({super.key, required this.initialDurationMs});

  @override
  State<DurationEditDialog> createState() => _DurationEditDialogState();
}

class _DurationEditDialogState extends State<DurationEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final minutes = (widget.initialDurationMs / 60000).round().clamp(1, 9999);
    _controller = TextEditingController(text: '$minutes');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('修改时长'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          suffixText: '分钟',
          border: OutlineInputBorder(),
        ),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onSubmitted: (_) => _submit(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => _submit(context),
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final minutes = int.tryParse(_controller.text.trim());
    if (minutes == null || minutes <= 0) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, minutes * 60 * 1000);
  }
}

class RenameRecordDialog extends StatefulWidget {
  final String initialName;

  const RenameRecordDialog({super.key, required this.initialName});

  @override
  State<RenameRecordDialog> createState() => _RenameRecordDialogState();
}

class _RenameRecordDialogState extends State<RenameRecordDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('重命名记录'),
      content: TextField(
        controller: _controller,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: '名称',
          border: OutlineInputBorder(),
        ),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onSubmitted: (_) => _submit(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => _submit(context),
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, name);
  }
}
