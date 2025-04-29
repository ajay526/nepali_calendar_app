import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/contact_service.dart';
import '../utils/app_utils.dart';
import '../config/app_config.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _contactService = ContactService();
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final contacts = await _contactService.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddContactDialog() async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(languageProvider.getText('सम्पर्क थप्नुहोस्', 'Add Contact')),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: languageProvider.getText('नाम', 'Name'),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? languageProvider.getText(
                        'कृपया नाम लेख्नुहोस्', 'Please enter name')
                    : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: languageProvider.getText('फोन', 'Phone'),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? languageProvider.getText('कृपया फोन नम्बर लेख्नुहोस्',
                        'Please enter phone number')
                    : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: languageProvider.getText('इमेल', 'Email'),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? languageProvider.getText(
                        'कृपया इमेल लेख्नुहोस्', 'Please enter email')
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.getText('रद्द गर्नुहोस्', 'Cancel')),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final contact = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'email': emailController.text,
                };
                await _contactService.saveContact(contact);
                await _loadContacts();
                if (mounted) Navigator.pop(context);
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

    final contactInfo = AppConfig.contactInfo;
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('सम्पर्कहरू', 'Contacts')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddContactDialog,
          ),
        ],
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
                        onPressed: _loadContacts,
                        child: Text(languageProvider.getText(
                            'पुनः प्रयास गर्नुहोस्', 'Retry')),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageProvider.getText('एप सम्पर्क', 'App Contact'),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.email, color: Colors.redAccent),
                              title: Text('Email'),
                              subtitle: Text(contactInfo.email),
                              onTap: () => AppUtils.openLink(context, 'mailto:${contactInfo.email}'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone, color: Colors.green),
                              title: Text('Phone'),
                              subtitle: Text(contactInfo.phone),
                              onTap: () => AppUtils.openLink(context, 'tel:${contactInfo.phone}'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.location_on, color: Colors.blue),
                              title: Text('Address'),
                              subtitle: Text(contactInfo.address),
                            ),
                            ListTile(
                              leading: const Icon(Icons.language, color: Colors.orange),
                              title: Text('Website'),
                              subtitle: Text(contactInfo.website),
                              onTap: () => AppUtils.openLink(context, 'https://${contactInfo.website.replaceAll(RegExp(r'^https?://'), '')}'),
                            ),
                            Row(
                              children: [
                                if (contactInfo.socialMedia['facebook'] != null)
                                  IconButton(
                                    icon: const Icon(Icons.facebook, color: Colors.blueAccent),
                                    onPressed: () => AppUtils.openLink(context, contactInfo.socialMedia['facebook']!),
                                  ),
                                if (contactInfo.socialMedia['twitter'] != null)
                                  IconButton(
                                    icon: const Icon(Icons.alternate_email, color: Colors.lightBlue),
                                    onPressed: () => AppUtils.openLink(context, contactInfo.socialMedia['twitter']!),
                                  ),
                                if (contactInfo.socialMedia['instagram'] != null)
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt, color: Colors.purple),
                                    onPressed: () => AppUtils.openLink(context, contactInfo.socialMedia['instagram']!),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_contacts.isEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Icon(Icons.contact_page, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 20),
                          Text(
                            languageProvider.getText('कुनै व्यक्तिगत सम्पर्क छैन', 'No personal contacts yet'),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            languageProvider.getText('नयाँ सम्पर्क थप्न + आइकन थिच्नुहोस्', 'Tap + to add a new contact'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    else
                      ..._contacts.map((contact) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(contact['name'][0].toUpperCase()),
                          ),
                          title: Text(contact['name']),
                          subtitle: Text(contact['phone']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.email),
                                onPressed: () => AppUtils.openLink(
                                    context, 'mailto:${contact['email']}'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.phone),
                                onPressed: () => AppUtils.openLink(
                                    context, 'tel:${contact['phone']}'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await _contactService.deleteContact(_contacts.indexOf(contact));
                                  await _loadContacts();
                                },
                              ),
                            ],
                          ),
                        ),
                      )),
                  ],
                ),
    );
  }
}
