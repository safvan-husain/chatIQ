import 'package:auto_route/auto_route.dart';
import 'package:client/pages/chat/chat_view.dart';
import 'package:client/pages/home/home_view.dart';

import '../pages/sign_in/google_sign_in.dart';
import '../pages/sign_up/google_sign_up.dart';
import '../pages/profile/avatar/avatar.dart';
import '../pages/profile/profile_view.dart';
import '../pages/settings/settings_view.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage),
    AutoRoute(page: HoemPage),
    AutoRoute(page: ChatPage),
    AutoRoute(page: SettingsPage),
    AutoRoute(page: ProfilePage),
    AutoRoute(page: GoogleSignUpPage),
    AutoRoute(page: GoogleSignInPage, initial: true),
  ],
)
class $AppRouter {}


// flutter packages pub run build_runner build