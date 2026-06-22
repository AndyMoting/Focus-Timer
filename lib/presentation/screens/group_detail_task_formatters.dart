part of 'group_detail_screen.dart';

String _formatDayNum(int dayNum) {
  final date = DateTime(1970).add(Duration(days: dayNum));
  return '${date.month}/${date.day}';
}

String _formatDateTime(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.year}.$month.$day $hour:$minute';
}
