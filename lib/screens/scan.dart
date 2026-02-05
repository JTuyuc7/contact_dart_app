import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/Line_widget.dart';
import '../widgets/drop_target_item.dart';
import 'form_page.dart';

class ScanScreen extends StatefulWidget {
  static const routeName = 'scan';

  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanOver = false;
  List<String> lines = [];
  String name = '',
      phone = '',
      email = '',
      address = '',
      company = '',
      designation = '',
      website = '',
      image_content = '';

  void getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    if (image != null) {
      // Process the selected image
      EasyLoading.show(status: 'Processing Image...');
      final recognizedImageText = await textRecognizer.processImage(
        InputImage.fromFilePath(image.path),
      );
      EasyLoading.dismiss();

      final tempList = <String>[];
      for (final block in recognizedImageText.blocks) {
        for (final line in block.lines) {
          tempList.add(line.text);
        }
      }

      setState(() {
        _isScanOver = true;
        lines = tempList;
        image_content = image.path;
      });
    } else {
      print('No image selected.');
    }
  }

  getPropertyValue(String property, String value) {
    setState(() {
      switch (property) {
        case ContactProperties.name:
          name = value;
          break;
        case ContactProperties.phone:
          phone = value;
          break;
        case ContactProperties.email:
          email = value;
          break;
        case ContactProperties.address:
          address = value;
          break;
        case ContactProperties.company:
          company = value;
          break;
        case ContactProperties.designation:
          designation = value;
          break;
        case ContactProperties.website:
          website = value;
          break;
        default:
          break;
      }
    });
  }

  void createContact() {
    ContactModel contact = ContactModel(
      name: name,
      mobile: phone,
      email: email,
      address: address,
      company: company,
      designation: designation,
      website: website,
      imageContent: image_content,
      isFavorite: false,
    );

    if (contact.name.isEmpty || contact.mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Phone are required fields')),
      );
      return;
    }

    // Navigator.pushNamed(context, 'form', arguments: contact);
    context.goNamed(FormPage.routeName, extra: contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: image_content.isEmpty ? null : createContact,
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Action when button is pressed
                  getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Capture'),
              ),
              TextButton.icon(
                onPressed: () {
                  // Action when button is pressed
                  getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.album),
                label: const Text('Gallery'),
              ),
            ],
          ),
          if (_isScanOver)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropTargetItem(
                      property: ContactProperties.name,
                      onDrop: getPropertyValue,
                    ),
                    DropTargetItem(
                      property: ContactProperties.phone,
                      onDrop: getPropertyValue,
                    ),
                    DropTargetItem(
                      property: ContactProperties.email,
                      onDrop: getPropertyValue,
                    ),
                    DropTargetItem(
                      property: ContactProperties.address,
                      onDrop: getPropertyValue,
                    ),
                    DropTargetItem(
                      property: ContactProperties.company,
                      onDrop: getPropertyValue,
                    ),
                    DropTargetItem(
                      property: ContactProperties.designation,
                      onDrop: getPropertyValue,
                    ),
                    DropTargetItem(
                      property: ContactProperties.website,
                      onDrop: getPropertyValue,
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Text(hint),
          ),
          Wrap(children: lines.map((e) => LineItem(line: e)).toList()),
        ],
      ),
    );
  }
}
