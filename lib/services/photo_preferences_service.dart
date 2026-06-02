import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PhotoPreferencesService {
  const PhotoPreferencesService();

  static const _prefsKey = 'image_paths';

  Future<List<String>> loadPaths() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];

    final checks = await Future.wait(raw.map(File.new).map((f) => f.exists()));
    final cleaned = [
      for (var i = 0; i < raw.length; i++)
        if (checks[i]) raw[i],
    ];

    if (cleaned.length != raw.length) {
      await prefs.setStringList(_prefsKey, cleaned);
    }

    return cleaned;
  }

  Future<void> savePaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, paths);
  }
}
