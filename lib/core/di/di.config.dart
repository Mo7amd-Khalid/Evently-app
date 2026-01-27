// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasource/contract/auth_remote_datasource.dart' as _i912;
import '../../data/datasource/contract/firestore_remote_datasource.dart'
    as _i725;
import '../../data/datasource/contract/local_datasource.dart' as _i486;
import '../../data/datasource/impl/auth_remote_datasource_impl.dart' as _i939;
import '../../data/datasource/impl/firestore_remote_datasource_impl.dart'
    as _i665;
import '../../data/datasource/impl/local_datasource_impl.dart' as _i23;
import '../../data/repo_impl/auth_repo_impl.dart' as _i540;
import '../../data/repo_impl/repo_impl.dart' as _i212;
import '../../domain/repository/auth_repository.dart' as _i614;
import '../../domain/repository/evently_repo.dart' as _i596;
import '../../domain/use_case/auth_use_case.dart' as _i185;
import '../../domain/use_case/use_case.dart' as _i719;
import '../../presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart'
    as _i794;
import '../../presentation/event_management/cubit/event_cubit.dart' as _i763;
import '../../presentation/forget_password/cubit/forget_password_cubit.dart'
    as _i671;
import '../../presentation/login/cubit/login_cubit.dart' as _i101;
import '../../presentation/main/cubit/main_cubit.dart' as _i671;
import '../../presentation/onboarding/cubit/onboarding_cubit.dart' as _i657;
import '../../presentation/register/cubit/register_cubit.dart' as _i849;
import '../../presentation/select_location/cubit/google_map_cubit.dart' as _i73;
import '../../presentation/setup/cubit/setup_cubit.dart' as _i536;
import 'provide_firebase.dart' as _i743;
import 'provide_sharedPreferences.dart' as _i1041;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final provideSharedPreferences = _$ProvideSharedPreferences();
    final provideFirebase = _$ProvideFirebase();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => provideSharedPreferences.provideShared(),
      preResolve: true,
    );
    gh.factory<_i671.MainCubit>(() => _i671.MainCubit());
    gh.lazySingleton<_i59.FirebaseAuth>(() => provideFirebase.firebaseAuth());
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => provideFirebase.firebaseFirestore(),
    );
    gh.factory<_i486.LocalDatasource>(
      () => _i23.LocalDatasourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i912.AuthRemoteDatasource>(
      () => _i939.AuthRemoteDatasourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i725.FirestoreRemoteDatasource>(
      () => _i665.FirestoreRemoteDatasourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i614.AuthRepository>(
      () => _i540.AuthRepoImpl(
        gh<_i912.AuthRemoteDatasource>(),
        gh<_i725.FirestoreRemoteDatasource>(),
        gh<_i486.LocalDatasource>(),
      ),
    );
    gh.factory<_i596.EventlyRepository>(
      () => _i212.RepoImpl(
        gh<_i486.LocalDatasource>(),
        gh<_i725.FirestoreRemoteDatasource>(),
      ),
    );
    gh.factory<_i185.AuthUseCase>(
      () => _i185.AuthUseCase(gh<_i614.AuthRepository>()),
    );
    gh.factory<_i719.EventlyUseCase>(
      () => _i719.EventlyUseCase(gh<_i596.EventlyRepository>()),
    );
    gh.factory<_i794.HomeCubit>(() => _i794.HomeCubit(gh<_i185.AuthUseCase>()));
    gh.factory<_i101.LoginCubit>(
      () => _i101.LoginCubit(gh<_i185.AuthUseCase>()),
    );
    gh.factory<_i671.ForgetPasswordCubit>(
      () => _i671.ForgetPasswordCubit(gh<_i185.AuthUseCase>()),
    );
    gh.factory<_i849.RegisterCubit>(
      () => _i849.RegisterCubit(gh<_i185.AuthUseCase>()),
    );
    gh.singleton<_i536.SetupCubit>(
      () => _i536.SetupCubit(gh<_i719.EventlyUseCase>()),
    );
    gh.factory<_i657.OnboardingCubit>(
      () => _i657.OnboardingCubit(gh<_i719.EventlyUseCase>()),
    );
    gh.singleton<_i73.GoogleMapCubit>(
      () => _i73.GoogleMapCubit(gh<_i536.SetupCubit>()),
    );
    gh.factory<_i763.EventCubit>(
      () => _i763.EventCubit(
        gh<_i719.EventlyUseCase>(),
        gh<_i73.GoogleMapCubit>(),
      ),
    );
    return this;
  }
}

class _$ProvideSharedPreferences extends _i1041.ProvideSharedPreferences {}

class _$ProvideFirebase extends _i743.ProvideFirebase {}
