import 'package:card_settings_ui/card_settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kazumi/bean/appbar/sys_app_bar.dart';
import 'package:kazumi/bean/dialog/dialog_helper.dart';
import 'package:kazumi/request/clients/tmdb_client.dart';
import 'package:kazumi/services/data_source/data_source_resolver_pool.dart';
import 'package:kazumi/services/storage/storage.dart';

class TMDBSettingsPage extends StatefulWidget {
  const TMDBSettingsPage({super.key});

  @override
  State<TMDBSettingsPage> createState() => _TMDBSettingsPageState();
}

class _TMDBSettingsPageState extends State<TMDBSettingsPage> {
  final TextEditingController tmdbApiKeyController = TextEditingController();
  bool passwordVisible = false;
  bool isVerifying = false;
  late String defaultDataSource;
  bool syncCollectiblesing = false;

  @override
  void initState() {
    super.initState();
    tmdbApiKeyController.text =
        GStorage.getSetting(SettingsKeys.tmdbApiKey);
    defaultDataSource = GStorage.getSetting(SettingsKeys.defaultDataSource);
  }

  @override
  void dispose() {
    tmdbApiKeyController.dispose();
    super.dispose();
  }

  Future<void> verifyTMDBApiKey() async {
    final token = tmdbApiKeyController.text.trim();
    setState(() {
      isVerifying = true;
    });

    await GStorage.putSetting(SettingsKeys.tmdbApiKey, token);

    if (token.isEmpty) {
      TMDBClient.reset();
      KazumiDialog.showToast(message: 'TMDB API Key 为空，已清除');
      if (!mounted) return;
      setState(() {
        isVerifying = false;
      });
      return;
    }

    // 尝试创建客户端并发起简单请求验证
    try {
      TMDBClient.reset();
      final client = TMDBClient();
      // 尝试获取热门动漫验证 API Key
      await client.get('/trending/tv/day');
      
      KazumiDialog.showToast(message: 'TMDB API Key 验证成功！');
    } catch (e) {
      KazumiDialog.showToast(message: '验证失败：${e.toString()}');
      if (!mounted) return;
      setState(() {
        isVerifying = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isVerifying = false;
    });
  }

  Future<void> updateDefaultDataSource(String value) async {
    await GStorage.putSetting(SettingsKeys.defaultDataSource, value);
    if (!mounted) return;
    setState(() {
      defaultDataSource = value;
    });
    // 更新解析器池的默认数据源
    DataSourceResolverPool.loadDefaultSource();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !syncCollectiblesing,
      child: Scaffold(
        appBar: SysAppBar(
          title: const Text('TMDB 配置'),
          actions: [
            IconButton(
              onPressed: isVerifying
                  ? null
                  : verifyTMDBApiKey,
              icon: isVerifying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: (MediaQuery.of(context).size.width > 1000) ? 1000 : null,
              child: Column(
                children: [
                  TextField(
                    controller: tmdbApiKeyController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'TMDB API Key',
                      border: const OutlineInputBorder(),
                      hintText: '输入您的 TMDB API Key',
                      prefixIcon: IconButton(
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          if (data?.text != null && data!.text!.isNotEmpty) {
                            tmdbApiKeyController.text = data.text!;
                          }
                        },
                        tooltip: '粘贴',
                        icon: const Icon(Icons.paste_rounded),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(passwordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TMDB API Key 用于访问 The Movie Database 获取动漫数据。',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '获取方式：访问 https://www.themoviedb.org/settings/api 申请 API Key',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  SettingsSection(
                    margin: EdgeInsetsDirectional.zero,
                    tiles: [
                      SettingsTile.navigation(
                        title: const Text('默认数据源'),
                        description: const Text('设置应用启动时默认使用的数据源'),
                        value: Text(
                          defaultDataSource == 'tmdb' ? 'TMDB' : 'Bangumi',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        leading: const Icon(Icons.storage),
                        trailing: const Icon(Icons.chevron_right),
                        onPressed: (context) async {
                          final result = await showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('选择默认数据源'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.animation),
                                    title: const Text('Bangumi'),
                                    subtitle: const Text('使用 Bangumi 数据源'),
                                    selected: defaultDataSource == 'bangumi',
                                    onTap: () => Navigator.pop(context, 'bangumi'),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.movie),
                                    title: const Text('TMDB'),
                                    subtitle: const Text('使用 TMDB 数据源'),
                                    selected: defaultDataSource == 'tmdb',
                                    onTap: () => Navigator.pop(context, 'tmdb'),
                                  ),
                                ],
                              ),
                            ),
                          );
                          
                          if (result != null) {
                            await updateDefaultDataSource(result);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
