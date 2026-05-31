import 'package:expenseflow/features/auth/bloc/auth_bloc.dart';
import 'package:expenseflow/features/auth/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/network/api_service.dart';
import 'core/theme/app_theme.dart';
import 'core/util/const/constants.dart';
import 'features/categories/cubit/category_cubit.dart';
import 'features/accounts/cubit/account_cubit.dart';
import 'features/recurring/cubit/reminder_cubit.dart';
import 'features/recurring/cubit/subscription_cubit.dart';
import 'features/dashboard/cubit/dashboard_cubit.dart';
import 'features/payees/cubit/payee_cubit.dart';
import 'features/tags/cubit/tag_cubit.dart';
import 'features/splash/splash_page.dart';
import 'features/organization/cubit/organization_cubit.dart';
import 'features/transactions/cubit/transactions_cubit.dart';
import 'core/services/shortcut_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  ApiService().initApiService();
  ShortcutService.instance.init();
  runApp(const ExpenseFlowApp());
}

class ExpenseFlowApp extends StatelessWidget {
  const ExpenseFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
        BlocProvider<AccountCubit>(create: (context) => AccountCubit()),
        BlocProvider<SubscriptionCubit>(
          create: (context) => SubscriptionCubit(),
        ),
        BlocProvider<ReminderCubit>(create: (context) => ReminderCubit()),
        BlocProvider<DashboardCubit>(create: (context) => DashboardCubit()),
        BlocProvider<PayeeCubit>(create: (context) => PayeeCubit()),
        BlocProvider<TagCubit>(create: (context) => TagCubit()),
        BlocProvider<OrganizationCubit>(
          create: (context) => OrganizationCubit(),
        ),
        BlocProvider<TransactionsCubit>(
          create: (context) => TransactionsCubit(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous is! LoggedOut && current is LoggedOut,
            listener: (context, state) {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: MaterialApp(
              title: 'ExpenseFlow',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              home: const SplashPage(),
            ),
          );
        },
      ),
    );
  }
}
