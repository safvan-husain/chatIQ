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
import 'package:auto_route/auto_route.dart' as _i12;
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
import 'package:client/features/chat/presentation/pages/chat_view.dart' as _i6;
import 'package:client/features/home/presentation/pages/contacts/contacts.dart'
    as _i7;
import 'package:client/features/home/presentation/pages/default/home_view.dart'
    as _i10;
import 'package:client/features/profile/presentation/pages/profile_page.dart'
    as _i8;
import 'package:client/features/settings/presentation/pages/settings_page.dart'
    as _i11;
import 'package:client/features/video_call/presentation/pages/video_call_page.dart'
    as _i9;
import 'package:flutter/material.dart' as _i13;
import 'package:google_sign_in/google_sign_in.dart' as _i14;

class AppRouter extends _i12.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    GoogleSignInRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.GoogleSignInPage(),
      );
    },
    LoginFormRoute.name: (routeData) {
      final args = routeData.argsAs<LoginFormRouteArgs>(
          orElse: () => const LoginFormRouteArgs());
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.LoginFormPage(key: args.key),
      );
    },
    GoogleSignUpRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.GoogleSignUpPage(),
      );
    },
    SignupFormRoute.name: (routeData) {
      final args = routeData.argsAs<SignupFormRouteArgs>(
          orElse: () => const SignupFormRouteArgs());
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.SignupFormPage(key: args.key),
      );
    },
    GoogleSignUpSetupRoute.name: (routeData) {
      final args = routeData.argsAs<GoogleSignUpSetupRouteArgs>();
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.GoogleSignUpSetupPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.ChatPage(
          key: args.key,
          userame: args.userame,
        ),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.ContactsPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.ProfilePage(),
      );
    },
    VideoCallRoute.name: (routeData) {
      final args = routeData.argsAs<VideoCallRouteArgs>();
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.VideoCallPage(
          key: args.key,
          recieverName: args.recieverName,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.HomePage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i11.SettingsPage(),
      );
    },
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(
          GoogleSignInRoute.name,
          path: '/',
        ),
        _i12.RouteConfig(
          LoginFormRoute.name,
          path: '/login-form-page',
        ),
        _i12.RouteConfig(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        ),
        _i12.RouteConfig(
          SignupFormRoute.name,
          path: '/signup-form-page',
        ),
        _i12.RouteConfig(
          GoogleSignUpSetupRoute.name,
          path: '/google-sign-up-setup-page',
        ),
        _i12.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
        _i12.RouteConfig(
          ContactsRoute.name,
          path: '/contacts-page',
        ),
        _i12.RouteConfig(
          ProfileRoute.name,
          path: '/profile-page',
        ),
        _i12.RouteConfig(
          VideoCallRoute.name,
          path: '/video-call-page',
        ),
        _i12.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i12.RouteConfig(
          SettingsRoute.name,
          path: '/settings-page',
        ),
      ];
}

/// generated route for
/// [_i1.GoogleSignInPage]
class GoogleSignInRoute extends _i12.PageRouteInfo<void> {
  const GoogleSignInRoute()
      : super(
          GoogleSignInRoute.name,
          path: '/',
        );

  static const String name = 'GoogleSignInRoute';
}

/// generated route for
/// [_i2.LoginFormPage]
class LoginFormRoute extends _i12.PageRouteInfo<LoginFormRouteArgs> {
  LoginFormRoute({_i13.Key? key})
      : super(
          LoginFormRoute.name,
          path: '/login-form-page',
          args: LoginFormRouteArgs(key: key),
        );

  static const String name = 'LoginFormRoute';
}

class LoginFormRouteArgs {
  const LoginFormRouteArgs({this.key});

  final _i13.Key? key;

  @override
  String toString() {
    return 'LoginFormRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.GoogleSignUpPage]
class GoogleSignUpRoute extends _i12.PageRouteInfo<void> {
  const GoogleSignUpRoute()
      : super(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        );

  static const String name = 'GoogleSignUpRoute';
}

/// generated route for
/// [_i4.SignupFormPage]
class SignupFormRoute extends _i12.PageRouteInfo<SignupFormRouteArgs> {
  SignupFormRoute({_i13.Key? key})
      : super(
          SignupFormRoute.name,
          path: '/signup-form-page',
          args: SignupFormRouteArgs(key: key),
        );

  static const String name = 'SignupFormRoute';
}

class SignupFormRouteArgs {
  const SignupFormRouteArgs({this.key});

  final _i13.Key? key;

  @override
  String toString() {
    return 'SignupFormRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.GoogleSignUpSetupPage]
class GoogleSignUpSetupRoute
    extends _i12.PageRouteInfo<GoogleSignUpSetupRouteArgs> {
  GoogleSignUpSetupRoute({
    required _i14.GoogleSignInAccount account,
    _i13.Key? key,
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

  final _i14.GoogleSignInAccount account;

  final _i13.Key? key;

  @override
  String toString() {
    return 'GoogleSignUpSetupRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [_i6.ChatPage]
class ChatRoute extends _i12.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i13.Key? key,
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

  final _i13.Key? key;

  final String userame;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, userame: $userame}';
  }
}

/// generated route for
/// [_i7.ContactsPage]
class ContactsRoute extends _i12.PageRouteInfo<void> {
  const ContactsRoute()
      : super(
          ContactsRoute.name,
          path: '/contacts-page',
        );

  static const String name = 'ContactsRoute';
}

/// generated route for
/// [_i8.ProfilePage]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '/profile-page',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i9.VideoCallPage]
class VideoCallRoute extends _i12.PageRouteInfo<VideoCallRouteArgs> {
  VideoCallRoute({
    _i13.Key? key,
    required String recieverName,
  }) : super(
          VideoCallRoute.name,
          path: '/video-call-page',
          args: VideoCallRouteArgs(
            key: key,
            recieverName: recieverName,
          ),
        );

  static const String name = 'VideoCallRoute';
}

class VideoCallRouteArgs {
  const VideoCallRouteArgs({
    this.key,
    required this.recieverName,
  });

  final _i13.Key? key;

  final String recieverName;

  @override
  String toString() {
    return 'VideoCallRouteArgs{key: $key, recieverName: $recieverName}';
  }
}

/// generated route for
/// [_i10.HomePage]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i11.SettingsPage]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: '/settings-page',
        );

  static const String name = 'SettingsRoute';
}
