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
  String dateofBirth;
  String specialSituation;
  final parentingStyle;
  final favorite;
  final nutritions;
  final interest;
  String fullName;

  UserModel({
    required this.uuid,
    required this.email,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
    required this.confrimPassword,
    required this.interest,
    required this.favorite,
    required this.location,
    required this.familyType,
    required this.specialSituation,
    required this.dateofBirth,
    required this.familyDescription,
    required this.parentingStyle,
    this.photo,
    required this.nutritions,
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
        'dateofBirth': dateofBirth,
        'familyType': familyType,
        'parentingStyle': parentingStyle,
        'specialSituation': specialSituation,
        'favorite': favorite,
        'nutritions': nutritions,
        'interest': interest,
        'fullName': fullName,
      };

  ///
  static UserModel fromSnap(DocumentSnapshot snaps) {
    var snapshot = snaps.data() as Map<String, dynamic>;

    return UserModel(
      photo: snapshot['photo'],
      email: snapshot['email'],
      uuid: snapshot['uuid'],
      password: snapshot['password'],
      confrimPassword: snapshot['confrimPassword'],
      phoneNumber: snapshot['phoneNumber'],
      location: snapshot['location'],
      familyDescription: snapshot['familyDescription'],
      dateofBirth: snapshot['dateofBirth'],
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
