import 'package:auto_route/auto_route.dart';
import 'package:easy_order/routes/router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      page: SplashRoute.page,
      path: '/',
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: SignupRoute.page,
      path: '/signup',
    ),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
    ),
    AutoRoute(
      page: LineRoute.page,
      path: '/line',
    ),
    AutoRoute(
      page: MarketInfoRoute.page,
      path: '/marketinfo',
    ),
    AutoRoute(
      page: LandingRoute.page,
      path: '/landing',
    ),
    AutoRoute(
      page: AddLineRoute.page,
      path: '/addline',
    ),
    AutoRoute(
      page: ClientsListRoute.page,
      path: '/clients',
    ),
    AutoRoute(
      page: AddClientRoute.page,
      path: '/addclient',
    ),
    AutoRoute(
      page: OrderTakingRoute.page,
      path: '/ordertaking',
    ),
    AutoRoute(
      page: LoadLinesRoute.page,
      path: '/loadlines',
    ),
    AutoRoute(
      page: LoadReportRoute.page,
      path: '/loadreport',
    ),
  ];
}
