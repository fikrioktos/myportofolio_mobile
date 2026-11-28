import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Exception ketika sebuah request API mengembalikan status non-2xx.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// HTTP client untuk backend MyPortfolio Django REST Framework.
///
/// Kunci header ditulis sebagai string biasa ('Accept', 'Content-Type',
/// 'Authorization') dan bukan HttpHeaders dari dart:io agar klien ini
/// tetap cross-platform (import dart:io merusak build Flutter Web).
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Mengambil seluruh proyek (endpoint publik, tanpa autentikasi).
  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Membuat proyek baru (butuh token, superuser).
  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(project.toJson()),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Project.fromJson(decoded);
  }

  /// Mengambil seluruh pengalaman kerja (endpoint publik, tanpa autentikasi).
  Future<List<Experience>> getExperiences() async {
    final response = await _client.get(
      _uri('/api/v1/experiences/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Experience.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Membuat pengalaman kerja baru (butuh token, superuser/editor).
  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/experiences/'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(experience.toJson()),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Experience.fromJson(decoded);
  }

  /// Menghapus satu pengalaman kerja (butuh token, superuser).
  Future<void> deleteExperience(String id, {required String token}) async {
    final response = await _client.delete(
      _uri('/api/v1/experiences/$id/'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    _ensureSuccess(response);
  }

  /// Memperbarui sebagian pengalaman kerja (PATCH, butuh token).
  Future<Experience> updateExperience(
    Experience experience, {
    required String token,
  }) async {
    final id = experience.id;
    assert(id != null, 'updateExperience membutuhkan id dari server');
    final request = http.Request('PATCH', _uri('/api/v1/experiences/$id/'))
      ..headers['Accept'] = 'application/json'
      ..headers['Content-Type'] = 'application/json; charset=UTF-8'
      ..headers['Authorization'] = 'Token $token'
      ..body = jsonEncode(experience.toJson());
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Experience.fromJson(decoded);
  }

  /// Menukar username + password dengan token autentikasi.
  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  /// Mencabut token di server (endpoint logout Django, Tutorial 10).
  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }
}
