import 'package:kazumi_tmdb/modules/bangumi/data_source_type.dart';
import 'package:kazumi_tmdb/modules/bangumi/bangumi_item.dart';
import 'package:kazumi_tmdb/request/apis/bangumi_api.dart';
import 'package:kazumi_tmdb/request/apis/tmdb_api.dart';
import 'package:kazumi_tmdb/modules/bangumi/tmdb_item.dart';
import 'package:kazumi_tmdb/services/logging/logger.dart';
import 'package:kazumi_tmdb/services/storage/storage.dart';
import 'package:kazumi_tmdb/utils/constants.dart';

/// 数据源解析器池
///
/// 负责根据当前数据源类型路由到对应的 API
class DataSourceResolverPool {
  static DataSourceType _currentSource = DataSourceType.bangumi;

  /// 获取当前数据源
  static DataSourceType get currentSource => _currentSource;

  /// 设置当前数据源
  static void setDataSource(DataSourceType source) {
    if (_currentSource != source) {
      _currentSource = source;
      KazumiLogger().i('数据源已切换：${source.displayName}');
    }
  }

  /// 从设置中加载默认数据源
  static void loadDefaultSource() {
    final defaultSource = GStorage.getSetting(SettingsKeys.defaultDataSource);
    if (defaultSource == 'tmdb') {
      _currentSource = DataSourceType.tmdb;
    } else {
      _currentSource = DataSourceType.bangumi;
    }
  }

  /// 根据数据源获取内容
  static Future<List<BangumiItem>> getContent({
    String? tag,
    int offset = 0,
    String type = 'add',
    bool useMirror = false,
    bool isMovie = false,
  }) async {
    switch (_currentSource) {
      case DataSourceType.bangumi:
        return _getBangumiContent(
          tag: tag,
          offset: offset,
          useMirror: useMirror,
        );
      case DataSourceType.tmdb:
        return _getTMDBContent(
          tag: tag,
          offset: offset,
          isMovie: isMovie,
        );
    }
  }

  /// 根据数据源搜索内容
  static Future<List<BangumiItem>> search({
    required String query,
    int page = 1,
  }) async {
    switch (_currentSource) {
      case DataSourceType.bangumi:
        return _searchBangumi(query: query, page: page);
      case DataSourceType.tmdb:
        return _searchTMDB(query: query, page: page);
    }
  }

  /// 获取 TMDB 内容
  static Future<List<BangumiItem>> _getTMDBContent({
    String? tag,
    int offset = 0,
    bool isMovie = false,
  }) async {
    try {
      final int page = (offset ~/ 20) + 1;
      List<TMDBItem> tmdbItems;

      if (tag == null || tag.isEmpty) {
        if (isMovie) {
          tmdbItems = await TMDBApi.getPopularMovie(page: page);
        } else {
          tmdbItems = await TMDBApi.getPopularTV(page: page);
        }
      } else if (tag.startsWith('Movie:')) {
        final movieTag = tmdbTagMap[tag] ?? tag.replaceFirst('Movie:', '');
        if (movieTag == 'Popular' || movieTag == 'In Theaters') {
          tmdbItems = await TMDBApi.getNowPlayingMovie(page: page);
        } else if (movieTag == 'Top Rated') {
          tmdbItems = await TMDBApi.getTopRatedMovie(page: page);
        } else {
          tmdbItems = await TMDBApi.getMovieByCategory(category: movieTag, page: page);
        }
      } else {
        final resolvedTag = tmdbTagMap[tag] ?? tag;
        if (resolvedTag == 'On The Air') {
          tmdbItems = await TMDBApi.getOnTheAirTV(page: page);
        } else if (resolvedTag == 'Top Rated') {
          tmdbItems = await TMDBApi.getTopRatedTV(page: page);
        } else {
          tmdbItems = await TMDBApi.getTVByCategory(category: resolvedTag, page: page);
        }
      }

      return tmdbItems.map((item) => item.toBangumiItem()).toList();
    } catch (e) {
      KazumiLogger().e('获取 TMDB 内容失败', error: e);
      return [];
    }
  }

  /// 获取 Bangumi 内容
  static Future<List<BangumiItem>> _getBangumiContent({
    String? tag,
    int offset = 0,
    bool useMirror = false,
  }) async {
    try {
      List<BangumiItem> result;
      if (tag == null || tag.isEmpty) {
        // 获取热门
        if (useMirror) {
          result = await BangumiApi.getBangumiMirrorPopularSubjects(
            offset: offset,
          );
        } else {
          result = await BangumiApi.getBangumiTrendsList(offset: offset);
        }
      } else {
        // 按标签获取
        if (useMirror) {
          result = await BangumiApi.getBangumiMirrorPopularSubjects(
            tag: tag,
            offset: offset,
          );
        } else {
          // 随机 rank 获取 Bangumi 列表
          result = await BangumiApi.getBangumiList(
            rank: DateTime.now().millisecondsSinceEpoch % 8000 + 1,
            tag: tag,
          );
        }
      }
      return result;
    } catch (e) {
      KazumiLogger().e('获取 Bangumi 内容失败', error: e);
      return [];
    }
  }

  /// 搜索 TMDB
  static Future<List<BangumiItem>> _searchTMDB({
    required String query,
    required int page,
  }) async {
    try {
      final tmdbItems = await TMDBApi.searchMulti(
        query: query,
        page: page,
      );
      return tmdbItems.map((item) => item.toBangumiItem()).toList();
    } catch (e) {
      KazumiLogger().e('TMDB 搜索失败', error: e);
      return [];
    }
  }

  /// 搜索 Bangumi
  static Future<List<BangumiItem>> _searchBangumi({
    required String query,
    required int page,
  }) async {
    try {
      // 使用现有的 Bangumi 搜索 API
      final result = await BangumiApi.bangumiSearch(
        query,
        offset: (page - 1) * 20,
      );
      return result;
    } catch (e) {
      KazumiLogger().e('Bangumi 搜索失败', error: e);
      return [];
    }
  }
}
