// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:easy_order/app/screens/login/enter_mobile_number_page.dart'
    as _i1;
import 'package:easy_order/app/screens/login/enter_otp_page.dart' as _i2;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    EnterMobileNumberRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.EnterMobileNumberPage(),
      );
    },
    EnterOtpRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.EnterOtpPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.EnterMobileNumberPage]
class EnterMobileNumberRoute extends _i3.PageRouteInfo<void> {
  const EnterMobileNumberRoute({List<_i3.PageRouteInfo>? children})
      : super(
          EnterMobileNumberRoute.name,
          initialChildren: children,
        );

  static const String name = 'EnterMobileNumberRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

/// generated route for
/// [_i2.EnterOtpPage]
class EnterOtpRoute extends _i3.PageRouteInfo<void> {
  const EnterOtpRoute({List<_i3.PageRouteInfo>? children})
      : super(
          EnterOtpRoute.name,
          initialChildren: children,
        );

  static const String name = 'EnterOtpRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
