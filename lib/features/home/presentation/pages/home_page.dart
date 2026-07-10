import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/home_event.dart';
import '../../presentation/bloc/home_state.dart';
import '../../presentation/widgets/home_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
            case HomeStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case HomeStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: context.colorScheme.error),
                    const SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      state.errorMessage ?? 'Something went wrong',
                      style: context.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeDataRequested());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case HomeStatus.loaded:
              if (state.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined,
                          size: 64, color: context.colorScheme.primary),
                      const SizedBox(height: AppDimensions.spacingMd),
                      Text(
                        'No items yet',
                        style: context.textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        'Items will appear here once available',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(HomeDataRequested());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return HomeCard(item: state.items[index]);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
