
class ChatUser {

  late String image;
  late String name;
  late String id;
  late String lastActive;
  late String createAt;


  late String pushToken;
  late String email;

  ChatUser({
    required this.image,
    required this.name,

    required this.id,

    required this.lastActive,
    required this.createAt,
    required this.pushToken,
    required this.email,
  });

  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '' ;
    name = json['name'] ?? '';
    id = json['id'] ?? '';

    lastActive = json['last_active'] ?? '';
    createAt = json['create_at'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;

    data['last_active'] = lastActive;
    data['create_at'] = createAt;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
