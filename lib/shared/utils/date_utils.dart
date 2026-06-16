/// 日期计算工具
class DateUtils {
  DateUtils._();

  /// 计算从 1970-01-01 到指定日期的天数
  ///
  /// 用于热力图和日统计数据的索引
  static int calculateDayNum(DateTime date) {
    final epoch = DateTime(1970, 1, 1);
    final difference = date.difference(epoch);
    return difference.inDays;
  }

  /// 根据 dayNum 还原日期
  static DateTime dateFromDayNum(int dayNum) {
    final epoch = DateTime(1970, 1, 1);
    return epoch.add(Duration(days: dayNum));
  }

  /// 获取今天的 dayNum
  static int get todayDayNum {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return calculateDayNum(today);
  }

  /// 格式化时长（毫秒）为 HH:MM:SS
  static String formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }

  /// 格式化日期为 yyyy-MM-dd
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
