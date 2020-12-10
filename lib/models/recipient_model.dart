class RecipientModel {
  RecipientModel({
    this.recipientDataList,
  });

  List<RecipientDataModel> recipientDataList;

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<RecipientDataModel> recipientDataModel =
        list.map((i) => RecipientDataModel.fromJson(i)).toList();

    return RecipientModel(
      recipientDataList: recipientDataModel,
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(recipientDataList.map((x) => x.toJson())),
      };
}

class RecipientDataModel {
  RecipientDataModel({
    this.id,
    this.userId,
    this.email,
    this.shouldEncrypt,
    this.fingerprint,
    this.emailVerifiedAt,
    this.aliases,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String userId;
  String email;
  bool shouldEncrypt;
  dynamic fingerprint;
  DateTime emailVerifiedAt;
  List<dynamic> aliases;
  DateTime createdAt;
  DateTime updatedAt;

  factory RecipientDataModel.fromJson(Map<String, dynamic> json) =>
      RecipientDataModel(
        id: json["id"],
        userId: json["user_id"],
        email: json["email"],
        shouldEncrypt: json["should_encrypt"],
        fingerprint: json["fingerprint"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        aliases: List<dynamic>.from(json["aliases"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "email": email,
        "should_encrypt": shouldEncrypt,
        "fingerprint": fingerprint,
        "email_verified_at":
            emailVerifiedAt == null ? null : emailVerifiedAt.toIso8601String(),
        "aliases": List<dynamic>.from(aliases.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}