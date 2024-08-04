class Attributes {
  late bool isFavourite;
  late bool requireMasterPassword;

  Attributes({required this.isFavourite, required this.requireMasterPassword});

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
        isFavourite: json['isFavourite'],
        requireMasterPassword: json['requireMasterPassword']);
  }

  Map<String, dynamic> toJson() => {
        'isFavourite': isFavourite,
        'requireMasterPassword': requireMasterPassword,
      };
}
