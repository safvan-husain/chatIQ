import 'package:flutter/material.dart';

import '../../../../common/widgets/avatar.dart';

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
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    //wrap helps to show the full name in second line
                    //if there is not enogh space.
                    const Text(
                      'Connecting  ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      recieverName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
