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
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:client/features/Authentication/presentation/pages/google_sign_in.dart'
    as _i2;
import 'package:client/features/Authentication/presentation/pages/google_sign_up.dart'
    as _i3;
import 'package:client/features/Authentication/presentation/pages/initial_screen.dart'
    as _i1;
import 'package:client/features/chat/presentation/pages/chat_view.dart' as _i4;
import 'package:client/features/home/presentation/pages/contacts/contacts.dart'
    as _i5;
import 'package:client/features/home/presentation/pages/default/home_view.dart'
    as _i8;
import 'package:client/features/profile/presentation/pages/profile_page.dart'
    as _i6;
import 'package:client/features/settings/presentation/pages/settings_page.dart'
    as _i9;
import 'package:client/features/video_call/presentation/pages/video_call_page.dart'
    as _i7;
import 'package:flutter/material.dart' as _i11;

class AppRouter extends _i10.RootStackRouter {
  AppRouter([_i11.GlobalKey<_i11.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    InitialRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.InitialPage(),
      );
    },
    GoogleSignInRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.GoogleSignInPage(),
      );
    },
    GoogleSignUpRoute.name: (routeData) {
      final args = routeData.argsAs<GoogleSignUpRouteArgs>(
          orElse: () => const GoogleSignUpRouteArgs());
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.GoogleSignUpPage(key: args.key),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.ChatPage(
          key: args.key,
          userame: args.userame,
        ),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ContactsPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.ProfilePage(),
      );
    },
    VideoCallRoute.name: (routeData) {
      final args = routeData.argsAs<VideoCallRouteArgs>();
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.VideoCallPage(
          key: args.key,
          recieverName: args.recieverName,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.HomePage(),
      );
    },
    SettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsRouteArgs>(
          orElse: () => const SettingsRouteArgs());
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.SettingsPage(key: args.key),
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          InitialRoute.name,
          path: '/',
        ),
        _i10.RouteConfig(
          GoogleSignInRoute.name,
          path: '/google-sign-in-page',
        ),
        _i10.RouteConfig(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        ),
        _i10.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
        _i10.RouteConfig(
          ContactsRoute.name,
          path: '/contacts-page',
        ),
        _i10.RouteConfig(
          ProfileRoute.name,
          path: '/profile-page',
        ),
        _i10.RouteConfig(
          VideoCallRoute.name,
          path: '/video-call-page',
        ),
        _i10.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i10.RouteConfig(
          SettingsRoute.name,
          path: '/settings-page',
        ),
      ];
}

/// generated route for
/// [_i1.InitialPage]
class InitialRoute extends _i10.PageRouteInfo<void> {
  const InitialRoute()
      : super(
          InitialRoute.name,
          path: '/',
        );

  static const String name = 'InitialRoute';
}

/// generated route for
/// [_i2.GoogleSignInPage]
class GoogleSignInRoute extends _i10.PageRouteInfo<void> {
  const GoogleSignInRoute()
      : super(
          GoogleSignInRoute.name,
          path: '/google-sign-in-page',
        );

  static const String name = 'GoogleSignInRoute';
}

/// generated route for
/// [_i3.GoogleSignUpPage]
class GoogleSignUpRoute extends _i10.PageRouteInfo<GoogleSignUpRouteArgs> {
  GoogleSignUpRoute({_i11.Key? key})
      : super(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
          args: GoogleSignUpRouteArgs(key: key),
        );

  static const String name = 'GoogleSignUpRoute';
}

class GoogleSignUpRouteArgs {
  const GoogleSignUpRouteArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'GoogleSignUpRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.ChatPage]
class ChatRoute extends _i10.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i11.Key? key,
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

  final _i11.Key? key;

  final String userame;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, userame: $userame}';
  }
}

/// generated route for
/// [_i5.ContactsPage]
class ContactsRoute extends _i10.PageRouteInfo<void> {
  const ContactsRoute()
      : super(
          ContactsRoute.name,
          path: '/contacts-page',
        );

  static const String name = 'ContactsRoute';
}

/// generated route for
/// [_i6.ProfilePage]
class ProfileRoute extends _i10.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '/profile-page',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i7.VideoCallPage]
class VideoCallRoute extends _i10.PageRouteInfo<VideoCallRouteArgs> {
  VideoCallRoute({
    _i11.Key? key,
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

  final _i11.Key? key;

  final String recieverName;

  @override
  String toString() {
    return 'VideoCallRouteArgs{key: $key, recieverName: $recieverName}';
  }
}

/// generated route for
/// [_i8.HomePage]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i9.SettingsPage]
class SettingsRoute extends _i10.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i11.Key? key})
      : super(
          SettingsRoute.name,
          path: '/settings-page',
          args: SettingsRouteArgs(key: key),
        );

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key}';
  }
}
