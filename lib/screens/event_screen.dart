import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/language_provider.dart';
import '../services/event_service.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  final _eventService = EventService();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  List<Event> _events = [];
  List<Event> _holidays = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final events = await _eventService.getEvents();
      final holidays = await _eventService.getHolidays();

      setState(() {
        _events = events.where((e) => !e.isHoliday).toList();
        _holidays = holidays;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddEventDialog({bool isHoliday = false}) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageProvider.getText(
            isHoliday ? 'बिदा थप्नुहोस्' : 'कार्यक्रम थप्नुहोस्',
            isHoliday ? 'Add Holiday' : 'Add Event',
          ),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: languageProvider.getText('शीर्षक', 'Title'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return languageProvider.getText(
                        'कृपया शीर्षक लेख्नुहोस्',
                        'Please enter title',
                      );
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: languageProvider.getText('विवरण', 'Description'),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return languageProvider.getText(
                        'कृपया विवरण लेख्नुहोस्',
                        'Please enter description',
                      );
                    }
                    return null;
                  },
                ),
                if (!isHoliday)
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: languageProvider.getText('स्थान', 'Location'),
                    ),
                  ),
                ListTile(
                  title: Text(languageProvider.getText('मिति', 'Date')),
                  subtitle: Text(
                    '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                if (!isHoliday)
                  ListTile(
                    title: Text(languageProvider.getText('समय', 'Time')),
                    subtitle: Text(selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setState(() => selectedTime = time);
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.getText('रद्द गर्नुहोस्', 'Cancel')),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final event = Event(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  description: descriptionController.text,
                  date: DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    isHoliday ? 0 : selectedTime.hour,
                    isHoliday ? 0 : selectedTime.minute,
                  ),
                  isHoliday: isHoliday,
                  location: isHoliday ? null : locationController.text,
                );
                await _eventService.addEvent(event);
                await _loadEvents();
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text(languageProvider.getText('बचत गर्नुहोस्', 'Save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('कार्यक्रमहरू', 'Events')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: languageProvider.getText('कार्यक्रमहरू', 'Events')),
            Tab(text: languageProvider.getText('बिदाहरू', 'Holidays')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(
          isHoliday: _tabController.index == 1,
        ),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadEvents,
                        child: Text(languageProvider.getText(
                          'पुनः प्रयास गर्नुहोस्',
                          'Retry',
                        )),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEventList(_events, false),
                    _buildEventList(_holidays, true),
                  ],
                ),
    );
  }

  Widget _buildEventList(List<Event> items, bool isHoliday) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (items.isEmpty) {
      return Center(
        child: Text(
          languageProvider.getText(
            isHoliday ? 'कुनै बिदा छैन' : 'कुनै कार्यक्रम छैन',
            isHoliday ? 'No holidays' : 'No events',
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(item.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description),
                const SizedBox(height: 4),
                Text(
                  '${item.date.year}-${item.date.month}-${item.date.day}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (item.location != null && item.location!.isNotEmpty)
                  Text(
                    item.location!,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _eventService.deleteEvent(item.id);
                await _loadEvents();
              },
            ),
          ),
        );
      },
    );
  }
}
