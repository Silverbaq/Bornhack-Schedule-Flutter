// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'business_logic/schedule.api.dart' as _i3;
import 'business_logic/schedule.repository.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.ScheduleApi>(_i3.ScheduleApi(), dispose: (i) => i.dispose());
  gh.singleton<_i4.ScheduleRepository>(
      _i4.ScheduleRepository(get<_i3.ScheduleApi>()),
      dispose: (i) => i.dispose());
  return get;
}
