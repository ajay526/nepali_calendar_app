import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

import '../utils/nepali_utils.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

typedef OnCalendarChanged = void Function(int year, int month, int day, DateTime adDate);

class NepaliCalendarView extends StatefulWidget {
  final int year;
  final int month;
  final int selectedDay;
  final OnCalendarChanged? onChanged;

  const NepaliCalendarView({Key? key, required this.year, required this.month, required this.selectedDay, this.onChanged}) : super(key: key);

  @override
  _NepaliCalendarViewState createState() => _NepaliCalendarViewState();
}
class _NepaliCalendarViewState extends State<NepaliCalendarView> {
  late List<List<int>> _calendarDays;

  @override
  void didUpdateWidget(covariant NepaliCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _generateCalendarDays();
  }
  @override
  void initState() {
    super.initState();
    _generateCalendarDays();
  }
  void _generateCalendarDays() {
    final year = widget.year;
    final month = widget.month;
    final daysInMonth = NepaliUtils.getDaysInMonth(year, month);
    final firstNepaliDate = NepaliDateTime(year, month, 1);
    // NepaliDateTime.weekday: 1=Sunday, ..., 7=Saturday
    // We want Sunday as index 0, so shift: (weekday - 1)
    final firstWeekday = (firstNepaliDate.weekday - 1) % 7;

    _calendarDays = [];
    var currentWeek = List.filled(7, 0);
    var currentDay = 1;

    // Fill in the first week with empty days and the first few days of the month
    for (var i = 0; i < 7; i++) {
      if (i < firstWeekday) {
        currentWeek[i] = 0;
      } else {
        currentWeek[i] = currentDay++;
      }
    }
    _calendarDays.add(currentWeek);

    // Fill in the rest of the weeks
    while (currentDay <= daysInMonth) {
      currentWeek = List.filled(7, 0);
      for (var i = 0; i < 7 && currentDay <= daysInMonth; i++) {
        currentWeek[i] = currentDay++;
      }
      _calendarDays.add(currentWeek);
    }
  }
  void _onDaySelected(int day) {
    if (day == 0) return;
    final bsDate = NepaliDateTime(widget.year, widget.month, day);
    final adDate = bsDate.toDateTime();
    if (widget.onChanged != null) {
      widget.onChanged!(widget.year, widget.month, day, adDate);
    }
  }
  void _onMonthChanged(int delta) {
    int year = widget.year;
    int month = widget.month + delta;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    if (widget.onChanged != null) {
      final bsDate = NepaliDateTime(year, month, 1);
      widget.onChanged!(year, month, 1, bsDate.toDateTime());
    }
  }
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _onMonthChanged(-1),
              tooltip: languageProvider.getText('अघिल्लो महिना', 'Previous Month'),
            ),
            Text(
              NepaliUtils.getNepaliMonthName(widget.month),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _onMonthChanged(1),
              tooltip: languageProvider.getText('अर्को महिना', 'Next Month'),
            ),
          ],
        ),
        // Weekday header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .asMap()
                .entries
                .map((entry) => Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: entry.key == 6
                              ? Colors.red // Saturday header
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
        ),
        // Calendar grid
        ..._calendarDays.map((week) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: week.asMap().entries.map((entry) {
                final i = entry.key; // index in the week (0=Sun, 6=Sat)
                final day = entry.value;
                final isSelected = day > 0 && day == widget.selectedDay;
                final isSaturday = i == 6 && day > 0;
                return Expanded(
                  child: GestureDetector(
                    onTap: day > 0 ? () => _onDaySelected(day) : null,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                            : null,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: day > 0
                          ? Text(
                              day.toString(),
                              style: TextStyle(
                                color: isSaturday
                                    ? Colors.red
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                );
              }).toList(),
            )),
        // Display selected date (optional)
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'BS: ${widget.selectedDay} ${NepaliUtils.getNepaliMonthName(widget.month)} ${widget.year}\nAD: ${NepaliDateTime(widget.year, widget.month, widget.selectedDay).toDateTime().year}-${NepaliDateTime(widget.year, widget.month, widget.selectedDay).toDateTime().month}-${NepaliDateTime(widget.year, widget.month, widget.selectedDay).toDateTime().day}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
