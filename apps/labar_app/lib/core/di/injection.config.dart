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
import '../../features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i560;
import '../../features/auth/domain/usecases/resend_otp_usecase.dart' as _i613;
import '../../features/auth/domain/usecases/sign_in_usecase.dart' as _i259;
import '../../features/auth/domain/usecases/sign_up_usecase.dart' as _i860;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/auth/presentation/forgot_password/cubit/forgot_password_cubit.dart'
    as _i244;
import '../../features/auth/presentation/sign_in/cubit/sign_in_cubit.dart'
    as _i448;
import '../../features/auth/presentation/sign_up/cubit/sign_up_cubit.dart'
    as _i302;
import '../../features/auth/presentation/sign_up/cubit/sign_up_verification_cubit.dart'
    as _i317;
import '../../features/home/data/datasources/location_local_datasource.dart'
    as _i1069;
import '../../features/home/data/repositories/allocated_resource_repository_impl.dart'
    as _i469;
import '../../features/home/data/repositories/application_repository_impl.dart'
    as _i786;
import '../../features/home/data/repositories/location_repository_impl.dart'
    as _i148;
import '../../features/home/data/repositories/warehouse_repository_impl.dart'
    as _i313;
import '../../features/home/domain/repositories/allocated_resource_repository.dart'
    as _i204;
import '../../features/home/domain/repositories/application_repository.dart'
    as _i508;
import '../../features/home/domain/repositories/location_repository.dart'
    as _i853;
import '../../features/home/domain/repositories/warehouse_repository.dart'
    as _i503;
import '../../features/home/domain/usecases/get_lgas_usecase.dart' as _i636;
import '../../features/home/domain/usecases/get_states_usecase.dart' as _i239;
import '../../features/home/presentation/cubit/allocated_resources_cubit.dart'
    as _i230;
import '../../features/home/presentation/cubit/application_form_cubit.dart'
    as _i124;
import '../../features/home/presentation/cubit/assigned_warehouse_cubit.dart'
    as _i948;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/home/presentation/cubit/sections/bank_details_cubit.dart'
    as _i376;
import '../../features/home/presentation/cubit/sections/biometrics_cubit.dart'
    as _i891;
import '../../features/home/presentation/cubit/sections/contact_info_cubit.dart'
    as _i831;
import '../../features/home/presentation/cubit/sections/farm_details_cubit.dart'
    as _i761;
import '../../features/home/presentation/cubit/sections/kyc_details_cubit.dart'
    as _i2;
import '../../features/home/presentation/cubit/sections/personal_info_cubit.dart'
    as _i1026;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../localization/language_cubit.dart' as _i170;
import '../session/session_cubit.dart' as _i796;
import '../theme/theme_cubit.dart' as _i611;
import 'register_module.dart' as _i291;

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
    final registerModule = _$RegisterModule();
    gh.factory<_i792.SettingsCubit>(() => _i792.SettingsCubit());
    gh.factory<_i891.BiometricsCubit>(() => _i891.BiometricsCubit());
    gh.factory<_i831.ContactInfoCubit>(() => _i831.ContactInfoCubit());
    gh.factory<_i761.FarmDetailsCubit>(() => _i761.FarmDetailsCubit());
    gh.factory<_i2.KycDetailsCubit>(() => _i2.KycDetailsCubit());
    gh.factory<_i376.BankDetailsCubit>(() => _i376.BankDetailsCubit());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i611.ThemeCubit>(() => _i611.ThemeCubit());
    gh.lazySingleton<_i170.LanguageCubit>(() => _i170.LanguageCubit());
    gh.lazySingleton<_i1069.LocationLocalDataSource>(
        () => _i1069.LocationLocalDataSourceImpl());
    gh.lazySingleton<_i204.AllocatedResourceRepository>(() =>
        _i469.AllocatedResourceRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i503.WarehouseRepository>(
        () => _i313.WarehouseRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i508.ApplicationRepository>(
        () => _i786.ApplicationRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i230.AllocatedResourcesCubit>(() =>
        _i230.AllocatedResourcesCubit(gh<_i204.AllocatedResourceRepository>()));
    gh.lazySingleton<_i853.LocationRepository>(() =>
        _i148.LocationRepositoryImpl(gh<_i1069.LocationLocalDataSource>()));
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()));
    gh.factory<_i948.AssignedWarehouseCubit>(
        () => _i948.AssignedWarehouseCubit(gh<_i503.WarehouseRepository>()));
    gh.lazySingleton<_i124.ApplicationFormCubit>(
        () => _i124.ApplicationFormCubit(gh<_i508.ApplicationRepository>()));
    gh.factory<_i9.HomeCubit>(
        () => _i9.HomeCubit(gh<_i508.ApplicationRepository>()));
    gh.lazySingleton<_i796.SessionCubit>(
        () => _i796.SessionCubit(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i239.GetStatesUseCase>(
        () => _i239.GetStatesUseCase(gh<_i853.LocationRepository>()));
    gh.lazySingleton<_i636.GetLgasUseCase>(
        () => _i636.GetLgasUseCase(gh<_i853.LocationRepository>()));
    gh.lazySingleton<_i613.ResendOtpUseCase>(
        () => _i613.ResendOtpUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i560.ForgotPasswordUseCase>(
        () => _i560.ForgotPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i259.SignInUseCase>(
        () => _i259.SignInUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i860.SignUpUseCase>(
        () => _i860.SignUpUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i503.VerifyOtpUseCase>(
        () => _i503.VerifyOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i302.SignUpCubit>(
        () => _i302.SignUpCubit(gh<_i860.SignUpUseCase>()));
    gh.factory<_i244.ForgotPasswordCubit>(() => _i244.ForgotPasswordCubit(
          gh<_i560.ForgotPasswordUseCase>(),
          gh<_i503.VerifyOtpUseCase>(),
        ));
    gh.factory<_i317.SignUpVerificationCubit>(
        () => _i317.SignUpVerificationCubit(
              gh<_i503.VerifyOtpUseCase>(),
              gh<_i613.ResendOtpUseCase>(),
            ));
    gh.factory<_i1026.PersonalInfoCubit>(() => _i1026.PersonalInfoCubit(
          gh<_i239.GetStatesUseCase>(),
          gh<_i636.GetLgasUseCase>(),
        ));
    gh.factory<_i448.SignInCubit>(
        () => _i448.SignInCubit(gh<_i259.SignInUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
