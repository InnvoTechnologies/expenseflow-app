import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionDisplayWidget extends StatelessWidget {
  const VersionDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error fetching app version');
          } else {
            final version = snapshot.data?.version ?? '';
            return Text('Version: $version');
          }
        },
      );
  }
}