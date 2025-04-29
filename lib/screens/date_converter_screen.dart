import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class DateConverterScreen extends StatefulWidget {
  const DateConverterScreen({super.key});

  @override
  State<DateConverterScreen> createState() => _DateConverterScreenState();
}

class _DateConverterScreenState extends State<DateConverterScreen> {
  // For BS→AD
  int? _pickedBsYear;
  int? _pickedBsMonth;
  int? _pickedBsDay;
  DateTime? _convertedAdDate;

  // For AD→BS
  int? _pickedAdYear;
  int? _pickedAdMonth;
  int? _pickedAdDay;
  NepaliDateTime? _convertedBsDate;

  void _updateAdToBs() {
    if (_pickedAdYear != null && _pickedAdMonth != null && _pickedAdDay != null) {
      try {
        final adDate = DateTime(_pickedAdYear!, _pickedAdMonth!, _pickedAdDay!);
        _convertedBsDate = NepaliDateTime.fromDateTime(adDate);
      } catch (e) {
        _convertedBsDate = null;
      }
    } else {
      _convertedBsDate = null;
    }
  }

  void _updateBsToAd() {
    if (_pickedBsYear != null && _pickedBsMonth != null && _pickedBsDay != null) {
      try {
        final bsDate = NepaliDateTime(_pickedBsYear!, _pickedBsMonth!, _pickedBsDay!);
        _convertedAdDate = bsDate.toDateTime();
      } catch (e) {
        _convertedAdDate = null;
      }
    } else {
      _convertedAdDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Date Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BS to AD
              Text(
                "Convert from BS to AD",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // --- BS to AD via dropdowns ---
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Year'),
                      value: _pickedBsYear,
                      items: List.generate(101, (i) => 2000 + i)
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _pickedBsYear = val;
                          _updateBsToAd();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Month'),
                      value: _pickedBsMonth,
                      items: List.generate(12, (i) => i + 1)
                          .map((month) => DropdownMenuItem(
                                value: month,
                                child: Text(month.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _pickedBsMonth = val;
                          _updateBsToAd();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Day'),
                      value: _pickedBsDay,
                      items: List.generate(32, (i) => i + 1)
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text(day.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _pickedBsDay = val;
                          _updateBsToAd();
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_pickedBsYear != null && _pickedBsMonth != null && _pickedBsDay != null && _convertedAdDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nepali (BS): ", style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text("${_pickedBsYear!}-${_pickedBsMonth!.toString().padLeft(2, '0')}-${_pickedBsDay!.toString().padLeft(2, '0')}", style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text("English (AD): ${_convertedAdDate!.toLocal().toString().split(' ')[0]}", style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              const Divider(height: 40),
              // AD to BS
              Text(
                "Convert from AD to BS",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // --- AD to BS via dropdowns ---
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Year'),
                      value: _pickedAdYear,
                      items: List.generate(151, (i) => 1950 + i)
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _pickedAdYear = val;
                          _updateAdToBs();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Month'),
                      value: _pickedAdMonth,
                      items: List.generate(12, (i) => i + 1)
                          .map((month) => DropdownMenuItem(
                                value: month,
                                child: Text(month.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _pickedAdMonth = val;
                          _updateAdToBs();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Day'),
                      value: _pickedAdDay,
                      items: List.generate(31, (i) => i + 1)
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text(day.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _pickedAdDay = val;
                          _updateAdToBs();
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_pickedAdYear != null && _pickedAdMonth != null && _pickedAdDay != null && _convertedBsDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("English (AD): ", style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text("${_pickedAdYear!}-${_pickedAdMonth!.toString().padLeft(2, '0')}-${_pickedAdDay!.toString().padLeft(2, '0')}", style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text("Nepali (BS): ${_convertedBsDate!.format('yyyy-MM-dd')}", style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
