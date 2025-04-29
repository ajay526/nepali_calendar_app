import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

import '../utils/nepali_utils.dart';
import '../widgets/nepali_calendar_view.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late NepaliDateTime _selectedDateBS;
  late DateTime _selectedDateAD;

  @override
  void initState() {
    super.initState();
    _selectedDateAD = DateTime.now();
    _selectedDateBS = NepaliDateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Year and month range
    final int minYear = 2000;
    final int maxYear = 2090;
    final List<int> yearList = List.generate(maxYear - minYear + 1, (i) => minYear + i);
    final List<int> monthList = List.generate(12, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('पात्रो', 'Calendar')),
      ),
      body: Column(
        children: [
          // Calendar header with year/month dropdowns and 'Today' button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Year dropdown
                    DropdownButton<int>(
                      value: _selectedDateBS.year,
                      items: yearList
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                      onChanged: (year) {
                        if (year != null) {
                          setState(() {
                            _selectedDateBS = NepaliDateTime(year, _selectedDateBS.month, 1);
                            _selectedDateAD = _selectedDateBS.toDateTime();
                          });
                        }
                      },
                    ),
                    // Month dropdown
                    DropdownButton<int>(
                      value: _selectedDateBS.month,
                      items: monthList
                          .map((month) => DropdownMenuItem(
                                value: month,
                                child: Text(NepaliUtils.getNepaliMonthName(month)),
                              ))
                          .toList(),
                      onChanged: (month) {
                        if (month != null) {
                          setState(() {
                            _selectedDateBS = NepaliDateTime(_selectedDateBS.year, month, 1);
                            _selectedDateAD = _selectedDateBS.toDateTime();
                          });
                        }
                      },
                    ),
                    // Today button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.today),
                      label: Text(languageProvider.getText('आज', 'Today')),
                      onPressed: () {
                        setState(() {
                          _selectedDateAD = DateTime.now();
                          _selectedDateBS = NepaliDateTime.now();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${NepaliUtils.getNepaliMonthName(_selectedDateBS.month)} ${_selectedDateBS.year}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedDateAD.year} ${_selectedDateAD.month} ${_selectedDateAD.day}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          // Calendar grid
          Expanded(
            child: NepaliCalendarView(
              year: _selectedDateBS.year,
              month: _selectedDateBS.month,
              selectedDay: _selectedDateBS.day,
              onChanged: (year, month, day, adDate) {
                setState(() {
                  _selectedDateBS = NepaliDateTime(year, month, day);
                  _selectedDateAD = _selectedDateBS.toDateTime();
                });
              },
            ),
          ),
          // Events section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageProvider.getText('आजका कार्यक्रमहरू', 'Today\'s Events'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.event, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(languageProvider.getText('नयाँ वर्ष २०८१', 'New Year 2081')),
                  subtitle: const Text('2081-01-01'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.celebration, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(languageProvider.getText('बैशाख पूर्णिमा', 'Baisakh Purnima')),
                  subtitle: const Text('2081-01-15'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
