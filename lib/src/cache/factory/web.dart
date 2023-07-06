import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sembast_web/stash_sembast_web.dart';
import 'package:http/http.dart' as http;

Future<Uint8List?> downloadAndCache(String source) async {

  List<int>? cached = await _read(source);

  if (cached != null && cached.isNotEmpty) {
    if (kDebugMode) {
      debugPrint('EasyFontLoader: Used cache for $source');
    }
    return Uint8List.fromList(cached);
  }

  if (source.startsWith('http')) {
    var response = await _download(source);

    if (response != null && response.isNotEmpty) {
      _cache(source, response);
      return Uint8List.fromList(response);
    }
  } else {
    var asset = await _asset(source);

    if (asset != null && asset.isNotEmpty) {
      _cache(source, asset);
      return Uint8List.fromList(asset);
    }
  }

  return null;
}

Future<bool> hasFontInCache(String source) async {
  try {
    final cache = await _getCache();
    return await cache.containsKey(source);
  } catch(e) {
    return false;
  }
}

Future<Cache<String>> _getCache() async {
  final store = await newSembastWebCacheStore();

  return await store.cache<String>(
    name: 'fontCache',
    eventListenerMode: EventListenerMode.disabled,
  );
}

Future<List<int>?> _read(String key) async {
  try {
    final cache = await _getCache();
    var r = await cache.get(key);

    if (r != null) {
      return <int>[...r.split(',').map((e) => int.parse(e))];
    }
  } catch(e) {
    debugPrint(e.toString());
  }
  return null;
}

Future<void> _cache(String key, List<int> bytes) async {
  final cache = await _getCache();
  await cache.put(key, bytes.join(','));
}

Future<List<int>?> _asset(String asset) async {
  try {
    var result = await rootBundle.load(asset);
    return List.from(result.buffer.asUint8List());
  } catch(e) {
    if (kDebugMode) {
      debugPrint(e.toString());
    }
  }

  return null;
}

Future<List<int>?> _download(String url) async {

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode >= 200 && response.statusCode <300) {
      if (response.bodyBytes.isNotEmpty) {
        return <int>[...response.bodyBytes];
      }
    }

  } catch (e) {
    if (kDebugMode) {
      debugPrint(e.toString());
    }
  }

  return null;
}
