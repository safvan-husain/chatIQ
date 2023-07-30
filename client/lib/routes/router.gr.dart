// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:client/default.dart' as _i10;
import 'package:client/features/Authentication/presentation/pages/sign_in/form_login.dart'
    as _i2;
import 'package:client/features/Authentication/presentation/pages/sign_in/google_sign_in.dart'
    as _i1;
import 'package:client/features/Authentication/presentation/pages/sign_up/google_sign_up.dart'
    as _i3;
import 'package:client/features/Authentication/presentation/pages/sign_up/google_sign_up_setup.dart'
    as _i5;
import 'package:client/features/Authentication/presentation/pages/sign_up/sign_up_from.dart'
    as _i4;
import 'package:client/features/call_history/presentation/pages/call_history_page.dart'
    as _i12;
import 'package:client/features/chat/presentation/pages/chat_view.dart' as _i6;
import 'package:client/features/home/presentation/pages/contacts/contacts.dart'
    as _i7;
import 'package:client/features/home/presentation/pages/default/home_view.dart'
    as _i11;
import 'package:client/features/profile/presentation/pages/profile_page.dart'
    as _i8;
import 'package:client/features/settings/presentation/pages/settings_page.dart'
    as _i13;
import 'package:client/features/video_call/presentation/pages/video_call_page.dart'
    as _i9;
import 'package:flutter/material.dart' as _i15;
import 'package:google_sign_in/google_sign_in.dart' as _i16;

class AppRouter extends _i14.RootStackRouter {
  AppRouter([_i15.GlobalKey<_i15.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    GoogleSignInRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.GoogleSignInPage(),
      );
    },
    LoginFormRoute.name: (routeData) {
      final args = routeData.argsAs<LoginFormRouteArgs>(
          orElse: () => const LoginFormRouteArgs());
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.LoginFormPage(key: args.key),
      );
    },
    GoogleSignUpRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.GoogleSignUpPage(),
      );
    },
    SignupFormRoute.name: (routeData) {
      final args = routeData.argsAs<SignupFormRouteArgs>(
          orElse: () => const SignupFormRouteArgs());
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.SignupFormPage(key: args.key),
      );
    },
    GoogleSignUpSetupRoute.name: (routeData) {
      final args = routeData.argsAs<GoogleSignUpSetupRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.GoogleSignUpSetupPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.ChatPage(
          key: args.key,
          userame: args.userame,
        ),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.ContactsPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.ProfilePage(),
      );
    },
    VideoCallRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.VideoCallPage(),
      );
    },
    DefaultRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.DefaultPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i11.HomePage(),
      );
    },
    CallHistoryRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i12.CallHistoryPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i13.SettingsPage(),
      );
    },
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig(
          GoogleSignInRoute.name,
          path: '/',
        ),
        _i14.RouteConfig(
          LoginFormRoute.name,
          path: '/login-form-page',
        ),
        _i14.RouteConfig(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        ),
        _i14.RouteConfig(
          SignupFormRoute.name,
          path: '/signup-form-page',
        ),
        _i14.RouteConfig(
          GoogleSignUpSetupRoute.name,
          path: '/google-sign-up-setup-page',
        ),
        _i14.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
        _i14.RouteConfig(
          ContactsRoute.name,
          path: '/contacts-page',
        ),
        _i14.RouteConfig(
          ProfileRoute.name,
          path: '/profile-page',
        ),
        _i14.RouteConfig(
          VideoCallRoute.name,
          path: '/video-call-page',
        ),
        _i14.RouteConfig(
          DefaultRoute.name,
          path: '/',
          children: [
            _i14.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: DefaultRoute.name,
            ),
            _i14.RouteConfig(
              CallHistoryRoute.name,
              path: 'call-history',
              parent: DefaultRoute.name,
            ),
            _i14.RouteConfig(
              SettingsRoute.name,
              path: 'settings',
              parent: DefaultRoute.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.GoogleSignInPage]
class GoogleSignInRoute extends _i14.PageRouteInfo<void> {
  const GoogleSignInRoute()
      : super(
          GoogleSignInRoute.name,
          path: '/',
        );

  static const String name = 'GoogleSignInRoute';
}

/// generated route for
/// [_i2.LoginFormPage]
class LoginFormRoute extends _i14.PageRouteInfo<LoginFormRouteArgs> {
  LoginFormRoute({_i15.Key? key})
      : super(
          LoginFormRoute.name,
          path: '/login-form-page',
          args: LoginFormRouteArgs(key: key),
        );

  static const String name = 'LoginFormRoute';
}

class LoginFormRouteArgs {
  const LoginFormRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'LoginFormRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.GoogleSignUpPage]
class GoogleSignUpRoute extends _i14.PageRouteInfo<void> {
  const GoogleSignUpRoute()
      : super(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        );

  static const String name = 'GoogleSignUpRoute';
}

/// generated route for
/// [_i4.SignupFormPage]
class SignupFormRoute extends _i14.PageRouteInfo<SignupFormRouteArgs> {
  SignupFormRoute({_i15.Key? key})
      : super(
          SignupFormRoute.name,
          path: '/signup-form-page',
          args: SignupFormRouteArgs(key: key),
        );

  static const String name = 'SignupFormRoute';
}

class SignupFormRouteArgs {
  const SignupFormRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'SignupFormRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.GoogleSignUpSetupPage]
class GoogleSignUpSetupRoute
    extends _i14.PageRouteInfo<GoogleSignUpSetupRouteArgs> {
  GoogleSignUpSetupRoute({
    required _i16.GoogleSignInAccount account,
    _i15.Key? key,
  }) : super(
          GoogleSignUpSetupRoute.name,
          path: '/google-sign-up-setup-page',
          args: GoogleSignUpSetupRouteArgs(
            account: account,
            key: key,
          ),
        );

  static const String name = 'GoogleSignUpSetupRoute';
}

class GoogleSignUpSetupRouteArgs {
  const GoogleSignUpSetupRouteArgs({
    required this.account,
    this.key,
  });

  final _i16.GoogleSignInAccount account;

  final _i15.Key? key;

  @override
  String toString() {
    return 'GoogleSignUpSetupRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [_i6.ChatPage]
class ChatRoute extends _i14.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i15.Key? key,
    required String userame,
  }) : super(
          ChatRoute.name,
          path: '/chat-page',
          args: ChatRouteArgs(
            key: key,
            userame: userame,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.userame,
  });

  final _i15.Key? key;

  final String userame;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, userame: $userame}';
  }
}

/// generated route for
/// [_i7.ContactsPage]
class ContactsRoute extends _i14.PageRouteInfo<void> {
  const ContactsRoute()
      : super(
          ContactsRoute.name,
          path: '/contacts-page',
        );

  static const String name = 'ContactsRoute';
}

/// generated route for
/// [_i8.ProfilePage]
class ProfileRoute extends _i14.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '/profile-page',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i9.VideoCallPage]
class VideoCallRoute extends _i14.PageRouteInfo<void> {
  const VideoCallRoute()
      : super(
          VideoCallRoute.name,
          path: '/video-call-page',
        );

  static const String name = 'VideoCallRoute';
}

/// generated route for
/// [_i10.DefaultPage]
class DefaultRoute extends _i14.PageRouteInfo<void> {
  const DefaultRoute({List<_i14.PageRouteInfo>? children})
      : super(
          DefaultRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'DefaultRoute';
}

/// generated route for
/// [_i11.HomePage]
class HomeRoute extends _i14.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i12.CallHistoryPage]
class CallHistoryRoute extends _i14.PageRouteInfo<void> {
  const CallHistoryRoute()
      : super(
          CallHistoryRoute.name,
          path: 'call-history',
        );

  static const String name = 'CallHistoryRoute';
}

/// generated route for
/// [_i13.SettingsPage]
class SettingsRoute extends _i14.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingsRoute';
}
