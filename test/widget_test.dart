import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/main.dart';
import 'package:focus_timer/shared/widgets/permission_gate.dart';

void main() {
  setUp(() => PermissionGate.testing = true);

  testWidgets('app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();
    expect(find.text('待办'), findsWidgets);
    expect(find.text('计时'), findsWidgets);
    expect(find.text('我的'), findsWidgets);
  });
}
