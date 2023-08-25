// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:client/common/widgets/snack_bar.dart';
import 'package:client/core/theme/theme_services.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:client/features/settings/presentation/widgets/settings_tile.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/avatar.dart';
import '../../../../constance/app_config.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  late Future<Widget>? avatar;
  late String username;
  @override
  Widget build(BuildContext context) {
    username = context.read<AuthenticationCubit>().state.user!.username;
    avatar = showAvatar(60, username: username);
    AppConfig config = AppConfig(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              _builtAppBar(context),
              _buildProfileCard(context, config),
              SettingsTile(
                title: 'Delete All Chats',
                icon: Icons.delete_outline,
                subtitle: 'delete all message from local Storage.',
                onConfirmBtnTap: () {
                  context.read<SettingsCubit>().deleteLocalChats(
                        onCacheDeleted: () {},
                        onCacheDeleteFailed: () {
                          showSnackBar(context, "message delete failed!");
                        },
                      );
                },
              ),
              SettingsTile(
                title: "Log Out",
                icon: Icons.exit_to_app_outlined,
                subtitle: 'Are you sure you want to log out',
                onConfirmBtnTap: () => context.read<SettingsCubit>().logOut(
                      () => context.router.pushAndPopUntil(
                        const GoogleSignInRoute(),
                        predicate: (_) => false,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildProfileCard(BuildContext context, AppConfig config) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FutureBuilder(
                    builder: (context, snpshst) {
                      if (snpshst.connectionState == ConnectionState.done) {
                        return snpshst.data ?? const CircleAvatar();
                      }
                      return const CircleAvatar(
                        radius: 30.0,
                      );
                    },
                    future: avatar,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: config.rW(5)),
                            // overflow: TextOverflow.fade,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("available "),
                      ],
                    ),
                  ),
                ],
              ),
              ToggleButtons(
                direction: Axis.vertical,
                selectedColor: Colors.amber,
                borderRadius: BorderRadius.circular(30),
                isSelected: [!context.isDarkMode, context.isDarkMode],
                onPressed: (_) => ThemeService().switchTheme(),
                children: const [
                  Icon(Icons.light_mode),
                  Icon(Icons.dark_mode),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _builtAppBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            height: 50,
            child: GestureDetector(
              onTap: () {
                context.router.pushAndPopUntil(const HomeRoute(),
                    predicate: (_) => false);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: const Text(
              "Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );
  }
}
