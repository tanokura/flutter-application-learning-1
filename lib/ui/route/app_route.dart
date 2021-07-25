import 'package:flutter_application_1/ui/list/list_page.dart';
import 'package:flutter_application_1/ui/list/favorite_list_page.dart';
import 'package:flutter_application_1/ui/guide/map_guide_page.dart';
import 'package:auto_route/auto_route.dart';

export 'app_route.gr.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: ListPage,
      initial: true,
      children: <AutoRoute>[
        AutoRoute(
          path: 'favorit',
          page: FavoriteListPage,
        ),
      ],
    ),
    AutoRoute(
      path: 'guide',
      page: MapGuidePage,
    ),
  ],
)
class $AppRouter {}
