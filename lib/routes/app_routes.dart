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
  static get addLinePage => const AddLineRoute();

  //Clients List Route
  static get clientsListPage => const ClientsListRoute();

  //Add Client Route
  static get addClientPage => const AddClientRoute();
}
