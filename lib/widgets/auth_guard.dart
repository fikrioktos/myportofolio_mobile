import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Memastikan pengguna sudah terautentikasi sebelum membuka layar tertentu.
///
/// Mengembalikan `true` tanpa navigasi jika sudah login; jika belum, layar
/// [LoginScreen] dibuka dan hasilnya (apakah berhasil login) dikembalikan.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) {
    return true;
  }
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return loggedIn ?? false;
}
