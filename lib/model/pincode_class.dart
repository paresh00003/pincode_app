class PincodeDetails {
  final String name;
  final String description;
  final String branchType;
  final String deliveryStatus;
  final String circle;
  final String district;
  final String division;
  final String region;
  final String block;
  final String state;
  final String country;
  final int pincode;

  PincodeDetails({
    required this.name,
    required this.description,
    required this.branchType,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory PincodeDetails.fromJson(Map<String, dynamic> json) {
    print('Converting JSON to PincodeDetails: $json');
    try {
      return PincodeDetails(
        name: json['Name'] ?? '',
        description: json['Description'] ?? '',
        branchType: json['BranchType'] ?? '',
        deliveryStatus: json['DeliveryStatus'] ?? '',
        circle: json['Circle'] ?? '',
        district: json['District'] ?? '',
        division: json['Division'] ?? '',
        region: json['Region'] ?? '',
        block: json['Block'] ?? '',
        state: json['State'] ?? '',
        country: json['Country'] ?? '',
        pincode: int.tryParse(json['Pincode'].toString()) ?? 0,
      );
    } catch (e) {
      print('Error converting JSON to PincodeDetails: $e');
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Description': description,
      'BranchType': branchType,
      'DeliveryStatus': deliveryStatus,
      'Circle': circle,
      'District': district,
      'Division': division,
      'Region': region,
      'Block': block,
      'State': state,
      'Country': country,
      'Pincode': pincode,
    };
  }
}
