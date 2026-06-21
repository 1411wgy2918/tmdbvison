import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kazumi_tmdb/bean/widget/error_widget.dart';
import 'package:kazumi_tmdb/modules/bangumi/data_source_type.dart';
import 'package:kazumi_tmdb/services/storage/storage.dart';

class BangumiMirrorErrorWidget extends StatelessWidget {
  const BangumiMirrorErrorWidget({
    super.key,
    required this.onRetry,
    this.onSettingsReturned,
    this.dataSource = DataSourceType.bangumi,
  });

  final VoidCallback onRetry;
  final VoidCallback? onSettingsReturned;
  final DataSourceType dataSource;

  @override
  Widget build(BuildContext context) {
    final mirrorEnabled = GStorage.getSetting(SettingsKeys.enableBangumiProxy);

    String errMsg;
    List<Widget> actions;

    if (dataSource == DataSourceType.tmdb) {
      errMsg = '啊咧（⊙.⊙） 无法加载数据\nTMDB 请求失败，请检查网络或配置 TMDB API Key';
      actions = [
        GeneralErrorButton(
          onPressed: () async {
            await Modular.to.pushNamed('/settings/tmdb');
            onSettingsReturned?.call();
          },
          text: 'TMDB 设置',
        ),
        GeneralErrorButton(
          onPressed: onRetry,
          text: '点击重试',
        ),
      ];
    } else {
      errMsg = '啊咧（⊙.⊙） 无法加载数据\nBangumi 镜像${mirrorEnabled ? '已启用' : '已禁用'}';
      actions = [
        GeneralErrorButton(
          onPressed: () async {
            await Modular.to.pushNamed('/settings/webdav/');
            onSettingsReturned?.call();
          },
          text: '镜像开关',
        ),
        GeneralErrorButton(
          onPressed: onRetry,
          text: '点击重试',
        ),
      ];
    }

    return GeneralErrorWidget(
      errMsg: errMsg,
      actions: actions,
    );
  }
}
