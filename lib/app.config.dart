// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'business_logic/media_archive/media_archive.api.dart' as _i3;
import 'business_logic/schedule/schedule.api.dart' as _i4;
import 'business_logic/schedule/schedule.repository.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.MediaApi>(_i3.MediaApi(), dispose: (i) => i.dispose());
  gh.singleton<_i4.ScheduleApi>(_i4.ScheduleApi(), dispose: (i) => i.dispose());
  gh.singleton<_i5.ScheduleRepository>(
      _i5.ScheduleRepository(get<_i4.ScheduleApi>()),
      dispose: (i) => i.dispose());
  return get;
}
