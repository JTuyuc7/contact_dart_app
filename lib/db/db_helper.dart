import 'package:path/path.dart' as P;
import 'package:sqflite/sqflite.dart';

import '../models/contact_model.dart';

class DBHelper {
  // Singleton pattern
  // DBHelper._privateConstructor();
  //
  // static final DBHelper instance = DBHelper._privateConstructor();

  // Database initialization and other methods would go here
  Future<Database> _open() async {
    final databasePath = await getDatabasesPath();
    final path = P.join(databasePath, 'contacts.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableContacts(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT,
            $columnMobile TEXT,
            $columnEmail TEXT,
            $columnAddress TEXT,
            $columnCompany TEXT,
            $columnDesignation TEXT,
            $columnWebsite TEXT,
            $columnImageContent TEXT,
            $columnIsFavorite INTEGER DEFAULT 0
          )
        ''');
      },
      // This only gets executed when the database version changes
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle database upgrades if needed
        if (oldVersion < newVersion) {
          // Example: Adding a new column
          // await db.execute('ALTER TABLE $tableContacts ADD COLUMN new_column TEXT');

          // renaming table example
          // await db.execute('ALTER TABLE $tableContacts RENAME TO ${tableContacts}_old ');

          // creating new table example
          // await db.execute('''
          //   CREATE TABLE $tableContacts(
          //     $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          //     $columnName TEXT,
          //     $columnMobile TEXT,
          //     $columnEmail TEXT,
          //     $columnAddress TEXT,
          //     $columnCompany TEXT,
          //     $columnDesignation TEXT,
          //     $columnWebsite TEXT,
          //     $columnImageContent TEXT,
          //     $columnIsFavorite INTEGER DEFAULT 0
          //   )
          // ''');

          // migrating data from old table to new table example
          // await db.execute('''
          //   INSERT INTO $tableContacts ($columnId, $columnName, $columnMobile, $columnEmail, $columnAddress, $columnCompany, $columnDesignation, $columnWebsite, $columnImageContent, $columnIsFavorite)
          //   SELECT $columnId, $columnName, $columnMobile, $columnEmail, $columnAddress, $columnCompany, $columnDesignation, $columnWebsite, $columnImageContent, $columnIsFavorite
          //   FROM ${tableContacts}_old
          // ''');

          // dropping old table example
          // await db.execute('DROP TABLE IF EXISTS ${tableContacts}_old');
        }
      },
    );
  }

  Future<int> insertContact(ContactModel contact) async {
    final db = await _open();
    return await db.insert(tableContacts, contact.toMap());
  }

  Future<List<ContactModel>> getContacts() async {
    final db = await _open();
    final contactsData = await db.query(tableContacts);
    return contactsData.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    final result = await db.delete(
      tableContacts,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> updateContact(int id, int value) async {
    final db = await _open();
    return await db.update(
      tableContacts,
      {columnIsFavorite: value},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<ContactModel>> getFavoriteContacts() async {
    final db = await _open();
    final contactsData = await db.query(
      tableContacts,
      where: '$columnIsFavorite = ?',
      whereArgs: [1],
    );
    return contactsData.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<ContactModel> getContactById(int id) async {
    final db = await _open();
    final contactsData = await db.query(
      tableContacts,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (contactsData.isNotEmpty) {
      return ContactModel.fromMap(contactsData.first);
    } else {
      throw Exception('Contact not found');
    }
  }
}
