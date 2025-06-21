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

import 'business_logic/schedule.api.dart' as _i808;
import 'business_logic/schedule.repository.dart' as _i620;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i808.ScheduleApi>(
    () => _i808.ScheduleApi(),
    dispose: (i) => i.dispose(),
  );
  gh.singleton<_i620.ScheduleRepository>(
    () => _i620.ScheduleRepository(gh<_i808.ScheduleApi>()),
    dispose: (i) => i.dispose(),
  );
  return getIt;
}
