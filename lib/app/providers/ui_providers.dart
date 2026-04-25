import 'package:flutter_riverpod/flutter_riverpod.dart';

class FabVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void show() => state = true;
  void hide() => state = false;
  
  void setVisible(bool visible) => state = visible;
}

final fabVisibilityProvider = NotifierProvider<FabVisibilityNotifier, bool>(() {
  return FabVisibilityNotifier();
});

// Filter Providers
class ChecklistFilterNotifier extends Notifier<String> {
  @override
  String build() => 'daily';
  void setFilter(String filter) => state = filter;
}

final checklistFilterProvider = NotifierProvider<ChecklistFilterNotifier, String>(() {
  return ChecklistFilterNotifier();
});

class ScheduleFilterNotifier extends Notifier<int> {
  @override
  int build() => 0; // 0: Hari Ini, 1: Mingguan, 2: Kalender
  void setFilter(int index) => state = index;
}

final scheduleFilterProvider = NotifierProvider<ScheduleFilterNotifier, int>(() {
  return ScheduleFilterNotifier();
});

class CalendarSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void setDate(DateTime date) => state = date;
}

final calendarSelectedDateProvider = NotifierProvider<CalendarSelectedDateNotifier, DateTime>(() {
  return CalendarSelectedDateNotifier();
});

class ChecklistSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void setDate(DateTime date) => state = date;
  void nextDay() => state = state.add(const Duration(days: 1));
  void previousDay() => state = state.subtract(const Duration(days: 1));
}

final checklistSelectedDateProvider = NotifierProvider<ChecklistSelectedDateNotifier, DateTime>(() {
  return ChecklistSelectedDateNotifier();
});
