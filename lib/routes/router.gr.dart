// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:easy_order/app/firebase_services/model/client_model.dart'
    as _i20;
import 'package:easy_order/app/firebase_services/model/items_model.dart'
    as _i19;
import 'package:easy_order/app/screens/clients/add_client_screen.dart' as _i1;
import 'package:easy_order/app/screens/clients/clients_list_screen.dart' as _i4;
import 'package:easy_order/app/screens/home/home_screen.dart' as _i5;
import 'package:easy_order/app/screens/items/add_item_screen.dart' as _i2;
import 'package:easy_order/app/screens/items/items_list_screen.dart' as _i6;
import 'package:easy_order/app/screens/landing/landing_screen.dart' as _i7;
import 'package:easy_order/app/screens/line/add_line_screen.dart' as _i3;
import 'package:easy_order/app/screens/line/line_screen.dart' as _i8;
import 'package:easy_order/app/screens/load_report/load_lines_list_screen.dart'
    as _i9;
import 'package:easy_order/app/screens/load_report/load_report_screen.dart'
    as _i10;
import 'package:easy_order/app/screens/login/login_screen.dart' as _i11;
import 'package:easy_order/app/screens/login/register_screen.dart' as _i14;
import 'package:easy_order/app/screens/login/signup_screen.dart' as _i15;
import 'package:easy_order/app/screens/market_info/market_info_screen.dart'
    as _i12;
import 'package:easy_order/app/screens/orders/order_taking_screen.dart' as _i13;
import 'package:easy_order/app/screens/splash/splash_screen.dart' as _i16;
import 'package:flutter/material.dart' as _i18;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    AddClientRoute.name: (routeData) {
      final args = routeData.argsAs<AddClientRouteArgs>(
          orElse: () => const AddClientRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddClientPage(
          key: args.key,
          lineId: args.lineId,
        ),
      );
    },
    AddItemRoute.name: (routeData) {
      final args = routeData.argsAs<AddItemRouteArgs>(
          orElse: () => const AddItemRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AddItemPage(
          key: args.key,
          item: args.item,
        ),
      );
    },
    AddLineRoute.name: (routeData) {
      final args = routeData.argsAs<AddLineRouteArgs>(
          orElse: () => const AddLineRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.AddLinePage(
          key: args.key,
          lineId: args.lineId,
          lineName: args.lineName,
        ),
      );
    },
    ClientsListRoute.name: (routeData) {
      final args = routeData.argsAs<ClientsListRouteArgs>(
          orElse: () => const ClientsListRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ClientsListPage(
          key: args.key,
          lineId: args.lineId,
          lineName: args.lineName,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomePage(),
      );
    },
    ItemsListRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ItemsListPage(),
      );
    },
    LandingRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LandingPage(),
      );
    },
    LineRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.LinePage(),
      );
    },
    LoadLinesRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.LoadLinesPage(),
      );
    },
    LoadReportRoute.name: (routeData) {
      final args = routeData.argsAs<LoadReportRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.LoadReportPage(
          key: args.key,
          lineId: args.lineId,
          lineName: args.lineName,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.LoginPage(),
      );
    },
    MarketInfoRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.MarketInfoPage(),
      );
    },
    OrderTakingRoute.name: (routeData) {
      final args = routeData.argsAs<OrderTakingRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.OrderTakingPage(
          key: args.key,
          client: args.client,
        ),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.RegisterPage(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.SignupPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.SplashPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddClientPage]
class AddClientRoute extends _i17.PageRouteInfo<AddClientRouteArgs> {
  AddClientRoute({
    _i18.Key? key,
    String? lineId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          AddClientRoute.name,
          args: AddClientRouteArgs(
            key: key,
            lineId: lineId,
          ),
          initialChildren: children,
        );

  static const String name = 'AddClientRoute';

  static const _i17.PageInfo<AddClientRouteArgs> page =
      _i17.PageInfo<AddClientRouteArgs>(name);
}

class AddClientRouteArgs {
  const AddClientRouteArgs({
    this.key,
    this.lineId,
  });

  final _i18.Key? key;

  final String? lineId;

  @override
  String toString() {
    return 'AddClientRouteArgs{key: $key, lineId: $lineId}';
  }
}

/// generated route for
/// [_i2.AddItemPage]
class AddItemRoute extends _i17.PageRouteInfo<AddItemRouteArgs> {
  AddItemRoute({
    _i18.Key? key,
    _i19.ItemsModel? item,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          AddItemRoute.name,
          args: AddItemRouteArgs(
            key: key,
            item: item,
          ),
          initialChildren: children,
        );

  static const String name = 'AddItemRoute';

  static const _i17.PageInfo<AddItemRouteArgs> page =
      _i17.PageInfo<AddItemRouteArgs>(name);
}

class AddItemRouteArgs {
  const AddItemRouteArgs({
    this.key,
    this.item,
  });

  final _i18.Key? key;

  final _i19.ItemsModel? item;

  @override
  String toString() {
    return 'AddItemRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i3.AddLinePage]
class AddLineRoute extends _i17.PageRouteInfo<AddLineRouteArgs> {
  AddLineRoute({
    _i18.Key? key,
    String? lineId,
    String? lineName,
    List<_i17.PageRouteInfo>? children,
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

  static const _i17.PageInfo<AddLineRouteArgs> page =
      _i17.PageInfo<AddLineRouteArgs>(name);
}

class AddLineRouteArgs {
  const AddLineRouteArgs({
    this.key,
    this.lineId,
    this.lineName,
  });

  final _i18.Key? key;

  final String? lineId;

  final String? lineName;

  @override
  String toString() {
    return 'AddLineRouteArgs{key: $key, lineId: $lineId, lineName: $lineName}';
  }
}

/// generated route for
/// [_i4.ClientsListPage]
class ClientsListRoute extends _i17.PageRouteInfo<ClientsListRouteArgs> {
  ClientsListRoute({
    _i18.Key? key,
    String? lineId,
    String? lineName,
    List<_i17.PageRouteInfo>? children,
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

  static const _i17.PageInfo<ClientsListRouteArgs> page =
      _i17.PageInfo<ClientsListRouteArgs>(name);
}

class ClientsListRouteArgs {
  const ClientsListRouteArgs({
    this.key,
    this.lineId,
    this.lineName,
  });

  final _i18.Key? key;

  final String? lineId;

  final String? lineName;

  @override
  String toString() {
    return 'ClientsListRouteArgs{key: $key, lineId: $lineId, lineName: $lineName}';
  }
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ItemsListPage]
class ItemsListRoute extends _i17.PageRouteInfo<void> {
  const ItemsListRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ItemsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ItemsListRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LandingPage]
class LandingRoute extends _i17.PageRouteInfo<void> {
  const LandingRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LandingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LandingRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LinePage]
class LineRoute extends _i17.PageRouteInfo<void> {
  const LineRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LineRoute.name,
          initialChildren: children,
        );

  static const String name = 'LineRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i9.LoadLinesPage]
class LoadLinesRoute extends _i17.PageRouteInfo<void> {
  const LoadLinesRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoadLinesRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadLinesRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.LoadReportPage]
class LoadReportRoute extends _i17.PageRouteInfo<LoadReportRouteArgs> {
  LoadReportRoute({
    _i18.Key? key,
    required String lineId,
    required String lineName,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          LoadReportRoute.name,
          args: LoadReportRouteArgs(
            key: key,
            lineId: lineId,
            lineName: lineName,
          ),
          initialChildren: children,
        );

  static const String name = 'LoadReportRoute';

  static const _i17.PageInfo<LoadReportRouteArgs> page =
      _i17.PageInfo<LoadReportRouteArgs>(name);
}

class LoadReportRouteArgs {
  const LoadReportRouteArgs({
    this.key,
    required this.lineId,
    required this.lineName,
  });

  final _i18.Key? key;

  final String lineId;

  final String lineName;

  @override
  String toString() {
    return 'LoadReportRouteArgs{key: $key, lineId: $lineId, lineName: $lineName}';
  }
}

/// generated route for
/// [_i11.LoginPage]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.MarketInfoPage]
class MarketInfoRoute extends _i17.PageRouteInfo<void> {
  const MarketInfoRoute({List<_i17.PageRouteInfo>? children})
      : super(
          MarketInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketInfoRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i13.OrderTakingPage]
class OrderTakingRoute extends _i17.PageRouteInfo<OrderTakingRouteArgs> {
  OrderTakingRoute({
    _i18.Key? key,
    required _i20.ClientModel client,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          OrderTakingRoute.name,
          args: OrderTakingRouteArgs(
            key: key,
            client: client,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderTakingRoute';

  static const _i17.PageInfo<OrderTakingRouteArgs> page =
      _i17.PageInfo<OrderTakingRouteArgs>(name);
}

class OrderTakingRouteArgs {
  const OrderTakingRouteArgs({
    this.key,
    required this.client,
  });

  final _i18.Key? key;

  final _i20.ClientModel client;

  @override
  String toString() {
    return 'OrderTakingRouteArgs{key: $key, client: $client}';
  }
}

/// generated route for
/// [_i14.RegisterPage]
class RegisterRoute extends _i17.PageRouteInfo<void> {
  const RegisterRoute({List<_i17.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i15.SignupPage]
class SignupRoute extends _i17.PageRouteInfo<void> {
  const SignupRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SplashPage]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}
