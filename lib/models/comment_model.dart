
class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;
  final String uid;
  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profilePic,
    required this.uid,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
    String? uid,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'uid': uid,
    };
  }


  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic, uid: $uid)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.text == text &&
      other.createdAt == createdAt &&
      other.postId == postId &&
      other.username == username &&
      other.profilePic == profilePic &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      text.hashCode ^
      createdAt.hashCode ^
      postId.hashCode ^
      username.hashCode ^
      profilePic.hashCode ^
      uid.hashCode;
  }

}
