import 'package:flutter/material.dart';

/// Result object returned by timer start sheets.
///
/// The sheets only collect user input; the screen/provider decides how to start
/// or persist a timer.
class TimerStartRequest {
  final int type;
  final String name;
  final int targetDurationMs;
  final int? taskId;
  final int? listId;
  final int? planId;

  const TimerStartRequest({
    required this.type,
    required this.name,
    required this.targetDurationMs,
    this.taskId,
    this.listId,
    this.planId,
  });
}

class TimerSetupSheet extends StatefulWidget {
  final int type;
  final String title;
  final String defaultName;
  final int? initialMinutes;
  final List<int> durationPresets;
  final ValueChanged<int>? onDurationChanged;

  const TimerSetupSheet({
    super.key,
    required this.type,
    required this.title,
    required this.defaultName,
    required this.initialMinutes,
    required this.durationPresets,
    required this.onDurationChanged,
  });

  @override
  State<TimerSetupSheet> createState() => _TimerSetupSheetState();
}

class _TimerSetupSheetState extends State<TimerSetupSheet> {
  late final TextEditingController _nameController;
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.defaultName);
    _selectedMinutes = widget.initialMinutes ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (_, _) => _unfocus(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _unfocus,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 20),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    textInputAction: widget.initialMinutes == null
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: '名称',
                      border: OutlineInputBorder(),
                    ),
                    onTapOutside: (_) => _unfocus(),
                    onSubmitted: (_) {
                      if (widget.initialMinutes == null) {
                        _submit();
                      } else {
                        _unfocus();
                      }
                    },
                  ),
                  if (widget.initialMinutes != null) ...[
                    const SizedBox(height: 16),
                    _buildDurationChoices(context),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('开始'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationChoices(BuildContext context) {
    final isCustom = !widget.durationPresets.contains(_selectedMinutes);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...widget.durationPresets.map(
          (minutes) => ChoiceChip(
            label: Text('$minutes 分'),
            selected: _selectedMinutes == minutes,
            onSelected: (_) => _selectMinutes(minutes),
          ),
        ),
        ChoiceChip(
          label: Text(isCustom ? '$_selectedMinutes 分' : '自定义'),
          selected: isCustom,
          onSelected: (_) async {
            _unfocus();
            final result = await showDialog<int>(
              context: context,
              builder: (_) =>
                  MinuteInputDialog(currentMinutes: _selectedMinutes),
            );
            if (!mounted || result == null) return;
            _selectMinutes(result);
          },
        ),
      ],
    );
  }

  void _selectMinutes(int minutes) {
    setState(() => _selectedMinutes = minutes);
    widget.onDurationChanged?.call(minutes);
  }

  void _submit() {
    _unfocus();
    final name = _nameController.text.trim().isEmpty
        ? widget.defaultName
        : _nameController.text.trim();
    Navigator.pop(
      context,
      TimerStartRequest(
        type: widget.type,
        name: name,
        targetDurationMs: _selectedMinutes * 60 * 1000,
      ),
    );
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class MinuteInputDialog extends StatefulWidget {
  final int currentMinutes;

  const MinuteInputDialog({super.key, required this.currentMinutes});

  @override
  State<MinuteInputDialog> createState() => _MinuteInputDialogState();
}

class _MinuteInputDialogState extends State<MinuteInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.currentMinutes}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('自定义时长'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
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
          child: const Text('确定'),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value <= 0) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, value);
  }
}
