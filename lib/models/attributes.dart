class Attributes {
  late bool isFavourite;
  late bool requireMasterPassword;

  Attributes({required this.isFavourite, required this.requireMasterPassword});

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
        isFavourite: json['is_favourite'],
        requireMasterPassword: json['require_master_password']);
  }

  Map<String, dynamic> toJson() => {
        'is_favourite': isFavourite,
        'require_master_password': requireMasterPassword,
      };
}
