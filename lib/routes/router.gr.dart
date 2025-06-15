// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:easy_order/app/firebase_services/model/client_model.dart'
    as _i15;
import 'package:easy_order/app/screens/clients/add_client_screen.dart' as _i1;
import 'package:easy_order/app/screens/clients/clients_list_screen.dart' as _i3;
import 'package:easy_order/app/screens/home/home_screen.dart' as _i4;
import 'package:easy_order/app/screens/landing/landing_screen.dart' as _i5;
import 'package:easy_order/app/screens/line/add_line_screen.dart' as _i2;
import 'package:easy_order/app/screens/line/line_screen.dart' as _i6;
import 'package:easy_order/app/screens/login/login_screen.dart' as _i7;
import 'package:easy_order/app/screens/login/register_screen.dart' as _i10;
import 'package:easy_order/app/screens/login/signup_screen.dart' as _i11;
import 'package:easy_order/app/screens/market_info/market_info_screen.dart'
    as _i8;
import 'package:easy_order/app/screens/orders/order_taking_screen.dart' as _i9;
import 'package:easy_order/app/screens/splash/splash_screen.dart' as _i12;
import 'package:flutter/material.dart' as _i14;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    AddClientRoute.name: (routeData) {
      final args = routeData.argsAs<AddClientRouteArgs>(
          orElse: () => const AddClientRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddClientPage(
          key: args.key,
          lineId: args.lineId,
        ),
      );
    },
    AddLineRoute.name: (routeData) {
      final args = routeData.argsAs<AddLineRouteArgs>(
          orElse: () => const AddLineRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AddLinePage(
          key: args.key,
          lineId: args.lineId,
          lineName: args.lineName,
        ),
      );
    },
    ClientsListRoute.name: (routeData) {
      final args = routeData.argsAs<ClientsListRouteArgs>(
          orElse: () => const ClientsListRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ClientsListPage(
          key: args.key,
          lineId: args.lineId,
          lineName: args.lineName,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    LandingRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LandingPage(),
      );
    },
    LineRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LinePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginPage(),
      );
    },
    MarketInfoRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MarketInfoPage(),
      );
    },
    OrderTakingRoute.name: (routeData) {
      final args = routeData.argsAs<OrderTakingRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.OrderTakingPage(
          key: args.key,
          client: args.client,
        ),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.RegisterPage(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SignupPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SplashPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddClientPage]
class AddClientRoute extends _i13.PageRouteInfo<AddClientRouteArgs> {
  AddClientRoute({
    _i14.Key? key,
    String? lineId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          AddClientRoute.name,
          args: AddClientRouteArgs(
            key: key,
            lineId: lineId,
          ),
          initialChildren: children,
        );

  static const String name = 'AddClientRoute';

  static const _i13.PageInfo<AddClientRouteArgs> page =
      _i13.PageInfo<AddClientRouteArgs>(name);
}

class AddClientRouteArgs {
  const AddClientRouteArgs({
    this.key,
    this.lineId,
  });

  final _i14.Key? key;

  final String? lineId;

  @override
  String toString() {
    return 'AddClientRouteArgs{key: $key, lineId: $lineId}';
  }
}

/// generated route for
/// [_i2.AddLinePage]
class AddLineRoute extends _i13.PageRouteInfo<AddLineRouteArgs> {
  AddLineRoute({
    _i14.Key? key,
    String? lineId,
    String? lineName,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          AddLineRoute.name,
          args: AddLineRouteArgs(
            key: key,
            lineId: lineId,
            lineName: lineName,
          ),
          initialChildren: children,
        );

  static const String name = 'AddLineRoute';

  static const _i13.PageInfo<AddLineRouteArgs> page =
      _i13.PageInfo<AddLineRouteArgs>(name);
}

class AddLineRouteArgs {
  const AddLineRouteArgs({
    this.key,
    this.lineId,
    this.lineName,
  });

  final _i14.Key? key;

  final String? lineId;

  final String? lineName;

  @override
  String toString() {
    return 'AddLineRouteArgs{key: $key, lineId: $lineId, lineName: $lineName}';
  }
}

/// generated route for
/// [_i3.ClientsListPage]
class ClientsListRoute extends _i13.PageRouteInfo<ClientsListRouteArgs> {
  ClientsListRoute({
    _i14.Key? key,
    String? lineId,
    String? lineName,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ClientsListRoute.name,
          args: ClientsListRouteArgs(
            key: key,
            lineId: lineId,
            lineName: lineName,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientsListRoute';

  static const _i13.PageInfo<ClientsListRouteArgs> page =
      _i13.PageInfo<ClientsListRouteArgs>(name);
}

class ClientsListRouteArgs {
  const ClientsListRouteArgs({
    this.key,
    this.lineId,
    this.lineName,
  });

  final _i14.Key? key;

  final String? lineId;

  final String? lineName;

  @override
  String toString() {
    return 'ClientsListRouteArgs{key: $key, lineId: $lineId, lineName: $lineName}';
  }
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LandingPage]
class LandingRoute extends _i13.PageRouteInfo<void> {
  const LandingRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LandingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LandingRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LinePage]
class LineRoute extends _i13.PageRouteInfo<void> {
  const LineRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LineRoute.name,
          initialChildren: children,
        );

  static const String name = 'LineRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoginPage]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MarketInfoPage]
class MarketInfoRoute extends _i13.PageRouteInfo<void> {
  const MarketInfoRoute({List<_i13.PageRouteInfo>? children})
      : super(
          MarketInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketInfoRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i9.OrderTakingPage]
class OrderTakingRoute extends _i13.PageRouteInfo<OrderTakingRouteArgs> {
  OrderTakingRoute({
    _i14.Key? key,
    required _i15.ClientModel client,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          OrderTakingRoute.name,
          args: OrderTakingRouteArgs(
            key: key,
            client: client,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderTakingRoute';

  static const _i13.PageInfo<OrderTakingRouteArgs> page =
      _i13.PageInfo<OrderTakingRouteArgs>(name);
}

class OrderTakingRouteArgs {
  const OrderTakingRouteArgs({
    this.key,
    required this.client,
  });

  final _i14.Key? key;

  final _i15.ClientModel client;

  @override
  String toString() {
    return 'OrderTakingRouteArgs{key: $key, client: $client}';
  }
}

/// generated route for
/// [_i10.RegisterPage]
class RegisterRoute extends _i13.PageRouteInfo<void> {
  const RegisterRoute({List<_i13.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SignupPage]
class SignupRoute extends _i13.PageRouteInfo<void> {
  const SignupRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SplashPage]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}
