import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class UploadResult {
  const UploadResult({required this.url, required this.id});
  final String url;
  final String id;
}

/// Cliente simples para upload de imagens (classificados e feed).
class UploadService {
  UploadService({http.Client? client})
      : _client = client ?? http.Client(),
        _random = Random.secure();

  final http.Client _client;
  final Random _random;

  Future<UploadResult> uploadPostImage({
    required Uint8List bytes,
    required String originalName,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();
    final path =
        'posts/${now.year.toString().padLeft(4, '0')}/${now.month.toString().padLeft(2, '0')}';
    return _upload(bytes: bytes, originalName: originalName, path: path);
  }

  Future<UploadResult> uploadClassifiedImage({
    required Uint8List bytes,
    required String originalName,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();
    final path =
        'classifieds/${now.year.toString().padLeft(4, '0')}/${now.month.toString().padLeft(2, '0')}';
    return _upload(bytes: bytes, originalName: originalName, path: path);
  }

  Future<UploadResult> _upload({
    required Uint8List bytes,
    required String originalName,
    required String path,
  }) async {
    final unique = '${DateTime.now().toUtc().millisecondsSinceEpoch}_${_random.nextInt(1 << 32)}';
    final sanitized = originalName.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final fileName = '$path/$unique\_$sanitized';

    final uri =
        Uri.parse('${ApiConfig.uploadBaseUrl}?action=upload&folder=$path');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      ),
    );

    final response = await _client.send(request);
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha no upload (${response.statusCode}): $body');
    }
    // Resposta esperada: {"success":true,"id":"...","url":"..."}
    final urlMatch = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(body);
    final idMatch = RegExp(r'"id"\s*:\s*"([^"]+)"').firstMatch(body);
    return UploadResult(
      url: urlMatch != null ? urlMatch.group(1)! : '',
      id: idMatch != null ? idMatch.group(1)! : fileName,
    );
  }
}
