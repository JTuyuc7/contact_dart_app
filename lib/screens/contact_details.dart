import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:contact_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactDetails extends StatefulWidget {
  static const routeName = 'details';
  final int contactId;

  const ContactDetails({super.key, required this.contactId});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late int contactId;

  @override
  void initState() {
    super.initState();
    contactId = widget.contactId;
    // You can use contactId to fetch contact details here
  }

  void callContact(String phoneNumber) async {
    // Implement call functionality here
    // final Uri launchUri = Uri(
    //   scheme: 'tel$phoneNumber');

    final url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void messageContact(String phoneNumber) async {
    // Implement message functionality here
    final url = 'sms:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendEmailToContact(String email) async {
    // Implement email functionality here
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (context.mounted) {
        showMessage(context, 'Invalid email address');
      }
    }
  }

  void openMapContact(String address) async {
    // Implement map functionality here
    final query = Uri.encodeComponent(address);
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$query';

    String url = '';
    // check for platform and use appropriate url if needed
    if(Platform.isIOS){
      // iOS specific code
      url = 'http://maps.apple.com/?q=$query';
    } else if(Platform.isAndroid){
      // Android specific code
      url = 'geo:0,0?q=$query';
    }

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (context.mounted) {
        showMessage(context, 'Could not open the map for the given address');
      }
    }
  }

  void onOpenWebsite(String website) async {
    // Implement website functionality here
    final url = website.startsWith('http') ? website : 'http://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (context.mounted) {
        showMessage(context, 'Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Details')),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) =>
            FutureBuilder<ContactModel>(
              future: contactProvider.getInitContactDetails(contactId),
              // key: ValueKey(contactId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(status: 'Loading...');
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  EasyLoading.dismiss();
                }

                if (snapshot.hasData) {
                  final contact = snapshot.data!;
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      // Text('Contact ID: ${contact.id}'),
                      Image.file(
                        File(contact.imageContent!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16.0),
                      // Add more contact details here
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text(contact.name ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Phone'),
                        subtitle: Text(contact.mobile ?? 'N/A'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.call),
                              onPressed: () {
                                // Handle edit action
                                callContact(contact.mobile);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.message),
                              onPressed: () {
                                // Handle delete action
                                messageContact(contact.mobile);
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(
                          contact.email!.isEmpty ? 'N/A' : contact.email!,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                contact.email!.isEmpty ? null : Icons.email,
                              ),
                              onPressed: () {
                                // Handle edit action
                                sendEmailToContact(contact.email!);
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Address'),
                        subtitle: Text(
                          contact.address!.isEmpty ? 'N/A' : contact.address!,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                contact.address!.isEmpty ? null : Icons.map,
                              ),
                              onPressed: () {
                                // Handle edit action
                                openMapContact(contact.address!);
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Website'),
                        subtitle: Text(
                          contact.website!.isEmpty ? 'N/A' : contact.website!,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                contact.website!.isEmpty ? null : Icons.web,
                              ),
                              onPressed: () {
                                onOpenWebsite(contact.website!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      ),
    );
  }
}
