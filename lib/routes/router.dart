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
      page: EnterMobileNumberRoute.page,
      path: '/',
    ),
    AutoRoute(
      page: EnterOtpRoute.page,
      path: '/enter-otp',
    ),
  ];
}
