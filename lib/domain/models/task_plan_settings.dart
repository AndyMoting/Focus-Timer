class TaskPlanSettingsValue {
  final int startMinute;
  final int endMinute;
  final int slotMinutes;

  const TaskPlanSettingsValue({
    required this.startMinute,
    required this.endMinute,
    required this.slotMinutes,
  });

  static const defaults = TaskPlanSettingsValue(
    startMinute: 0,
    endMinute: 24 * 60,
    slotMinutes: 60,
  );

  TaskPlanSettingsValue normalized() {
    final safeSlot = allowedSlotMinutes.contains(slotMinutes)
        ? slotMinutes
        : defaults.slotMinutes;
    final safeStart = startMinute.clamp(0, 23 * 60).toInt();
    final safeEnd = endMinute.clamp(60, 24 * 60).toInt();
    if (safeEnd <= safeStart) return defaults;
    return TaskPlanSettingsValue(
      startMinute: safeStart,
      endMinute: safeEnd,
      slotMinutes: safeSlot,
    );
  }

  TaskPlanSettingsValue copyWith({
    int? startMinute,
    int? endMinute,
    int? slotMinutes,
  }) {
    return TaskPlanSettingsValue(
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      slotMinutes: slotMinutes ?? this.slotMinutes,
    ).normalized();
  }

  static const allowedSlotMinutes = [15, 30, 60, 120];

  @override
  bool operator ==(Object other) {
    return other is TaskPlanSettingsValue &&
        other.startMinute == startMinute &&
        other.endMinute == endMinute &&
        other.slotMinutes == slotMinutes;
  }

  @override
  int get hashCode => Object.hash(startMinute, endMinute, slotMinutes);
}
