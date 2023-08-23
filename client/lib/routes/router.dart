import 'package:auto_route/auto_route.dart';

import '../features/Authentication/presentation/pages/google_sign_in.dart';
import '../features/Authentication/presentation/pages/google_sign_up.dart';
import '../features/Authentication/presentation/pages/initial_screen.dart';
import '../features/chat/presentation/pages/chat_view.dart';
import '../features/home/presentation/pages/contacts/contacts.dart';
import '../features/home/presentation/pages/default/home_view.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/video_call/presentation/pages/video_call_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: InitialPage, initial: true),
    AutoRoute(page: GoogleSignInPage),
    AutoRoute(page: GoogleSignUpPage),
    AutoRoute(page: ChatPage),
    AutoRoute(page: ContactsPage),
    AutoRoute(page: ProfilePage),
    AutoRoute(page: VideoCallPage),
    AutoRoute(page: HomePage),
    AutoRoute(page: SettingsPage),
  ],
)
class $AppRouter {}

// dart run build_runner build
