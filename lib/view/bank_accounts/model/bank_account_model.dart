class BankAccount {
  int accountId;
  String? accountHolderName; // Optional field
  String bankName;
  String accountNumber;
  String ifscCode;
  bool isPrimary;
  String createdAt;
  String updatedAt;

  BankAccount({
    required this.accountId,
    this.accountHolderName,
    required this.bankName,
    required this.isPrimary,
    required this.accountNumber,
    required this.ifscCode,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a BankAccount object from JSON
  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountId: json['account_id'],
      accountHolderName: json['account_holder_name'],
      isPrimary: (json['is_primary'] == 1) ? true : false,
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method to convert a BankAccount object to JSON
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'is_primary': isPrimary,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  BankAccount copyWith({
    int? accountId,
    int? userId,
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    bool? isPrimary,
    String? createdAt,
    String? updatedAt,
  }) {
    return BankAccount(
      accountId: accountId ?? this.accountId,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
