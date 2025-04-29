import 'package:flutter/material.dart';

class HomeWeather extends StatelessWidget {
  const HomeWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with real weather API later
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.wb_sunny, color: Colors.orange, size: 36),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kathmandu', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text('22°C, Sunny', style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
          ],
        ),
      ),
    );
  }
}
