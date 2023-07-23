import 'package:auto_route/auto_route.dart';

import '../features/Authentication/presentation/pages/sign_in/form_login.dart';
import '../features/Authentication/presentation/pages/sign_in/google_sign_in.dart';
import '../features/Authentication/presentation/pages/sign_up/google_sign_up.dart';
import '../features/Authentication/presentation/pages/sign_up/google_sign_up_setup.dart';
import '../features/Authentication/presentation/pages/sign_up/sign_up_from.dart';
import '../features/chat/presentation/pages/chat_view.dart';
import '../features/home/presentation/pages/contacts/contacts.dart';
import '../features/home/presentation/pages/default/home_view.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: GoogleSignInPage, initial: true),
    AutoRoute(page: LoginFormPage),
    AutoRoute(page: GoogleSignUpPage),
    AutoRoute(page: SignupFormPage),
    AutoRoute(page: GoogleSignUpSetupPage),
    AutoRoute(page: HomePage),
    AutoRoute(page: ContactsPage),
    AutoRoute(page: ChatPage),
  ],
)
class $AppRouter {}


// flutter packages pub run build_runner build