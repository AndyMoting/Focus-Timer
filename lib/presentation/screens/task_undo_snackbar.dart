import 'dart:async';

import 'package:flutter/material.dart';

void showTaskUndoSnackBar(
  BuildContext context, {
  required String message,
  required Future<void> Function() onUndo,
}) {
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 4),
      persist: false,
      action: SnackBarAction(label: '撤销', onPressed: () => unawaited(onUndo())),
    ),
  );
}
