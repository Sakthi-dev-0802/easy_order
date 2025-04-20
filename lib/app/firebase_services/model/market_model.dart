class MarketModel {
  final String marketId;
  final String name;
  final String location;

  MarketModel({
    required this.marketId,
    required this.name,
    required this.location,
  });

  factory MarketModel.fromMap(Map<String, dynamic> data) {
    return MarketModel(
      marketId: data['marketId'] ?? '',
      name: data['name'] ?? '',
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'marketId': marketId,
      'name': name,
      'location': location,
    };
  }
}
