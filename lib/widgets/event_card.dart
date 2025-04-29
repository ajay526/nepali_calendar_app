import 'package:flutter/material.dart';
import '../models/smart_event.dart';

class EventCard extends StatelessWidget {
  final SmartEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.event, color: Colors.white),
        ),
        title: Text(
          event.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(event.description),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
        onTap: () {
          // You can handle tapping to open full event details
        },
      ),
    );
  }
}
