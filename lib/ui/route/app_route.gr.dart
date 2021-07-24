// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:english_words/english_words.dart' as _i5;
import 'package:flutter/material.dart' as _i2;
import 'package:flutter_application_1/ui/list/favorite_list_page.dart' as _i4;
import 'package:flutter_application_1/ui/list/list_page.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    ListRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.ListPage();
        }),
    FavoriteListRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<FavoriteListRouteArgs>();
          return _i4.FavoriteListPage(savedPair: args.savedPair);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(ListRoute.name, path: '/', children: [
          _i1.RouteConfig(FavoriteListRoute.name, path: 'favoritList')
        ])
      ];
}

class ListRoute extends _i1.PageRouteInfo {
  const ListRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'ListRoute';
}

class FavoriteListRoute extends _i1.PageRouteInfo<FavoriteListRouteArgs> {
  FavoriteListRoute({required Set<_i5.WordPair> savedPair})
      : super(name,
            path: 'favoritList',
            args: FavoriteListRouteArgs(savedPair: savedPair));

  static const String name = 'FavoriteListRoute';
}

class FavoriteListRouteArgs {
  const FavoriteListRouteArgs({required this.savedPair});

  final Set<_i5.WordPair> savedPair;
}
