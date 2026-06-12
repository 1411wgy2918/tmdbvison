import 'package:kazumi/request/clients/tmdb_client.dart';
import 'package:kazumi/modules/bangumi/tmdb_item.dart';
import 'package:kazumi/request/config/api_endpoints.dart';
import 'package:kazumi/services/logging/logger.dart';

/// TMDB API 服务
class TMDBApi {
  static final TMDBClient _client = TMDBClient();

  /// 获取热门番剧
  static Future<List<TMDBItem>> getPopularTV({
    int page = 1,
    String sortBy = 'popularity.desc',
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbPopularAnime,
        queryParameters: {
          'sort_by': sortBy,
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 热门番剧失败', error: e);
      return [];
    }
  }

  /// 获取热门电影
  static Future<List<TMDBItem>> getPopularMovie({
    int page = 1,
    String sortBy = 'popularity.desc',
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbPopularMovie,
        queryParameters: {
          'sort_by': sortBy,
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 热门电影失败', error: e);
      return [];
    }
  }

  /// 获取评分最高的番剧
  static Future<List<TMDBItem>> getTopRatedTV({
    int page = 1,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbTopRatedAnime,
        queryParameters: {
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 评分最高番剧失败', error: e);
      return [];
    }
  }

  /// 获取评分最高的电影
  static Future<List<TMDBItem>> getTopRatedMovie({
    int page = 1,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbTopRatedMovie,
        queryParameters: {
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 评分最高电影失败', error: e);
      return [];
    }
  }

  /// 获取正在播出的番剧
  static Future<List<TMDBItem>> getOnTheAirTV({
    int page = 1,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbAiringToday,
        queryParameters: {
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 正在播出番剧失败', error: e);
      return [];
    }
  }

  /// 获取正在上映的电影
  static Future<List<TMDBItem>> getNowPlayingMovie({
    int page = 1,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbNowPlaying,
        queryParameters: {
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 正在上映电影失败', error: e);
      return [];
    }
  }

  /// 多源搜索（番剧+电影）
  static Future<List<TMDBItem>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.tmdbMultiSearch,
        queryParameters: {
          'query': query,
          'page': page,
          'language': 'zh-CN',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .where((json) {
              final mt = json['media_type'] as String?;
              return mt == 'tv' || mt == 'movie';
            })
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('TMDB 多源搜索失败：$query', error: e);
      return [];
    }
  }

  /// 根据分类获取番剧内容
  static Future<List<TMDBItem>> getTVByCategory({
    required String category,
    int page = 1,
  }) async {
    try {
      final int genreId = _getGenreId(category);
      Map<String, dynamic> queryParameters = {
        'page': page,
        'language': 'zh-CN',
      };
      if (genreId > 0) {
        queryParameters['with_genres'] = genreId.toString();
      }

      final response = await _client.get(
        ApiEndpoints.tmdbPopularAnime,
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 番剧分类内容失败：$category', error: e);
      return [];
    }
  }

  /// 根据分类获取电影内容
  static Future<List<TMDBItem>> getMovieByCategory({
    required String category,
    int page = 1,
  }) async {
    try {
      final int genreId = _getGenreId(category);
      Map<String, dynamic> queryParameters = {
        'page': page,
        'language': 'zh-CN',
      };
      if (genreId > 0) {
        queryParameters['with_genres'] = genreId.toString();
      }

      final response = await _client.get(
        ApiEndpoints.tmdbPopularMovie,
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .whereType<Map<String, dynamic>>()
            .map((json) => TMDBItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      KazumiLogger().e('获取 TMDB 电影分类内容失败：$category', error: e);
      return [];
    }
  }

  /// 获取分类 ID
  static int _getGenreId(String category) {
    const genreMap = {
      'Popular': 0,
      'Top Rated': 0,
      'On The Air': 0,
      'In Theaters': 0,
      'Anime': 16,
      'Action': 28,
      'Adventure': 12,
      'Comedy': 35,
      'Drama': 18,
      'Fantasy': 14,
      'Horror': 27,
      'Science Fiction': 878,
      'Thriller': 53,
      'Romance': 10749,
    };
    return genreMap[category] ?? 0;
  }

  /// 获取详情
  static Future<TMDBItem?> getDetail(int id, {String mediaType = 'tv'}) async {
    try {
      final endpoint = mediaType == 'movie'
          ? ApiEndpoints.tmdbMovieDetail
          : ApiEndpoints.tmdbDetail;
      final response = await _client.get(
        endpoint,
        queryParameters: {
          'append_to_response': 'translations',
        },
      );

      if (response.data is Map<String, dynamic>) {
        final json = response.data as Map<String, dynamic>;
        json['media_type'] = mediaType;
        return TMDBItem.fromJson(json);
      }
      return null;
    } catch (e) {
      KazumiLogger().e('获取 TMDB 详情失败：$id', error: e);
      return null;
    }
  }
}
