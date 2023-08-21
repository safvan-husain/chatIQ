import 'package:client/constance/theme_services.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/avatar.dart';
import '../../../../constance/app_config.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final Future<Widget>? avatar = showAvatar(60);
  @override
  Widget build(BuildContext context) {
    AppConfig _config = AppConfig(context);
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          context
                              .read<AuthenticationCubit>()
                              .state
                              .user!
                              .username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _config.rW(5)),
                          overflow: TextOverflow.fade,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("available "),
                      ],
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
          InkWell(onTap: ()=> context.read<SettingsCubit>().deleteLocalChats() ,
            child: const ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Delete All Chats'),
              subtitle: Text('delete all message from local Storage.'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.delete_forever_outlined),
            title: Text('Request to Delete All Chats'),
            subtitle:
                Text('request to delete all message from remote DataBase.'),
          ),
          const ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text('Log Out'),
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
