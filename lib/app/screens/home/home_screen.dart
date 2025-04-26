import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   actions: [
      //     ElevatedButton(
      //       onPressed: () async {
      //         await ref.read(loginStateProvider.notifier).signOut();
      //         if (context.mounted) {
      //           context.router.replace(AppRoutes.loginPage);
      //         }
      //       },
      //       child: const Text('Log Out'),
      //     )
      //   ],
      // ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
