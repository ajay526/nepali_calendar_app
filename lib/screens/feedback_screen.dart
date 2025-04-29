import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _experience = 0;

  final List<String> _labels = [
    'Worst', 'Not Good', 'Fine', 'Look Good', 'Very Good'
  ];
  final List<String> _emojis = [
    '😖', '😕', '😐', '🙂', '😎'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        hintText: '+91 00000 00000',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'xyz123@gmail.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Share your experience in scaling',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final color = _experience == index ? Colors.red : Colors.grey;
                  return Column(
                    children: [
                      Text(
                        _emojis[index],
                        style: TextStyle(fontSize: 32, color: color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          color: color,
                          fontWeight: _experience == index ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Slider(
                value: _experience.toDouble(),
                min: 0,
                max: 4,
                divisions: 4,
                activeColor: Colors.red,
                inactiveColor: Colors.red[100],
                onChanged: (value) {
                  setState(() {
                    _experience = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Add your comments...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitFeedback,
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitFeedback() async {
    if (_formKey.currentState?.validate() != true) return;
    final subject = Uri.encodeComponent('App Feedback');
    final body = Uri.encodeComponent('''
Name: ${_nameController.text}
Contact: ${_contactController.text}
Email: ${_emailController.text}
Experience: ${_labels[_experience]}
Comments: ${_commentController.text}
''');
    final uri = Uri.parse('mailto:info@hawkeye_patro.com?subject=$subject&body=$body');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app.')),
      );
    }
  }
}
