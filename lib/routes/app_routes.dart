import 'package:easy_order/app/firebase_services/model/client_model.dart';
import 'package:easy_order/routes/router.gr.dart';

class AppRoutes {
  //Splash Route
  static get splashPage => const SplashRoute();

  //Login Route
  static get loginPage => const LoginRoute();

  //Signup Route
  static get signupPage => const SignupRoute();

  //Register Route
  static get registerPage => const RegisterRoute();

  //Home Route
  static get homePage => const HomeRoute();

  //Line Route
  static get linepage => const LineRoute();

  //MarketInfo Route
  static get marketinfo => const MarketInfoRoute();

  //Landing Route
  static get landing => const LandingRoute();

  //Add Line Route
  static addLinePage({String? lineId, String? lineName}) =>
      AddLineRoute(lineId: lineId, lineName: lineName);

  //Clients List Route
  static clientsListPage(String lineId, String lineName) =>
      ClientsListRoute(lineId: lineId, lineName: lineName);

  //Add Client Route
  static addClientPage({String? lineId}) => AddClientRoute(lineId: lineId);

  //Order Taking Route
  static orderTakingPage(ClientModel client) =>
      OrderTakingRoute(client: client);

  //Load Lines Route
  static get loadLinesPage => const LoadLinesRoute();

  //Load Report Route
  static loadReportPage(String lineId, String lineName) =>
      LoadReportRoute(lineId: lineId, lineName: lineName);
}
