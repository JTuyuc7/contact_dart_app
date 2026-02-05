import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:flutter/foundation.dart';

class ContactProvider extends ChangeNotifier {
  // This class would contain methods to manage contacts,
  // such as fetching, adding, updating, and deleting contacts.
  List<ContactModel> contactList = [];
  ContactModel? contact;

  final db = DBHelper();

  Future<int> insertContact(ContactModel contact) async {
    final id = await db.insertContact(contact);
    contactList.add(contact);
    fetchContacts();
    notifyListeners();
    return id;
  }

  Future<void> fetchContacts() async {
    contactList = await db.getContacts();
    notifyListeners();
  }

  // Using and refreshing the provider after deleting a contact
  // Future<int> deleteContact(int id) async {
  //   final result = await db.deleteContact(id);
  //   contactList.removeWhere((contact) => contact.id == id);
  //   notifyListeners();
  //   return result;
  // }

  Future<int> deleteContact(int id) async {
    // return await db.deleteContact(id);
    final result = await db.deleteContact(id);
    // update the local list of contacts
    contactList.removeWhere((contact) => contact.id == id);
    notifyListeners();
    return result;
  }

  Future<int> updateContact(ContactModel contact) async {
    final result = await db.updateContact(
      contact.id!,
      contact.isFavorite! ? 0 : 1,
    );
    int index = contactList.indexWhere((element) => element.id == contact.id);
    if (index != -1) {
      contactList[index].isFavorite = !contactList[index].isFavorite!;
    }
    notifyListeners();
    return result;
  }

  // Get favorite contacts
  Future<List<ContactModel>> getFavoriteContacts() async {
    return contactList.where((contact) => contact.isFavorite == true).toList();
  }

  // Using the method defined in the db_helper.dart file
  Future<void> getAllFavoriteContacts() async {
    contactList = await db.getFavoriteContacts();
    notifyListeners();
  }

  Future<void> getContactById(int id) async {
    contact = await db.getContactById(id);
    notifyListeners();
  }

  Future<ContactModel> getInitContactDetails(int id) async {
    print('Fetching contact details for ID: $id');
    return await db.getContactById(id);
  }
}
