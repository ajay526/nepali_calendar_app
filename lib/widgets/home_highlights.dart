import 'package:flutter/material.dart';
import '../utils/date_converter.dart';

class HomeHighlights extends StatelessWidget {
  const HomeHighlights({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bs = DateConverter.convertADToBS(now);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Highlights', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('BS: ${bs['year']} ${bs['month']} ${bs['day']}'),
                const SizedBox(width: 16),
                Text('AD: ${now.year}-${now.month}-${now.day}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('No major events today.', style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
      ),
    );
  }
}
