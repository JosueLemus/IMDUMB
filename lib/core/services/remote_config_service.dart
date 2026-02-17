import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults({
      'theme_config': '{"primary": "#3713EC", "accent": "#FFB800"}',
    });

    await _remoteConfig.fetchAndActivate();
  }

  String getPrimaryColor() {
    final themeConfig = _remoteConfig.getString('theme_config');
    try {
      if (themeConfig.contains('"primary":')) {
        final regExp = RegExp(r'"primary":\s*"([^"]+)"');
        final match = regExp.firstMatch(themeConfig);
        return match?.group(1) ?? '#3713EC';
      }
      return '#3713EC';
    } catch (e) {
      return '#3713EC';
    }
  }
}
