import 'package:flutter/foundation.dart';

import 'package:myportofolio_mobile/services/api_client.dart';

/// Menyimpan token autentikasi sesi berjalan di memori.
///
/// [ChangeNotifier] supaya widget lain bisa berlangganan perubahan state
/// (login/logout) melalui provider.
class AuthState extends ChangeNotifier {
  AuthState(this._apiClient, {String? initialToken}) : _token = initialToken;

  final ApiClient _apiClient;
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  /// Menukar username + password dengan token dan menyimpannya di memori.
  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  /// Mencabut token di server lalu mengosongkan state.
  ///
  /// Token tetap dibuang walau request ke server gagal (mis. backend mati),
  /// sehingga UI selalu kembali ke kondisi logout.
  Future<void> logout() async {
    final current = _token;
    if (current == null) return;

    try {
      await _apiClient.logout(token: current);
    } on ApiException {
      // Token tetap dibuang di finally walau server gagal mencabutnya.
    } finally {
      _token = null;
      notifyListeners();
    }
  }
}
