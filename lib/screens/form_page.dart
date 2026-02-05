import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/screens/home_page.dart';
import 'package:contact_app/widgets/form_contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';
import '../utils/helper_functions.dart';

class FormPage extends StatefulWidget {
  static const String routeName = 'form';
  final ContactModel contact;

  const FormPage({super.key, required this.contact});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final designationController = TextEditingController();
  final websiteController = TextEditingController();

  @override
  dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    companyController.dispose();
    designationController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name ?? '';
    phoneController.text = widget.contact.mobile ?? '';
    emailController.text = widget.contact.email ?? '';
    addressController.text = widget.contact.address ?? '';
    companyController.text = widget.contact.company ?? '';
    designationController.text = widget.contact.designation ?? '';
    websiteController.text = widget.contact.website ?? '';
  }

  void saveContact() async {
    // Implement save contact logic here
    if (!_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In a real app,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check the contact info')),
      );
    }
    // update the contact model with the form data
    widget.contact.name = nameController.text;
    widget.contact.mobile = phoneController.text;
    widget.contact.email = emailController.text;
    widget.contact.address = addressController.text;
    widget.contact.company = companyController.text;
    widget.contact.designation = designationController.text;
    widget.contact.website = websiteController.text;
    widget.contact.isFavorite = false;
    // Navigator.pop(context, widget.contact);

    Provider.of<ContactProvider>(context, listen: false)
        .insertContact(widget.contact)
        .then(
          (value) => {
            if (value > 0)
              {
                if (mounted)
                  {
                    showMessage(context, 'Contact saved successfully'),
                    context.goNamed(HomePage.routeName),
                  },
              },
          },
        )
        .catchError((error) {
          if (mounted) {
            showMessage(context, 'Error saving contact: $error');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Contact")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            FormContactWidget(
              keyboardType: TextInputType.text,
              controller: nameController,
              labelText: 'Contact name',
              validationText: 'Please enter contact name',
              shouldValidate: true,
            ),
            FormContactWidget(
              controller: phoneController,
              labelText: 'Contact phone',
              validationText: 'Please enter contact phone',
              keyboardType: TextInputType.phone,
              shouldValidate: true,
            ),
            FormContactWidget(
              controller: emailController,
              labelText: 'Contact email',
              validationText: 'Please enter contact email',
              keyboardType: TextInputType.emailAddress,
            ),
            FormContactWidget(
              controller: addressController,
              labelText: 'Contact address',
              validationText: 'Please enter contact address',
              keyboardType: TextInputType.streetAddress,
            ),
            FormContactWidget(
              controller: companyController,
              labelText: 'Contact company',
              validationText: 'Please enter contact company',
              keyboardType: TextInputType.text,
            ),
            FormContactWidget(
              controller: designationController,
              labelText: 'Contact designation',
              validationText: 'Please enter contact designation',
              keyboardType: TextInputType.text,
            ),
            FormContactWidget(
              controller: websiteController,
              labelText: 'Contact website',
              validationText: 'Please enter contact website',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveContact,
              child: const Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
