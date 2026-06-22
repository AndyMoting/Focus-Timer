import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus_timer/shared/services/permission_service.dart';

class PermissionGate extends HookWidget {
  final Widget child;

  const PermissionGate({super.key, required this.child});

  static bool testing = false;

  @override
  Widget build(BuildContext context) {
    if (testing) return child;

    final checked = useState(false);

    useEffect(() {
      Future.microtask(() async {
        try {
          if (!context.mounted) return;
          await PermissionService.requestAll(context);
        } catch (_) {}
        if (!context.mounted) return;
        checked.value = true;
      });
      return null;
    }, []);

    if (!checked.value) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}
