import 'package:flutter/material.dart';

class HomeQuote extends StatelessWidget {
  const HomeQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can randomize or rotate quotes later
    const quote = 'Success is not the key to happiness. Happiness is the key to success.';
    const author = 'Albert Schweitzer';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_quote, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('Motivational Quote', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text('"$quote"', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text('- $author', style: Theme.of(context).textTheme.bodySmall),
            )
          ],
        ),
      ),
    );
  }
}
