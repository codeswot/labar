// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/dashboard/data/repositories/admin_repository_impl.dart'
    as _i1071;
import '../../features/dashboard/data/repositories/agent_repository_impl.dart'
    as _i220;
import '../../features/dashboard/data/repositories/warehouse_repository.dart'
    as _i369;
import '../../features/dashboard/presentation/cubit/agent_cubit.dart' as _i664;
import '../../features/dashboard/presentation/cubit/application_management_cubit.dart'
    as _i481;
import '../../features/dashboard/presentation/cubit/dashboard_overview_cubit.dart'
    as _i246;
import '../../features/dashboard/presentation/cubit/inventory_management_cubit.dart'
    as _i783;
import '../../features/dashboard/presentation/cubit/item_management_cubit.dart'
    as _i20;
import '../../features/dashboard/presentation/cubit/user_management_cubit.dart'
    as _i572;
import '../session/session_cubit.dart' as _i796;
import '../theme/theme_cubit.dart' as _i611;
import 'supabase_module.dart' as _i695;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final supabaseModule = _$SupabaseModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i611.ThemeCubit>(() => _i611.ThemeCubit());
    gh.factory<_i246.DashboardOverviewCubit>(
        () => _i246.DashboardOverviewCubit(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i369.WarehouseRepository>(
        () => _i369.WarehouseRepository(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i220.AgentRepository>(
        () => _i220.AgentRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i664.AgentCubit>(() => _i664.AgentCubit(
          gh<_i220.AgentRepository>(),
          gh<_i454.SupabaseClient>(),
        ));
    gh.lazySingleton<_i1071.AdminRepository>(
        () => _i1071.AdminRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i783.InventoryManagementCubit>(
        () => _i783.InventoryManagementCubit(gh<_i1071.AdminRepository>()));
    gh.factory<_i20.ItemManagementCubit>(
        () => _i20.ItemManagementCubit(gh<_i1071.AdminRepository>()));
    gh.factory<_i481.ApplicationManagementCubit>(
        () => _i481.ApplicationManagementCubit(
              gh<_i1071.AdminRepository>(),
              gh<_i454.SupabaseClient>(),
            ));
    gh.factory<_i572.UserManagementCubit>(
        () => _i572.UserManagementCubit(gh<_i1071.AdminRepository>()));
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()));
    gh.lazySingleton<_i796.SessionCubit>(
        () => _i796.SessionCubit(gh<_i787.AuthRepository>()));
    return this;
  }
}

class _$SupabaseModule extends _i695.SupabaseModule {}
