import 'package:kazumi_tmdb/pages/index_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kazumi_tmdb/pages/router.dart';
import 'package:kazumi_tmdb/pages/init_page.dart';
import 'package:flutter/material.dart';
import 'package:kazumi_tmdb/pages/popular/popular_controller.dart';
import 'package:kazumi_tmdb/plugins/plugins_controller.dart';
import 'package:kazumi_tmdb/pages/video/video_controller.dart';
import 'package:kazumi_tmdb/pages/timeline/timeline_controller.dart';
import 'package:kazumi_tmdb/pages/collect/collect_controller.dart';
import 'package:kazumi_tmdb/pages/my/my_controller.dart';
import 'package:kazumi_tmdb/pages/history/history_controller.dart';
import 'package:kazumi_tmdb/pages/video/video_module.dart';
import 'package:kazumi_tmdb/pages/info/info_module.dart';
import 'package:kazumi_tmdb/pages/settings/settings_module.dart';
import 'package:kazumi_tmdb/services/shaders/shader_asset_service.dart';
import 'package:kazumi_tmdb/pages/search/search_module.dart';
import 'package:kazumi_tmdb/repositories/collect_repository.dart';
import 'package:kazumi_tmdb/repositories/search_history_repository.dart';
import 'package:kazumi_tmdb/repositories/collect_crud_repository.dart';
import 'package:kazumi_tmdb/repositories/history_repository.dart';
import 'package:kazumi_tmdb/repositories/download_repository.dart';
import 'package:kazumi_tmdb/services/download/download_manager.dart';
import 'package:kazumi_tmdb/pages/download/download_controller.dart';
import 'package:kazumi_tmdb/bean/widget/image_preview.dart';

class IndexModule extends Module {
  @override
  List<Module> get imports => menu.moduleList;

  @override
  void binds(i) {
    // Repository layer
    i.addSingleton<ICollectRepository>(CollectRepository.new);
    i.addSingleton<ISearchHistoryRepository>(SearchHistoryRepository.new);
    i.addSingleton<ICollectCrudRepository>(CollectCrudRepository.new);
    i.addSingleton<IHistoryRepository>(HistoryRepository.new);
    i.addSingleton<IDownloadRepository>(DownloadRepository.new);

    // Service layer
    i.addSingleton<IDownloadManager>(DownloadManager.new);
    i.addSingleton(ShaderAssetService.new);

    // Controller layer
    i.addSingleton(PopularController.new);
    i.addSingleton(PluginsController.new);
    i.addSingleton(VideoPageController.new);
    i.addSingleton(TimelineController.new);
    i.addSingleton(CollectController.new);
    i.addSingleton(HistoryController.new);
    i.addSingleton(MyController.new);
    i.addSingleton(DownloadController.new);
  }

  @override
  void routes(r) {
    r.child("/",
        child: (_) => const InitPage(),
        children: [
          ChildRoute(
            "/error",
            child: (_) => Scaffold(
              appBar: AppBar(title: const Text("Kazumi")),
              body: const Center(child: Text("初始化失败")),
            ),
          ),
        ],
        transition: TransitionType.noTransition);
    r.child(
      "/tab",
      child: (_) {
        return const IndexPage();
      },
      children: menu.routes,
      transition: TransitionType.fadeIn,
      duration: Duration(milliseconds: 70),
    );
    r.module("/video", module: VideoModule());
    r.child(
      ImageViewer.routePath,
      child: (_) {
        final args = Modular.args.data as ImageViewerRouteArgs;
        return ImageViewer(
          imageUrl: args.imageUrl,
          heroTag: args.heroTag,
        );
      },
      transition: TransitionType.fadeIn,
      duration: Duration(milliseconds: 220),
    );

    /// The route need [ BangumiItem ] as argument.
    r.module("/info", module: InfoModule());
    r.module("/settings", module: SettingsModule());
    r.module("/search", module: SearchModule());
  }
}
