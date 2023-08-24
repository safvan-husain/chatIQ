import 'package:auto_route/auto_route.dart';
import 'package:client/common/widgets/snack_bar.dart';
import 'package:client/core/theme/theme_services.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
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
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
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
                          backgroundColor: Colors.amberAccent,
                          radius: 40.0,
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
          SettingsTile(
            title: 'Delete All Chats',
            icon: Icons.delete_outline,
            subtitle: 'delete all message from local Storage.',
            onConfirmBtnTap: () {
              context.read<SettingsCubit>().deleteLocalChats(
                  onCacheDeleteFailed: () =>
                      showSnackBar(context, 'Failed to delete chats'),
                  onCacheDeleted: () =>
                      context.read<HomeCubit>().getChats(() {}));
            },
          ),
          SettingsTile(
            icon: Icons.delete_forever_outlined,
            title: 'Request to Delete All Data',
            subtitle: 'request to delete all message from remote DataBase.',
            onConfirmBtnTap: () => context
                .read<SettingsCubit>()
                .deleteRemoteData(
                    context.read<AuthenticationCubit>().state.user!.token),
          ),
          SettingsTile(
            title: "Log Out",
            icon: Icons.exit_to_app_outlined,
            onConfirmBtnTap: () => context.read<SettingsCubit>().logOut(() =>
                context.router.pushAndPopUntil(const GoogleSignInRoute(),
                    predicate: (_) => false)),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 50.0),
        child: AppBar(
          elevation: 0.0,
          title: const Text('Settings'),
        ));
  }
}
