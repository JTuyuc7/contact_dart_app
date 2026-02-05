class ContactModel {
  int? id;
  String name;
  String mobile;
  String? email;
  String? address;
  String? company;
  String? designation;
  String? website;
  String? imageContent;
  bool? isFavorite;

  ContactModel({
    required this.name,
    required this.mobile,
    this.id = -1,
    this.email = '',
    this.address = '',
    this.company = '',
    this.designation = '',
    this.website = '',
    this.imageContent = '',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnMobile: mobile,
      columnEmail: email,
      columnAddress: address,
      columnCompany: company,
      columnDesignation: designation,
      columnWebsite: website,
      columnImageContent: imageContent,
      columnIsFavorite: isFavorite == true ? 1 : 0,
    };
    if (id != null && id != -1) {
      map[columnId] = id;
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map[columnId],
      name: map[columnName],
      mobile: map[columnMobile],
      email: map[columnEmail],
      address: map[columnAddress],
      company: map[columnCompany],
      designation: map[columnDesignation],
      website: map[columnWebsite],
      imageContent: map[columnImageContent],
      isFavorite: map[columnIsFavorite] == 1,
    );
  }

  // factory ContactModel.fromJson(Map<String, dynamic> json) {
  //   return ContactModel(
  //     id: json['id'],
  //     name: json['name'],
  //     email: json['email'],
  //     mobile: json['mobile'],
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'email': email,
  //     'mobile': mobile,
  //   };
  // }
}

const String tableContacts = 'tbl_contacts';
const String columnId = 'id';
const String columnName = 'name';
const String columnMobile = 'mobile';
const String columnEmail = 'email';
const String columnAddress = 'address';
const String columnCompany = 'company';
const String columnDesignation = 'designation';
const String columnWebsite = 'website';
const String columnImageContent = 'image_content';
const String columnIsFavorite = 'is_favorite';
