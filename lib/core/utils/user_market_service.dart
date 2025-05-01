class UserMarketService {
  UserMarketService._();

  static String? _userMarket;

  static String? get userMarket => _userMarket;

  static void setUserMarket(String id) => _userMarket = id;
}
