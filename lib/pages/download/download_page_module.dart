import 'package:flutter_modular/flutter_modular.dart';
import 'package:kazumi_tmdb/pages/download/download_page.dart';

class DownloadModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const DownloadPage());
  }
}
