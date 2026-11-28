import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

Experience _sample() => const Experience(
  id: '11111111-1111-1111-1111-111111111111',
  title: 'Staff IT',
  role: 'Staff IT',
  organization: 'BEM Fasilkom UI',
  description: 'Mengelola inventaris IT.',
  category: 'part-time',
  thumbnail: 'https://example.com/thumb.png',
  organizationUrl: 'https://bem.cs.ui.ac.id',
  startedAt: '2025-01-01',
  endedAt: '2025-06-30',
  categoryDisplay: 'Part-Time',
  isOngoing: false,
  starCount: 2,
  isStarred: true,
  starredByNames: 'admin',
);

void main() {
  group('Experience model', () {
    test('toJson memakai snake_case dan tidak mengirim id', () {
      final json = _sample().toJson();

      expect(json.keys, contains('organization_url'));
      expect(json.keys, contains('started_at'));
      expect(json.keys, isNot(contains('id')));
      expect(json.keys, isNot(contains('startAt')));
      expect(json['started_at'], '2025-01-01');
    });

    test('fromJson memberi default untuk field opsional', () {
      final json = _sample().toJson()..remove('organization');
      final parsed = Experience.fromJson(json);

      expect(parsed.organization, '');
      expect(parsed.category, 'part-time');
      expect(parsed.starCount, 0);
      expect(parsed.isStarred, isFalse);
      expect(parsed.starredByNames, '');
    });
  });

  group('ApiClient experiences', () {
    test('getExperiences mem-parsing daftar JSON', () async {
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/api/v1/experiences/');
          expect(
            request.headers['authorization'],
            isNull,
            reason: 'GET publik tanpa header Authorization',
          );
          return http.Response(jsonEncode([_sample().toJson()]), 200);
        }),
      );

      final items = await client.getExperiences();

      expect(items, hasLength(1));
      expect(items.first.title, 'Staff IT');
      expect(items.first.organizationUrl, 'https://bem.cs.ui.ac.id');
    });

    test('getExperiences melempar ApiException pada status non-2xx', () async {
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((request) async => http.Response('error', 500)),
      );

      expect(
        client.getExperiences(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 500)),
      );
    });

    test('createExperience mengirim header Token dan body tanpa id', () async {
      late http.Request captured;
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((request) async {
          captured = request;
          return http.Response(jsonEncode(_sample().toJson()), 201);
        }),
      );

      final created = await client.createExperience(_sample(), token: 'abc');

      expect(created.title, 'Staff IT');
      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/v1/experiences/');
      expect(captured.headers['authorization'], 'Token abc');
      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect(body, isNot(contains('id')));
      expect(body['title'], 'Staff IT');
    });

    test('createExperience melempar ApiException pada 401', () async {
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient(
          (request) async => http.Response('unauthorized', 401),
        ),
      );

      expect(
        client.createExperience(_sample(), token: 'expired'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 401)),
      );
    });

    test('deleteExperience mengirim DELETE terautentikasi', () async {
      late http.Request captured;
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((request) async {
          captured = request;
          return http.Response('', 204);
        }),
      );

      await client.deleteExperience(
        '11111111-1111-1111-1111-111111111111',
        token: 'abc',
      );

      expect(captured.method, 'DELETE');
      expect(
        captured.url.path,
        '/api/v1/experiences/11111111-1111-1111-1111-111111111111/',
      );
      expect(captured.headers['authorization'], 'Token abc');
    });

    test('updateExperience mengirim PATCH ke detail experience', () async {
      late http.Request captured;
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((request) async {
          captured = request;
          return http.Response(jsonEncode(_sample().toJson()), 200);
        }),
      );

      final updated = await client.updateExperience(_sample(), token: 'abc');

      expect(updated.title, 'Staff IT');
      expect(captured.method, 'PATCH');
      expect(
        captured.url.path,
        '/api/v1/experiences/11111111-1111-1111-1111-111111111111/',
      );
      expect(captured.headers['authorization'], 'Token abc');
    });
  });
}
