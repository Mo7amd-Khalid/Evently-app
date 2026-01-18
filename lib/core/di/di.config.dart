// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasource/contract/local_datasource.dart' as _i486;
import '../../data/datasource/impl/local_datasource_impl.dart' as _i23;
import '../../data/repo_impl/repo_impl.dart' as _i212;
import '../../domain/repository/evently_repo.dart' as _i596;
import '../../domain/use_case/use_case.dart' as _i719;
import '../../presentation/onboarding/cubit/onboarding_cubit.dart' as _i657;
import '../../presentation/setup/cubit/setup_cubit.dart' as _i536;
import 'provide_sharedPreferences.dart' as _i1041;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final provideSharedPreferences = _$ProvideSharedPreferences();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => provideSharedPreferences.provideShared(),
      preResolve: true,
    );
    gh.factory<_i486.LocalDatasource>(
      () => _i23.LocalDatasourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i596.EventlyRepository>(
      () => _i212.RepoImpl(gh<_i486.LocalDatasource>()),
    );
    gh.factory<_i719.EventlyUseCase>(
      () => _i719.EventlyUseCase(gh<_i596.EventlyRepository>()),
    );
    gh.singleton<_i536.SetupCubit>(
      () => _i536.SetupCubit(gh<_i719.EventlyUseCase>()),
    );
    gh.factory<_i657.OnboardingCubit>(
      () => _i657.OnboardingCubit(gh<_i719.EventlyUseCase>()),
    );
    return this;
  }
}

class _$ProvideSharedPreferences extends _i1041.ProvideSharedPreferences {}
