class LineModel {
  final String lineId;
  final String lineName;
  final String marketId;

  LineModel({
    required this.lineId,
    required this.lineName,
    required this.marketId,
  });

  factory LineModel.fromMap(Map<String, dynamic> data) {
    return LineModel(
      lineId: data['uid'] ?? '',
      lineName: data['name'] ?? '',
      marketId: data['marketId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': lineId,
      'name': lineName,
      'marketId': marketId,
    };
  }
}
