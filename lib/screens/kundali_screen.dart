import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../providers/language_provider.dart';
import '../services/astrology_service.dart';

class KundaliScreen extends StatefulWidget {
  const KundaliScreen({super.key});

  @override
  State<KundaliScreen> createState() => _KundaliScreenState();
}

class _KundaliScreenState extends State<KundaliScreen> {
  final _formKey = GlobalKey<FormState>();
  final _astrologyService = AstrologyService();
  NepaliDateTime _selectedDate = NepaliDateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _name = '';
  String _birthPlace = '';
  Map<String, dynamic>? _kundaliResult;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('कुण्डली', 'Kundali')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                languageProvider.getText('जन्म विवरण', 'Birth Details'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: languageProvider.getText('नाम', 'Name'),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return languageProvider.getText(
                      'कृपया नाम लेख्नुहोस्',
                      'Please enter name',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Birth Place Field
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      languageProvider.getText('जन्म स्थान', 'Birth Place'),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => _birthPlace = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return languageProvider.getText(
                      'कृपया जन्म स्थान लेख्नुहोस्',
                      'Please enter birth place',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date Picker
              ListTile(
                title:
                    Text(languageProvider.getText('जन्म मिति', 'Birth Date')),
                subtitle: Text('${_selectedDate.toDateTime()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate.toDateTime(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = NepaliDateTime.fromDateTime(picked);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // Time Picker
              ListTile(
                title: Text(languageProvider.getText('जन्म समय', 'Birth Time')),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _calculateKundali();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      languageProvider.getText(
                          'कुण्डली बनाउनुहोस्', 'Generate Kundali'),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              if (_kundaliResult != null) ...[
                const SizedBox(height: 24),
                Text(
                  languageProvider.getText('कुण्डली परिणाम', 'Kundali Result'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${languageProvider.getText('नाम', 'Name')}: $_name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${languageProvider.getText('जन्म स्थान', 'Birth Place')}: $_birthPlace',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${languageProvider.getText('जन्म मिति', 'Birth Date')}: ${_selectedDate.toDateTime()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${languageProvider.getText('जन्म समय', 'Birth Time')}: ${_selectedTime.format(context)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          languageProvider.getText('ग्रहहरू', 'Planets'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...(_kundaliResult!['planets'] as Map<String, double>)
                            .entries
                            .map((e) => Text('${e.key}: ${e.value}°')),
                        const SizedBox(height: 16),
                        Text(
                          languageProvider.getText('भविष्यवाणी', 'Predictions'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...(_kundaliResult!['predictions']
                                as Map<String, String>)
                            .entries
                            .map((e) => Text('${e.key}: ${e.value}')),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _calculateKundali() {
    final birthChart = _astrologyService.generateBirthChart(
      _selectedDate,
      _selectedTime,
      _birthPlace,
    );
    final predictions = _astrologyService.generatePredictions(
      birthChart['planets'] as Map<String, double>,
    );
    setState(() {
      _kundaliResult = {
        ...birthChart,
        'predictions': predictions,
      };
    });
  }
}
