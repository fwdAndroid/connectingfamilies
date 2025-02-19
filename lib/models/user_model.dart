import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? photo;
  String email;
  String uuid;
  String password;
  String confrimPassword;
  String phoneNumber;
  String location;
  String familyDescription;
  String familyType;
  String specialSituation;
  final parentingStyle;
  final favorite;
  final nutritions;
  final interest;
  String fullName;
  var familyMembers;
  List<String> blocked;

  UserModel({
    required this.uuid,
    required this.email,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
    required this.confrimPassword,
    required this.interest,
    required this.favorite,
    required this.familyMembers,
    required this.location,
    required this.familyType,
    required this.specialSituation,
    required this.familyDescription,
    required this.parentingStyle,
    this.photo,
    required this.nutritions,
    required this.blocked,
  });

  ///Converting OBject into Json Object
  Map<String, dynamic> toJson() => {
        'photo': photo,
        'email': email,
        'uuid': uuid,
        'password': password,
        'confrimPassword': confrimPassword,
        'phoneNumber': phoneNumber,
        'location': location,
        'familyDescription': familyDescription,
        'familyType': familyType,
        'parentingStyle': parentingStyle,
        'specialSituation': specialSituation,
        'favorite': favorite,
        'nutritions': nutritions,
        'familyMembers': familyMembers,
        'interest': interest,
        'blocked': blocked,
        'fullName': fullName,
      };

  ///
  static UserModel fromSnap(DocumentSnapshot snaps) {
    var snapshot = snaps.data() as Map<String, dynamic>;

    return UserModel(
      photo: snapshot['photo'],
      familyMembers: snapshot['familyMembers'],
      email: snapshot['email'],
      uuid: snapshot['uuid'],
      password: snapshot['password'],
      confrimPassword: snapshot['confrimPassword'],
      phoneNumber: snapshot['phoneNumber'],
      location: snapshot['location'],
      blocked: snapshot['blocked'],
      familyDescription: snapshot['familyDescription'],
      specialSituation: snapshot['specialSituation'],
      parentingStyle: snapshot['parentingStyle'],
      familyType: snapshot['familyType'],
      favorite: snapshot['favorite'],
      nutritions: snapshot['nutritions'],
      interest: snapshot['interest'],
      fullName: snapshot['fullName'],
    );
  }
}
