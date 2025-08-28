class UserModel {
  final String email;
  final String name;
  final String profilePic;
  final String uid;
  final bool isOnline;
  final String? phoneNumber;


  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.isOnline,
    required this.phoneNumber,
    required this.email
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'profilePic': this.profilePic,
      'uid': this.uid,
      'isOnline': this.isOnline,
      'phoneNumber': this.phoneNumber,
      'email': this.email

    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map,) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String?,
      email: map['email'] as String,
    );
  }
}
