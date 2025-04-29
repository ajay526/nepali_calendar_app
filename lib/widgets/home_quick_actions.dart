import 'package:flutter/material.dart';

class HomeQuickActions extends StatelessWidget {
  final void Function(int) onActionTap;
  const HomeQuickActions({Key? key, required this.onActionTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.calendar_today, 'label': 'Calendar'},
      {'icon': Icons.newspaper, 'label': 'News'},
      {'icon': Icons.currency_exchange, 'label': 'Forex'},
      {'icon': Icons.radio, 'label': 'Radio'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(actions.length, (i) => GestureDetector(
          onTap: () => onActionTap(i+1), // 1:Calendar, 2:News, 3:Forex, 4:Radio
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                radius: 28,
                child: Icon(actions[i]['icon'] as IconData, color: Theme.of(context).colorScheme.primary, size: 28),
              ),
              const SizedBox(height: 6),
              Text(actions[i]['label'] as String, style: Theme.of(context).textTheme.labelMedium)
            ],
          ),
        )),
      ),
    );
  }
}
