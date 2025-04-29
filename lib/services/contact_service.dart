import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactService {
  static const String _contactsKey = 'contacts';

  Future<List<Map<String, dynamic>>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString(_contactsKey);
    if (contactsJson != null) {
      final List<dynamic> contacts = json.decode(contactsJson);
      return contacts.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> saveContact(Map<String, dynamic> contact) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts.add(contact);
    await prefs.setString(_contactsKey, json.encode(contacts));
  }

  Future<void> updateContact(int index, Map<String, dynamic> contact) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts[index] = contact;
    await prefs.setString(_contactsKey, json.encode(contacts));
  }

  Future<void> deleteContact(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts.removeAt(index);
    await prefs.setString(_contactsKey, json.encode(contacts));
  }
}
