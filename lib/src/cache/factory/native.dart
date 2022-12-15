import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<Uint8List?> downloadAndCache( String url ) async {
  File file = await DefaultCacheManager().getSingleFile( url );
  return file.readAsBytesSync();
}

Future<bool> hasFontInCache(String source) async {
  return false;
}