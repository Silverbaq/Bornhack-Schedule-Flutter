import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProvider(this.path);
  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

/// localstorage v6 uses a global store initialized via [initLocalStorage],
/// which hits path_provider's platform channel — that channel hangs under
/// `flutter test`. Mock it to a temp dir so widget tests that read settings
/// don't hang or throw LateInitializationError.
Future<void> initTestLocalStorage() async {
  final dir = Directory.systemTemp.createTempSync('bornhack_ls_test');
  PathProviderPlatform.instance = _FakePathProvider(dir.path);
  await initLocalStorage();
}
