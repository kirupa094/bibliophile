class SignUpModel {
  final String id;
  final String email;
  final String photoURL;
  final String uid;

  SignUpModel.fromParsedJason(Map<String, dynamic> result)
      : id = result['_id'] ?? '',
        email = result['email'] ?? '',
        photoURL = result['photoURL'] ?? '',
        uid = result['uid'] ?? '';
}