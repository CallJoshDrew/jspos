String formatDateTime(DateTime dateTime) {
  final day = dateTime.day;
  final month = _getMonthName(dateTime.month);
  final year = dateTime.year;
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';

  final daySuffix = _getDaySuffix(day);

  return '$day$daySuffix $month $year - $hour:$minute $amPm';
}

String _getMonthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th'; // Special case for 11th, 12th, 13th
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
