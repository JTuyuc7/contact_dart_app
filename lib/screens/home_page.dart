import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/screens/contact_details.dart';
import 'package:contact_app/screens/scan.dart';
import 'package:contact_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    super.didChangeDependencies();
    // Any additional setup can be done here
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _fetchData() {
    final contactProvider =
    Provider.of<ContactProvider>(context, listen: false);
    if (_selectedIndex == 0) {
      contactProvider.fetchContacts();
    } else if (_selectedIndex == 1) {
      contactProvider.getAllFavoriteContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Consumer<ContactProvider>(
        builder: (context, ContactProvider contactProvider, child) =>
            ListView.builder(
              itemCount: contactProvider.contactList.length,
              itemBuilder: (context, index) {
                final ContactModel contact = contactProvider.contactList[index];
                return Dismissible(

                  // key: Key(contact.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: _showConfirmationDialog,
                  onDismissed: (direction) async {
                    await contactProvider.deleteContact(contact.id!);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${contact.name} deleted')),
                      );
                    }
                  },
                  // onDismissed: (direction) {
                  //   contactProvider.deleteContact(contact.id!);
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('${contact.name} deleted'),
                  //     ),
                  //   );
                  // },
                  key: UniqueKey(),
                  child: ListTile(
                    onTap: () {
                      context.goNamed(ContactDetails.routeName, extra: contact.id);
                    },
                    leading: CircleAvatar(
                      child: Text(
                        contact.name.isNotEmpty
                            ? contact.name[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.mobile),
                    trailing: IconButton(
                      icon: Icon(
                        contact.isFavorite!
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      color: contact.isFavorite! ? Colors.red : null,
                      onPressed: () async {
                        // contactProvider.toggleFavoriteStatus(contact);
                        await contactProvider.updateContact(contact);
                        if (mounted) {
                          showMessage(context, 'Favorite status updated');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Action when button is pressed
          context.goNamed(ScanScreen.routeName);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        // notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            // Handle navigation logic here
            setState(() {
              _selectedIndex = index;
            });
            _fetchData();
          },
          // backgroundColor: Colors.blue[100],
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'All'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profile',
            // ),
          ],
        ),
      ),
    );
  }
}
