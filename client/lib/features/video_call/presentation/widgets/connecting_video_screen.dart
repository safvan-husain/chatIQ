import 'package:auto_route/auto_route.dart';
import 'package:client/core/Injector/injector.dart';
import 'package:client/core/helper/webrtc/webrtc_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../common/widgets/avatar.dart';
import '../../../../routes/router.gr.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../bloc/video_call_bloc.dart';

class ConnectingVideoScreen extends StatelessWidget {
  ConnectingVideoScreen(this.recieverName, {super.key})
      : avatar = showAvatar(150, username: recieverName);
  final Future<Widget>? avatar;
  final String recieverName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Connecting  $recieverName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  builder: (ctx, snpd) {
                    if (snpd.connectionState == ConnectionState.done) {
                      if (snpd.hasData) {
                        return snpd.data!;
                      } else {
                        return const CircleAvatar();
                      }
                    } else {
                      return const CircleAvatar();
                    }
                  },
                  future: avatar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
