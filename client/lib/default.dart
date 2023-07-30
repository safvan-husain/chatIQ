import 'package:auto_route/auto_route.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      routes: const [
        HomeRoute(),
        CallHistoryRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return SalomonBottomBar(
          unselectedItemColor: Theme.of(context).primaryColorDark,
          selectedItemColor: Theme.of(context).focusColor,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            SalomonBottomBarItem(
              icon: const FaIcon(
                FontAwesomeIcons.comments,
              ),
              title: const Text('Posts'),
            ),
            SalomonBottomBarItem(
              icon: const FaIcon(
                FontAwesomeIcons.phoneAlt,
                size: 30,
              ),
              title: const Text('Users'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.settings,
                size: 30,
              ),
              title: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }
}
