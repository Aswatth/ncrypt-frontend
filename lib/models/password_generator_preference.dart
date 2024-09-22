class PasswordGeneratorPreference {
  bool hasDigits = false;
  bool hasUpperCase = false;
  bool hasSpecialChar = false;
  int length = 8;

  PasswordGeneratorPreference.defaultSetup();
  
  PasswordGeneratorPreference(
      {required this.hasDigits,
      required this.hasUpperCase,
      required this.hasSpecialChar,
      required this.length});

  factory PasswordGeneratorPreference.fromJson(Map<String, dynamic> json) {
    return PasswordGeneratorPreference(
        hasDigits: json['has_digits'],
        hasUpperCase: json['has_uppercase'],
        hasSpecialChar: json['has_special_char'],
        length: json['length']);
  }

  Map<String, dynamic> toJson() => {
        'has_digits': hasSpecialChar,
        'has_uppercase': hasUpperCase,
        'has_special_char': hasSpecialChar,
        'length': length,
      };
}
