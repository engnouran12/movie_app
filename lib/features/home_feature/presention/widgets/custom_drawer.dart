import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/presention/screens/wash_list.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.tmdbAuth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Guest'),
            accountEmail: const Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePath ?? ''),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WishlistScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
