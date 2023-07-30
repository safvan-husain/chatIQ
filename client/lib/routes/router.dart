import 'package:auto_route/auto_route.dart';

import '../default.dart';
import '../features/Authentication/presentation/pages/sign_in/form_login.dart';
import '../features/Authentication/presentation/pages/sign_in/google_sign_in.dart';
import '../features/Authentication/presentation/pages/sign_up/google_sign_up.dart';
import '../features/Authentication/presentation/pages/sign_up/google_sign_up_setup.dart';
import '../features/Authentication/presentation/pages/sign_up/sign_up_from.dart';
import '../features/call_history/presentation/pages/call_history_page.dart';
import '../features/chat/presentation/pages/chat_view.dart';
import '../features/home/presentation/pages/contacts/contacts.dart';
import '../features/home/presentation/pages/default/home_view.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/video_call/presentation/pages/video_call_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: GoogleSignInPage, initial: true),
    AutoRoute(page: LoginFormPage),
    AutoRoute(page: GoogleSignUpPage),
    AutoRoute(page: SignupFormPage),
    AutoRoute(page: GoogleSignUpSetupPage),
    AutoRoute(page: ChatPage),
    AutoRoute(page: ContactsPage),
    AutoRoute(page: ProfilePage),
    AutoRoute(page: VideoCallPage),
    AutoRoute(
      page: DefaultPage,
      path: '/',
      children: [
        AutoRoute(
          path: 'home',
          name: 'HomeRoute',
          page: HomePage,
        ),
        AutoRoute(
          path: 'call-history',
          name: 'CallHistoryRoute',
          page: CallHistoryPage,
        ),
        AutoRoute(
          path: 'settings',
          name: 'SettingsRoute',
          page: SettingsPage,
        ),
      ],
    ),
  ],
)
class $AppRouter {}

// flutter packages pub run build_runner build
