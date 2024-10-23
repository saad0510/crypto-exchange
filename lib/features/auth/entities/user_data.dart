import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserData {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String picUrl;

  const UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.picUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'picUrl': picUrl,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      picUrl: map['picUrl'] as String,
    );
  }

  factory UserData.fromGoogleUser(firebase.User user) {
    return UserData(
      uid: user.uid,
      email: user.email!,
      name: user.displayName!,
      phone: user.phoneNumber ?? '',
      picUrl: user.photoURL ?? '',
    );
  }

  UserData copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? picUrl,
    bool? isVerified,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      picUrl: picUrl ?? this.picUrl,
    );
  }
}
