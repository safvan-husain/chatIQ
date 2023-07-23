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
import 'package:auto_route/auto_route.dart' as _i9;
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
import 'package:client/features/chat/presentation/pages/chat_view.dart' as _i8;
import 'package:client/features/home/domain/entities/user.dart' as _i12;
import 'package:client/features/home/presentation/pages/contacts/contacts.dart'
    as _i7;
import 'package:client/features/home/presentation/pages/default/home_view.dart'
    as _i6;
import 'package:flutter/material.dart' as _i10;
import 'package:google_sign_in/google_sign_in.dart' as _i11;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    GoogleSignInRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.GoogleSignInPage(),
      );
    },
    LoginFormRoute.name: (routeData) {
      final args = routeData.argsAs<LoginFormRouteArgs>(
          orElse: () => const LoginFormRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.LoginFormPage(key: args.key),
      );
    },
    GoogleSignUpRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.GoogleSignUpPage(),
      );
    },
    SignupFormRoute.name: (routeData) {
      final args = routeData.argsAs<SignupFormRouteArgs>(
          orElse: () => const SignupFormRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.SignupFormPage(key: args.key),
      );
    },
    GoogleSignUpSetupRoute.name: (routeData) {
      final args = routeData.argsAs<GoogleSignUpSetupRouteArgs>();
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.GoogleSignUpSetupPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.HomePage(),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.ContactsPage(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.ChatPage(
          key: args.key,
          user: args.user,
        ),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          GoogleSignInRoute.name,
          path: '/',
        ),
        _i9.RouteConfig(
          LoginFormRoute.name,
          path: '/login-form-page',
        ),
        _i9.RouteConfig(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        ),
        _i9.RouteConfig(
          SignupFormRoute.name,
          path: '/signup-form-page',
        ),
        _i9.RouteConfig(
          GoogleSignUpSetupRoute.name,
          path: '/google-sign-up-setup-page',
        ),
        _i9.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i9.RouteConfig(
          ContactsRoute.name,
          path: '/contacts-page',
        ),
        _i9.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
      ];
}

/// generated route for
/// [_i1.GoogleSignInPage]
class GoogleSignInRoute extends _i9.PageRouteInfo<void> {
  const GoogleSignInRoute()
      : super(
          GoogleSignInRoute.name,
          path: '/',
        );

  static const String name = 'GoogleSignInRoute';
}

/// generated route for
/// [_i2.LoginFormPage]
class LoginFormRoute extends _i9.PageRouteInfo<LoginFormRouteArgs> {
  LoginFormRoute({_i10.Key? key})
      : super(
          LoginFormRoute.name,
          path: '/login-form-page',
          args: LoginFormRouteArgs(key: key),
        );

  static const String name = 'LoginFormRoute';
}

class LoginFormRouteArgs {
  const LoginFormRouteArgs({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return 'LoginFormRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.GoogleSignUpPage]
class GoogleSignUpRoute extends _i9.PageRouteInfo<void> {
  const GoogleSignUpRoute()
      : super(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        );

  static const String name = 'GoogleSignUpRoute';
}

/// generated route for
/// [_i4.SignupFormPage]
class SignupFormRoute extends _i9.PageRouteInfo<SignupFormRouteArgs> {
  SignupFormRoute({_i10.Key? key})
      : super(
          SignupFormRoute.name,
          path: '/signup-form-page',
          args: SignupFormRouteArgs(key: key),
        );

  static const String name = 'SignupFormRoute';
}

class SignupFormRouteArgs {
  const SignupFormRouteArgs({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return 'SignupFormRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.GoogleSignUpSetupPage]
class GoogleSignUpSetupRoute
    extends _i9.PageRouteInfo<GoogleSignUpSetupRouteArgs> {
  GoogleSignUpSetupRoute({
    required _i11.GoogleSignInAccount account,
    _i10.Key? key,
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

  final _i11.GoogleSignInAccount account;

  final _i10.Key? key;

  @override
  String toString() {
    return 'GoogleSignUpSetupRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i7.ContactsPage]
class ContactsRoute extends _i9.PageRouteInfo<void> {
  const ContactsRoute()
      : super(
          ContactsRoute.name,
          path: '/contacts-page',
        );

  static const String name = 'ContactsRoute';
}

/// generated route for
/// [_i8.ChatPage]
class ChatRoute extends _i9.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i10.Key? key,
    required _i12.User user,
  }) : super(
          ChatRoute.name,
          path: '/chat-page',
          args: ChatRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.user,
  });

  final _i10.Key? key;

  final _i12.User user;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user}';
  }
}
