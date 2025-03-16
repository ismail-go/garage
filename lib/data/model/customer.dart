class Customer {
  String name;
  String surname;
  String tcNo;
  String taxNo;
  String telNo;
  String address;
  double debit;

  Customer({
    required this.name,
    required this.surname,
    required this.tcNo,
    required this.taxNo,
    required this.telNo,
    required this.address,
    required this.debit,
  });

  // From JSON to Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      tcNo: json['tcNo'] ?? '',
      taxNo: json['taxNo'] ?? '',
      telNo: json['telNo'] ?? '',
      address: json['address'] ?? '',
      debit: json['debit'] ?? 0.0,
    );
  }

  // From Customer to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'tcNo': tcNo,
      'taxNo': taxNo,
      'telNo': telNo,
      'address': address,
      'debit': debit,
    };
  }
}
